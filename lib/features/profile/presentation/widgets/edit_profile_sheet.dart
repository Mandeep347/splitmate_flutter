import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';
import 'package:splito_flutter/features/profile/presentation/providers/profile_provider.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Modal bottom sheet launcher and form for updating user profile details.
class EditProfileSheet {
  const EditProfileSheet._();

  /// Displays the profile editor dialog.
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    LoggedInUser user,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return _EditProfileForm(user: user);
      },
    );
  }
}

class _EditProfileForm extends ConsumerStatefulWidget {
  final LoggedInUser user;

  const _EditProfileForm({required this.user});

  @override
  ConsumerState<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _selectedCurrency;

  static const List<String> _currencies = [
    'INR',
    'USD',
    'EUR',
    'GBP',
    'SGD',
    'AED',
    'JPY',
    'CAD',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _selectedCurrency = widget.user.preferredCurrency;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(updateProfileNotifierProvider.notifier)
          .updateProfile(
            name: _nameController.text.trim(),
            preferredCurrency: _selectedCurrency,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final updateState = ref.watch(updateProfileNotifierProvider);

    ref.listen<AsyncValue<void>>(updateProfileNotifierProvider, (
      previous,
      next,
    ) {
      if (next is AsyncData<void>) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated')));
      } else if (next is AsyncError) {
        final error = next.error;
        final message = error is Failure ? error.message : error.toString();
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
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Profile',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _nameController,
                labelText: 'Full Name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  if (value.length > 100) {
                    return 'Name must be 100 characters or less';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Preferred Currency',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _currencies.map((currency) {
                  return ChoiceChip(
                    label: Text(currency),
                    selected: _selectedCurrency == currency,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCurrency = currency;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Save Changes',
                isLoading: updateState.isLoading,
                onPressed: updateState.isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
