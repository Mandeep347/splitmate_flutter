import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/errors/error_handler.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/auth/presentation/widgets/auth_form_wrapper.dart';
import 'package:splito_flutter/shared/widgets/app_text_field.dart';
import 'package:splito_flutter/shared/widgets/loading_overlay.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Landing screen that handles incoming email verification link tokens,
/// auto-triggering API verification on open.
class VerifyEmailLandingPage extends ConsumerStatefulWidget {
  /// The link token value.
  final String token;

  /// Creates a new [VerifyEmailLandingPage] instance.
  const VerifyEmailLandingPage({super.key, required this.token});

  @override
  ConsumerState<VerifyEmailLandingPage> createState() =>
      _VerifyEmailLandingPageState();
}

class _VerifyEmailLandingPageState
    extends ConsumerState<VerifyEmailLandingPage> {
  bool _verifying = true;
  String? _successMessage;
  String? _errorMessage;

  // Fallback Resend State
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  int _cooldownSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyToken();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _cooldownSeconds = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds > 0) {
        setState(() => _cooldownSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _verifyToken() async {
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .verifyEmail(token: widget.token);
      if (mounted) {
        setState(() {
          _verifying = false;
          _successMessage =
              'Your email has been verified successfully! You can now sign in.';
        });
      }
    } on Failure catch (e) {
      if (mounted) {
        setState(() {
          _verifying = false;
          _errorMessage = AppErrorHandler.toUserMessage(e);
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _verifying = false;
          _errorMessage =
              'An error occurred during verification. Please try again.';
        });
      }
    }
  }

  Future<void> _resendLink() async {
    if (!_formKey.currentState!.validate() || _cooldownSeconds > 0) return;
    try {
      final email = _emailController.text.trim();
      await ref
          .read(authNotifierProvider.notifier)
          .resendVerification(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification link resent successfully.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        _startCooldown();
      }
    } catch (e) {
      if (mounted) {
        final msg = e is Failure
            ? AppErrorHandler.toUserMessage(e)
            : 'Failed to resend link.';
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
        title: _verifying
            ? 'Verifying Email'
            : _successMessage != null
            ? 'Email Verified'
            : 'Verification Failed',
        subtitle: _verifying
            ? 'Please wait while we confirm your verification link...'
            : _successMessage != null
            ? 'Your account is now active'
            : 'The verification token was rejected',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            if (_verifying) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ] else if (_successMessage != null) ...[
              Icon(
                Icons.check_circle_outline,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                _successMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Sign In',
                onPressed: () => context.goNamed(AppRoutes.loginName),
              ),
            ] else ...[
              Icon(
                Icons.error_outline,
                size: 72,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                _errorMessage ??
                    'This verification link is invalid or has expired.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Request a new verification link:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: AppTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: _cooldownSeconds > 0
                    ? 'Resend Link (${_cooldownSeconds}s)'
                    : 'Resend Link',
                onPressed: _cooldownSeconds > 0 ? null : _resendLink,
                isLoading: isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.goNamed(AppRoutes.loginName),
                child: const Text('Back to Sign In'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
