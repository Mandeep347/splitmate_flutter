import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/config/app_branding.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/errors/error_handler.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/auth/presentation/widgets/auth_form_wrapper.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/loading_overlay.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Full screen view handling user credential login operations.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Changed: async so the unawaited rethrow from login() does not
  // leak into the Dart error zone as RethrownDartError.
  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref
            .read(authNotifierProvider.notifier)
            .login(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
      } catch (_) {
        // Error is already handled via ref.listen on authNotifierProvider.
        // This catch prevents the rethrow from surfacing as an
        // unhandled future in the Dart error zone (RethrownDartError).
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listens to authentication state updates reactive-style
    ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (previous, next) {
      if (next.valueOrNull is AuthStateAuthenticated) {
        context.goNamed(AppRoutes.groupsName);
        return;
      }
      // Show error and clear loading state on failure
      if (next is AsyncError) {
        final error = next.error;
        if (error is Failure &&
            (error.code?.toUpperCase() == 'EMAIL_NOT_VERIFIED' ||
                error.message.toLowerCase().contains('verify your email'))) {
          context.goNamed(
            AppRoutes.verifyEmailPendingName,
            extra: _emailController.text.trim(),
          );
          return;
        }
        final message = error is Failure
            ? AppErrorHandler.toUserMessage(error)
            : 'Login failed. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final authAsync = ref.watch(authNotifierProvider);
    final isLoading = authAsync is AsyncLoading;
    final theme = Theme.of(context);

    return LoadingOverlay(
      isLoading: isLoading,
      child: AuthFormWrapper(
        title: 'Welcome back',
        subtitle: 'Sign in to your ${AppBranding.name} account',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.email_outlined),
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
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                labelText: 'Password',
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                onFieldSubmitted: (_) => _submit(),
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.forgotPasswordName);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Sign In',
                isLoading: isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pushNamed(AppRoutes.registerName),
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
