import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/currency_chip_selector.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Modal bottom sheet widget for creating a new group.
class CreateGroupSheet extends ConsumerStatefulWidget {
  /// Creates a const [CreateGroupSheet] instance.
  const CreateGroupSheet({super.key});

  /// Displays the create group sheet modal.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const CreateGroupSheet(),
    );
  }

  @override
  ConsumerState<CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends ConsumerState<CreateGroupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedCurrency = 'INR';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(createGroupProvider.notifier)
          .create(
            name: _nameController.text.trim(),
            currency: _selectedCurrency,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final createGroupState = ref.watch(createGroupProvider);
    final isLoading = createGroupState is AsyncLoading;

    // Listens to create group results inside sheet context
    ref.listen<AsyncValue<void>>(createGroupProvider, (previous, next) {
      if (next is AsyncData<void> && previous is AsyncLoading<void>) {
        Navigator.of(context).pop();
      } else if (next is AsyncError<void> && previous is AsyncLoading<void>) {
        final errorMessage = next.error is Failure
            ? (next.error as Failure).message
            : 'Failed to create group.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.all(ext.spaceLG),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'New Group',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ext.spaceLG),
                AppTextField(
                  controller: _nameController,
                  labelText: 'Group Name',
                  hintText: 'Enter group name',
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Group name is required';
                    }
                    if (val.trim().length > 255) {
                      return 'Group name cannot exceed 255 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: ext.spaceLG),
                Text(
                  'Currency',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: ext.spaceSM),
                CurrencyChipSelector(
                  selectedCurrency: _selectedCurrency,
                  onChanged: (currency) {
                    setState(() {
                      _selectedCurrency = currency;
                    });
                  },
                ),
                SizedBox(height: ext.spaceXL),
                PrimaryButton(
                  label: 'Create Group',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
