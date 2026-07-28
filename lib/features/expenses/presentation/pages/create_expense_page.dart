import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/errors/error_handler.dart';
import 'package:splito_flutter/core/network/connectivity_notifier.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense_split_input.dart';
import 'package:splito_flutter/features/expenses/domain/entities/split_type.dart';
import 'package:splito_flutter/features/expenses/presentation/providers/expense_providers.dart';
import 'package:splito_flutter/features/expenses/presentation/widgets/paid_by_selector.dart';
import 'package:splito_flutter/features/expenses/presentation/widgets/participant_input_section.dart';
import 'package:splito_flutter/features/expenses/presentation/widgets/split_type_selector.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/settings/presentation/providers/settings_providers.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/currency_chip_selector.dart';
import 'package:splito_flutter/shared/widgets/loading_overlay.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Screen allowing the user to create/add a new expense to a group.
class CreateExpensePage extends ConsumerStatefulWidget {
  /// The unique identifier of the group.
  final String groupId;

  /// The name of the group.
  final String groupName;

  /// The default currency code.
  final String currency;

  /// The list of members in this group.
  final List<GroupMember> members;

  /// Creates a const [CreateExpensePage] instance.
  const CreateExpensePage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.currency,
    required this.members,
  });

  @override
  ConsumerState<CreateExpensePage> createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends ConsumerState<CreateExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  SplitType _selectedSplitType = SplitType.equal;
  String? _selectedPaidByUserId;
  ExpenseSplitInput? _currentSplitInput;
  String? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      _selectedPaidByUserId = currentUser.id;
    }
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    setState(() {});
  }

  String _displayName(String? userId, String name, LoggedInUser? me) {
    if (me == null) return name;
    if (userId != null && userId == me.id) return 'You';
    if (userId == null && name == me.name) return 'You';
    return name;
  }

  GroupMember _mapMember(GroupMember m, LoggedInUser? currentUser) {
    final displayName = _displayName(m.userId, m.name, currentUser);
    if (displayName == 'You') {
      return GroupMember(
        userId: m.userId,
        name: 'You',
        email: m.email,
        role: m.role,
        status: m.status,
        joinedAt: m.joinedAt,
      );
    }
    return m;
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return '$currency ';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPaidByUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select who paid for this expense.'),
        ),
      );
      return;
    }

    if (_currentSplitInput == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all participant amounts.'),
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0.0;

    try {
      await ref
          .read(createExpenseProvider.notifier)
          .create(
            groupId: widget.groupId,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null,
            totalAmount: amount,
            currency: _selectedCurrency!,
            paidByUserId: _selectedPaidByUserId!,
            splitInput: _currentSplitInput!,
          );
    } catch (_) {
      // Error is caught via listener
    }
  }

  Widget _buildSplitSummaryCard(String symbol) {
    if (_selectedSplitType != SplitType.equal) return const SizedBox.shrink();
    final input = _currentSplitInput;
    if (input is! EqualSplitInput || input.participants.isEmpty) {
      return const SizedBox.shrink();
    }
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) return const SizedBox.shrink();

    final count = input.participants.length;
    final eachPays = amount / count;

    return Card(
      color: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.15),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Each pays: $symbol${eachPays.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final defaultCurrency = ref.watch(defaultCurrencyProvider);
    _selectedCurrency ??= defaultCurrency;

    final theme = Theme.of(context);
    final currencySymbol = _getCurrencySymbol(_selectedCurrency!);
    final expenseState = ref.watch(createExpenseProvider);

    // Fallback to fetching group members via provider if widget.members was empty
    final fetchedMembers =
        ref.watch(groupMembersProvider(widget.groupId)).valueOrNull ??
        ref.watch(groupDetailProvider(widget.groupId)).valueOrNull?.members ??
        const [];
    final effectiveMembers = widget.members.isNotEmpty
        ? widget.members
        : fetchedMembers;

    final mappedMembers = effectiveMembers
        .map((m) => _mapMember(m, currentUser))
        .toList();

    // Auto-select default paidBy userId if not yet selected or invalid
    if (mappedMembers.isNotEmpty &&
        (_selectedPaidByUserId == null ||
            !mappedMembers.any((m) => m.userId == _selectedPaidByUserId))) {
      _selectedPaidByUserId =
          (currentUser != null &&
              mappedMembers.any((m) => m.userId == currentUser.id))
          ? currentUser.id
          : mappedMembers.first.userId;
    }

    ref.listen<AsyncValue<Expense?>>(createExpenseProvider, (previous, next) {
      if (next is AsyncData<Expense?> && previous is AsyncLoading<Expense?>) {
        final expense = next.value;
        if (expense != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense added successfully!')),
          );
          context.pop();
        }
      } else if (next is AsyncError<Expense?> &&
          previous is AsyncLoading<Expense?>) {
        final isOnline = ref.read(isOnlineProvider);
        final message = AppErrorHandler.toOfflineAwareMessage(
          next.error,
          isOnline,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return LoadingOverlay(
      isLoading: expenseState.isLoading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Expense')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                AppTextField(
                  labelText: 'Title',
                  hintText: 'e.g. Dinner, Groceries',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    if (value.length > 255) {
                      return 'Title cannot exceed 255 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount Field
                AppTextField(
                  labelText: 'Amount',
                  hintText: '0.00',
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      currencySymbol,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Amount is required';
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Currency selector
                Text(
                  'Currency',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CurrencyChipSelector(
                  selectedCurrency: _selectedCurrency!,
                  onChanged: (v) => setState(() => _selectedCurrency = v),
                ),
                const SizedBox(height: 16),

                // Description Field
                AppTextField(
                  labelText: 'Description (Optional)',
                  hintText: 'Add details or notes',
                  controller: _descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Paid By Section
                Text(
                  'Paid by',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                PaidBySelector(
                  members: mappedMembers,
                  selectedUserId: _selectedPaidByUserId,
                  onChanged: (userId) {
                    setState(() {
                      _selectedPaidByUserId = userId;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Split Type Section
                Text(
                  'Split type',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SplitTypeSelector(
                  selectedType: _selectedSplitType,
                  onChanged: (type) {
                    setState(() {
                      _selectedSplitType = type;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Participants Section
                Text(
                  'Participants',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ParticipantInputSection(
                  members: mappedMembers,
                  splitType: _selectedSplitType,
                  currency: widget.currency,
                  onSplitInputChanged: (input) {
                    setState(() {
                      _currentSplitInput = input;
                    });
                  },
                ),

                // Split Summary Card
                _buildSplitSummaryCard(currencySymbol),
                const SizedBox(height: 24),

                // Submit Button
                PrimaryButton(label: 'Add Expense', onPressed: _submit),
              ],
            ),
          ),
            ),
          ),
        ),
      ),
    );
  }
}
