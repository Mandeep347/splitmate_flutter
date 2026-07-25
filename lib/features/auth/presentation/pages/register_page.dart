import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/auth/presentation/widgets/auth_form_wrapper.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/loading_overlay.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Full screen view handling user registration account creation.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Changed: async so the rethrow from register() does not leak
  // into the Dart error zone as RethrownDartError.
  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final email = _emailController.text.trim();
        await ref.read(authNotifierProvider.notifier).register(
              name: _nameController.text.trim(),
              email: email,
              password: _passwordController.text,
            );
        if (mounted) {
          context.goNamed(
            AppRoutes.verifyEmailPendingName,
            extra: email,
          );
        }
      } catch (_) {
        // Error is already handled via ref.listen on authNotifierProvider.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listens to authentication state updates reactive-style
    ref.listen<AsyncValue<AuthState>>(
      authNotifierProvider,
      (previous, next) {
        // Show error and clear loading state on failure
        if (next is AsyncError) {
          final error = next.error;
          final message = error is Failure
              ? error.message
              : 'Registration failed. Please try again.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );

    final authAsync = ref.watch(authNotifierProvider);
    final isLoading = authAsync is AsyncLoading;

    return LoadingOverlay(
      isLoading: isLoading,
      child: AuthFormWrapper(
        title: 'Create Account',
        subtitle: 'Sign up to start splitting expenses with Splito',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'John Doe',
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.person_outline),
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
              const SizedBox(height: 16),
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
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
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
                labelText: 'Confirm Password',
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
                onFieldSubmitted: (_) => _submit(),
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
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Create Account',
                isLoading: isLoading,
                onPressed: _submit,
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
                child: const Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
