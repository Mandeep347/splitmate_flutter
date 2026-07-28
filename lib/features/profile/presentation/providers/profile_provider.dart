import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:splito_flutter/features/profile/domain/usecases/update_profile_usecase.dart';

/// Provider exposing [UpdateProfileUseCase].
final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdateProfileUseCase(repository: repository);
});

/// Notifier executing profile update operations.
class UpdateProfileNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Default initial state
  }

  /// Triggers update operation via [UpdateProfileUseCase].
  /// On success, invalidates [authNotifierProvider] to refresh credentials.
  Future<void> updateProfile({String? name, String? preferredCurrency}) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard<void>(() async {
      final useCase = ref.read(updateProfileUseCaseProvider);
      await useCase(name: name, preferredCurrency: preferredCurrency);

      // Invalidate the auth notifier provider to re-fetch the user details
      ref.invalidate(authNotifierProvider);
    });
  }
}

/// Global provider for [UpdateProfileNotifier].
final updateProfileNotifierProvider =
    AsyncNotifierProvider<UpdateProfileNotifier, void>(() {
      return UpdateProfileNotifier();
    });
