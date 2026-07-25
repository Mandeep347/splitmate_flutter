import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';

/// Initial loading splash page shown during app authentication state initialization.
class SplashPage extends ConsumerWidget {
  /// Creates a const [SplashPage] instance.
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.grain_rounded,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Splito',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
