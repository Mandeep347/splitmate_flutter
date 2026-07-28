import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:splito_flutter/core/constants/storage_keys.dart';
import 'package:splito_flutter/core/errors/failures.dart';
import 'package:splito_flutter/core/router/route_names.dart';
import 'package:splito_flutter/core/storage/hive_storage_service.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/auth/presentation/widgets/auth_form_wrapper.dart';
import 'package:splito_flutter/shared/widgets/loading_overlay.dart';
import 'package:splito_flutter/shared/widgets/primary_button.dart';

/// Screen notifying the user that verification email was sent,
/// offering verification email resend with a 24-hour cooldown.
class EmailVerificationPendingPage extends ConsumerStatefulWidget {
  /// The attempted registration email address.
  final String email;

  /// Creates a new [EmailVerificationPendingPage] instance.
  const EmailVerificationPendingPage({super.key, required this.email});

  @override
  ConsumerState<EmailVerificationPendingPage> createState() =>
      _EmailVerificationPendingPageState();
}

class _EmailVerificationPendingPageState
    extends ConsumerState<EmailVerificationPendingPage> {
  static const int _twentyFourHoursMs = 24 * 60 * 60 * 1000;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int? _getRemainingCooldownMs() {
    final hive = ref.read(hiveStorageServiceProvider);
    final int? lastTs = hive.read<int>(
      StorageKeys.settingsBox,
      'last_resend_ts',
    );
    if (lastTs == null) return null;

    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsed = now - lastTs;
    if (elapsed >= _twentyFourHoursMs) {
      return null;
    }
    return _twentyFourHoursMs - elapsed;
  }

  String? _getCountdownText() {
    final remainingMs = _getRemainingCooldownMs();
    if (remainingMs == null) return null;

    final duration = Duration(milliseconds: remainingMs);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return 'Resend available in ${hours}h ${minutes}m';
  }

  Future<void> _resend() async {
    if (_getRemainingCooldownMs() != null) return;
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .resendVerification(email: widget.email);
      final hive = ref.read(hiveStorageServiceProvider);
      await hive.write<int>(
        StorageKeys.settingsBox,
        'last_resend_ts',
        DateTime.now().millisecondsSinceEpoch,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification email sent to ${widget.email}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        final message = e is Failure
            ? e.message
            : 'Failed to resend verification email.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
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
    final countdownText = _getCountdownText();
    final isCooldownActive = countdownText != null;

    return LoadingOverlay(
      isLoading: isLoading,
      child: AuthFormWrapper(
        title: 'Verify your email',
        subtitle: 'We sent a verification link to your email address',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Icon(
              Icons.mark_email_read_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'A verification email has been sent to:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.email,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Please click the link inside that email to activate your account. If you do not see it, please check your spam folder.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: isCooldownActive ? countdownText : 'Resend Email',
              onPressed: isCooldownActive ? null : _resend,
              isLoading: isLoading,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.goNamed(AppRoutes.loginName),
              child: const Text('Back to Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
