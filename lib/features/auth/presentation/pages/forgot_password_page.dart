import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/auth/presentation/widgets/auth_form_wrapper.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/loading_overlay.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Screen allowing users to request password reset links.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  /// Creates a new [ForgotPasswordPage] instance.
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref.read(authNotifierProvider.notifier).forgotPassword(
            email: _emailController.text.trim(),
          );
      if (mounted) {
        setState(() => _submitted = true);
      }
    } catch (_) {
      // Regardless of failure (e.g. USER_NOT_FOUND), we always present the confirmation
      // screen to prevent email address enumeration attacks.
      if (mounted) {
        setState(() => _submitted = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authNotifierProvider);
    final isLoading = authAsync is AsyncLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      child: AuthFormWrapper(
        title: 'Reset Password',
        subtitle: _submitted
            ? 'Check your inbox'
            : 'Enter your email to receive a password reset link',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            if (_submitted) ...[
              const Icon(
                Icons.mail_outline_rounded,
                size: 72,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                'If an account exists with that email, a recovery link has been sent. Please check your inbox and click the link to reset your password.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Back to Sign In',
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed(AppRoutes.loginName);
                  }
                },
              ),
            ] else ...[
              Form(
                key: _formKey,
                child: AppTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Send Recovery Link',
                onPressed: _submit,
                isLoading: isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed(AppRoutes.loginName);
                  }
                },
                child: const Text('Back to Sign In'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
