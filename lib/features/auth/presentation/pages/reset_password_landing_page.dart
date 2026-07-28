import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/config/app_branding.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/errors/error_handler.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/auth/presentation/widgets/auth_form_wrapper.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/loading_overlay.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Landing screen processing password reset tokens,
/// containing obscured fields for password selection.
class ResetPasswordLandingPage extends ConsumerStatefulWidget {
  /// The password reset token.
  final String token;

  /// Creates a new [ResetPasswordLandingPage] instance.
  const ResetPasswordLandingPage({super.key, required this.token});

  @override
  ConsumerState<ResetPasswordLandingPage> createState() =>
      _ResetPasswordLandingPageState();
}

class _ResetPasswordLandingPageState
    extends ConsumerState<ResetPasswordLandingPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _success = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .resetPassword(
            token: widget.token,
            newPassword: _passwordController.text,
          );
      if (mounted) {
        setState(() => _success = true);
      }
    } catch (e) {
      if (mounted) {
        final msg = e is Failure
            ? AppErrorHandler.toUserMessage(e)
            : 'Failed to reset password. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authAsync = ref.watch(authNotifierProvider);
    final isLoading = authAsync is AsyncLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      child: AuthFormWrapper(
        title: _success ? 'Success' : 'Create New Password',
        subtitle: _success
            ? 'Your password has been reset successfully'
            : 'Enter and confirm your new secure password',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            if (_success) ...[
              Icon(
                Icons.check_circle_outline_rounded,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Your password has been updated. You can now use your new password to sign in to ${AppBranding.name}.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Sign In',
                onPressed: () => context.goNamed(AppRoutes.loginName),
              ),
            ] else ...[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _passwordController,
                      labelText: 'New Password',
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      textInputAction: TextInputAction.next,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8 || value.length > 128) {
                          return 'Password must be between 8 and 128 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm New Password',
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm password is required';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Reset Password',
                onPressed: _submit,
                isLoading: isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.goNamed(AppRoutes.loginName),
                child: const Text('Cancel'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
