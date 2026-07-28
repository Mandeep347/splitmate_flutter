import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/errors/error_handler.dart';
import 'package:splito_flutter/core/network/connectivity_notifier.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/groups/domain/entities/group_member.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/features/settlements/domain/entities/settlement.dart';
import 'package:splito_flutter/features/settlements/presentation/providers/settlement_providers.dart';
import 'package:splito_flutter/features/settings/presentation/providers/settings_providers.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/currency_chip_selector.dart';
import 'package:splito_flutter/shared/widgets/settle_up_button.dart';
import 'package:splito_flutter/shared/widgets/member_avatar.dart';
import 'package:splito_flutter/core/responsive/responsive_layout.dart';

/// Screen form to record a new debt settlement transaction.
class CreateSettlementPage extends ConsumerStatefulWidget {
  /// The unique identifier of the group.
  final String groupId;

  /// The name of the group.
  final String groupName;

  /// The default currency code.
  final String currency;

  /// The list of members in this group.
  final List<GroupMember> members;

  /// Prefilled user ID representing the payer (who paid).
  final String? prefilledFromUserId;

  /// Prefilled user ID representing the payee (who was paid).
  final String? prefilledToUserId;

  /// Creates a const [CreateSettlementPage] instance.
  const CreateSettlementPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.currency,
    required this.members,
    this.prefilledFromUserId,
    this.prefilledToUserId,
  });

  @override
  ConsumerState<CreateSettlementPage> createState() =>
      _CreateSettlementPageState();
}

class _CreateSettlementPageState extends ConsumerState<CreateSettlementPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String? _selectedFromUserId;
  String? _selectedToUserId;
  String? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedFromUserId =
        widget.prefilledFromUserId ?? ref.read(currentUserProvider)?.id;
    _selectedToUserId = widget.prefilledToUserId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _displayName(String? userId, String name, LoggedInUser? me) {
    if (me == null) return name;
    if (userId != null && userId == me.id) return 'You';
    if (userId == null && name == me.name) return 'You';
    return name;
  }

  String _paidToLabel(String toUserId, String toName, LoggedInUser? me) {
    if (me != null && toUserId == me.id) return 'you';
    return toName;
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return '$currencyCode ';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFromUserId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select who paid')));
      return;
    }
    if (_selectedToUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select who was paid')),
      );
      return;
    }
    if (_selectedFromUserId == _selectedToUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot settle with yourself')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    try {
      await ref
          .read(createSettlementProvider.notifier)
          .create(
            groupId: widget.groupId,
            fromUserId: _selectedFromUserId!,
            toUserId: _selectedToUserId!,
            amount: amount,
            currency: _selectedCurrency!,
            note: _noteController.text.trim().isNotEmpty
                ? _noteController.text.trim()
                : null,
          );
    } catch (_) {
      // Silent catch to suppress duplicate UI popups
    }
  }

  final _fromKey = GlobalKey();
  final _toKey = GlobalKey();

  void _swapFromTo() {
    setState(() {
      final temp = _selectedFromUserId;
      _selectedFromUserId = _selectedToUserId;
      _selectedToUserId = temp;
    });
  }

  Widget _buildSelector(
    BuildContext context, {
    required bool isFrom,
    required LoggedInUser? currentUser,
    required List<GroupMember> membersList,
  }) {
    final theme = Theme.of(context);
    final key = isFrom ? _fromKey : _toKey;
    final selectedId = isFrom ? _selectedFromUserId : _selectedToUserId;
    final selectedMember = membersList.firstWhere(
      (m) => m.userId == selectedId,
      orElse: () => GroupMember(
        userId: '',
        name: '',
        email: '',
        role: 'MEMBER',
        status: 'ACTIVE',
        joinedAt: DateTime.now(),
      ),
    );
    final hasSelection = selectedId != null && selectedMember.userId.isNotEmpty;
    final nameLabel = hasSelection
        ? _displayName(selectedMember.userId, selectedMember.name, currentUser)
        : 'Select member';

    return InkWell(
      key: key,
      onTap: () => _showMemberPicker(
        context,
        isFrom: isFrom,
        currentUser: currentUser,
        membersList: membersList,
      ),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: isFrom ? 'Paid By' : 'Paid To',
          prefixIcon: hasSelection
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MemberAvatar(name: selectedMember.name, radius: 12),
                )
              : const Icon(Icons.person_outline),
          suffixIcon: const Icon(Icons.arrow_drop_down),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        child: Text(
          nameLabel,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: hasSelection ? null : theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void _showMemberPicker(
    BuildContext context, {
    required bool isFrom,
    required LoggedInUser? currentUser,
    required List<GroupMember> membersList,
  }) async {
    final theme = Theme.of(context);
    final isDesktop =
        ResponsiveLayout.isDesktop(context) ||
        ResponsiveLayout.isTablet(context);

    final disabledUserId = isFrom ? _selectedToUserId : _selectedFromUserId;

    if (!isDesktop) {
      // Bottom sheet on Mobile
      final GroupMember? result = await showModalBottomSheet<GroupMember>(
        context: context,
        backgroundColor: theme.colorScheme.surfaceContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    isFrom ? 'Who paid?' : 'Paid to?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: membersList.length,
                    itemBuilder: (context, index) {
                      final member = membersList[index];
                      final isDisabled = member.userId == disabledUserId;
                      final memberDisplayName = _displayName(
                        member.userId,
                        member.name,
                        currentUser,
                      );

                      return ListTile(
                        leading: MemberAvatar(name: member.name, radius: 14),
                        title: Text(
                          memberDisplayName,
                          style: TextStyle(
                            color: isDisabled
                                ? theme.colorScheme.onSurface.withValues(
                                    alpha: 0.38,
                                  )
                                : null,
                            fontWeight: isDisabled
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        enabled: !isDisabled,
                        onTap: () => Navigator.pop(context, member),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
      if (result != null) {
        setState(() {
          if (isFrom) {
            _selectedFromUserId = result.userId;
          } else {
            _selectedToUserId = result.userId;
          }
        });
      }
    } else {
      // Popover menu on Desktop / Tablet
      final key = isFrom ? _fromKey : _toKey;
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final offset = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromLTWH(offset.dx, offset.dy + size.height, size.width, 0),
        Offset.zero & MediaQuery.of(context).size,
      );

      final GroupMember? result = await showMenu<GroupMember>(
        context: context,
        position: position,
        items: membersList.map((member) {
          final isDisabled = member.userId == disabledUserId;
          final memberDisplayName = _displayName(
            member.userId,
            member.name,
            currentUser,
          );
          return PopupMenuItem<GroupMember>(
            value: member,
            enabled: !isDisabled,
            child: Row(
              children: [
                MemberAvatar(name: member.name, radius: 12),
                const SizedBox(width: 8),
                Text(
                  memberDisplayName,
                  style: TextStyle(
                    color: isDisabled
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                        : null,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );

      if (result != null) {
        setState(() {
          if (isFrom) {
            _selectedFromUserId = result.userId;
          } else {
            _selectedToUserId = result.userId;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final defaultCurrency = ref.watch(defaultCurrencyProvider);
    _selectedCurrency ??= defaultCurrency;

    final theme = Theme.of(context);
    final currencySymbol = _getCurrencySymbol(_selectedCurrency!);
    final createSettlementState = ref.watch(createSettlementProvider);

    final fetchedMembers =
        ref.watch(groupMembersProvider(widget.groupId)).valueOrNull ??
        ref.watch(groupDetailProvider(widget.groupId)).valueOrNull?.members ??
        const [];
    final membersList = widget.members.isNotEmpty
        ? widget.members
        : fetchedMembers;

    ref.listen<AsyncValue<Settlement?>>(createSettlementProvider, (
      previous,
      next,
    ) {
      if (next is AsyncData<Settlement?> &&
          previous is AsyncLoading<Settlement?>) {
        final settlement = next.value;
        if (settlement != null) {
          final fromText = _displayName(
            settlement.fromUserId,
            settlement.fromUserName,
            currentUser,
          );
          final toText = _paidToLabel(
            settlement.toUserId,
            settlement.toUserName,
            currentUser,
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$fromText paid $toText')));
          context.pop();
        }
      } else if (next is AsyncError<Settlement?> &&
          previous is AsyncLoading<Settlement?>) {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Record Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 500;

                  final fromWidget = isWide
                      ? Expanded(
                          child: _buildSelector(
                            context,
                            isFrom: true,
                            currentUser: currentUser,
                            membersList: membersList,
                          ),
                        )
                      : _buildSelector(
                          context,
                          isFrom: true,
                          currentUser: currentUser,
                          membersList: membersList,
                        );

                  final toWidget = isWide
                      ? Expanded(
                          child: _buildSelector(
                            context,
                            isFrom: false,
                            currentUser: currentUser,
                            membersList: membersList,
                          ),
                        )
                      : _buildSelector(
                          context,
                          isFrom: false,
                          currentUser: currentUser,
                          membersList: membersList,
                        );

                  final swapButton = Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _swapFromTo,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.15,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Icon(
                          isWide
                              ? Icons.swap_horiz_rounded
                              : Icons.swap_vert_rounded,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        fromWidget,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: swapButton,
                        ),
                        toWidget,
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        fromWidget,
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: swapButton,
                        ),
                        toWidget,
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // Section 3: Amount
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

              // Section 4: Note
              AppTextField(
                labelText: 'Note (Optional)',
                hintText: 'e.g. Paid via UPI, Cash…',
                controller: _noteController,
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Section 5: Record Payment Button
              SettleUpButton(
                onPressed: _submit,
                isLoading: createSettlementState.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
