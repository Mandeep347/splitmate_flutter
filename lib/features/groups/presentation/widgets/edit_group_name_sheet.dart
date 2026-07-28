import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/theme/theme_extensions.dart';
import 'package:splito_flutter/features/groups/domain/entities/group.dart';
import 'package:splito_flutter/features/groups/presentation/providers/group_providers.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Modal bottom sheet widget for editing a group's name.
class EditGroupNameSheet extends ConsumerStatefulWidget {
  /// The group data record.
  final Group group;

  /// Creates a const [EditGroupNameSheet] instance.
  const EditGroupNameSheet({super.key, required this.group});

  /// Displays the sheet.
  static Future<void> show(BuildContext context, Group group) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => EditGroupNameSheet(group: group),
    );
  }

  @override
  ConsumerState<EditGroupNameSheet> createState() => _EditGroupNameSheetState();
}

class _EditGroupNameSheetState extends ConsumerState<EditGroupNameSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(updateGroupProvider.notifier)
          .updateGroup(
            groupId: widget.group.id,
            name: _nameController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final updateState = ref.watch(updateGroupProvider);
    final isLoading = updateState is AsyncLoading;

    // Listen to update state changes to pop sheet and show success/error SnackBar
    ref.listen<AsyncValue<void>>(updateGroupProvider, (previous, next) {
      if (next is AsyncData<void> && previous is AsyncLoading<void>) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Group updated!')));
      } else if (next is AsyncError<void> && previous is AsyncLoading<void>) {
        final errorMessage = next.error is Failure
            ? (next.error as Failure).message
            : 'Failed to update group name.';
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
                  'Edit Group Name',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ext.spaceLG),
                AppTextField(
                  controller: _nameController,
                  labelText: 'Group Name',
                  hintText: 'Enter new name',
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
                SizedBox(height: ext.spaceXL),
                PrimaryButton(
                  label: 'Save',
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
