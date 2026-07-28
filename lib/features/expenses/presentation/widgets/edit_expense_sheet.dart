import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/expenses/domain/entities/expense.dart';
import 'package:splito_flutter/features/expenses/presentation/providers/expense_providers.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Helper utility class to display the edit expense bottom sheet.
class EditExpenseSheet {
  const EditExpenseSheet._();

  /// Displays the edit expense bottom sheet.
  static Future<void> show(BuildContext context, Expense expense) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _EditExpenseSheetContent(expense: expense),
    );
  }
}

class _EditExpenseSheetContent extends ConsumerStatefulWidget {
  final Expense expense;

  const _EditExpenseSheetContent({required this.expense});

  @override
  ConsumerState<_EditExpenseSheetContent> createState() =>
      _EditExpenseSheetContentState();
}

class _EditExpenseSheetContentState
    extends ConsumerState<_EditExpenseSheetContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _descriptionController = TextEditingController(
      text: widget.expense.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref
          .read(updateExpenseProvider.notifier)
          .updateExpense(
            expenseId: widget.expense.id,
            groupId: widget.expense.groupId,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null,
          );
    } catch (_) {
      // Silent catch; handled via Riverpod state listeners
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updateState = ref.watch(updateExpenseProvider);

    // Listen to changes in the updateExpenseProvider
    ref.listen<AsyncValue<void>>(updateExpenseProvider, (previous, next) {
      if (next is AsyncData<void> && previous is AsyncLoading<void>) {
        Navigator.of(context).pop();
      } else if (next is AsyncError<void> && previous is AsyncLoading<void>) {
        final failure = next.error;
        final message = failure is Failure
            ? failure.message
            : 'Failed to update expense.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Drag Handle indicator
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Text(
                'Edit Expense',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Info Subtitle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Only title and description can be edited. To change the amount or split, reverse this expense and create a new one.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title Input
              AppTextField(
                labelText: 'Title',
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

              // Description Input
              AppTextField(
                labelText: 'Description (Optional)',
                hintText: 'Add a note…',
                controller: _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Save Button
              PrimaryButton(
                label: 'Save Changes',
                isLoading: updateState.isLoading,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
