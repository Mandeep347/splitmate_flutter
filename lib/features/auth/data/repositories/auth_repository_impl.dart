import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/storage/token_storage_service.dart';
import 'package:splito_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:splito_flutter/features/auth/domain/entities/logged_in_user.dart';
import 'package:splito_flutter/features/auth/domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of the domain [IAuthRepository] contract.
class AuthRepositoryImpl implements IAuthRepository {
  /// The remote datasource dependency.
  final IAuthRemoteDatasource datasource;

  /// The token secure storage service dependency.
  final ITokenStorageService tokenStorage;

  /// The local datasource dependency.
  final IAuthLocalDatasource localDatasource;

  /// Creates a new [AuthRepositoryImpl] instance.
  const AuthRepositoryImpl({
    required this.datasource,
    required this.tokenStorage,
    required this.localDatasource,
  });

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final tokenResponse = await datasource.login(
      email: email,
      password: password,
    );
    await tokenStorage.saveTokens(
      accessToken: tokenResponse.accessToken,
      refreshToken: tokenResponse.refreshToken,
    );
    return tokenResponse.toEntity();
  }

  @override
  Future<LoggedInUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final userModel = await datasource.register(
      name: name,
      email: email,
      password: password,
    );
    return userModel.toEntity();
  }

  @override
  Future<AuthTokens> refreshTokens({required String refreshToken}) async {
    final tokenResponse = await datasource.refresh(refreshToken: refreshToken);
    await tokenStorage.saveTokens(
      accessToken: tokenResponse.accessToken,
      refreshToken: tokenResponse.refreshToken,
    );
    return tokenResponse.toEntity();
  }

  @override
  Future<LoggedInUser> getMe() async {
    try {
      final userModel = await datasource.getMe();
      await localDatasource.cacheUser(userModel);
      return userModel.toEntity();
    } on NetworkException {
      // Offline fallback — only exception repo handles directly
      final cachedUser = await localDatasource.getCachedUser();
      if (cachedUser != null) return cachedUser.toEntity();
      rethrow; // let usecase map this to NetworkFailure
    }
  }

  @override
  Future<void> logout() async {
    await tokenStorage.clearTokens();
    await localDatasource.clearCachedUser();
  }

  @override
  Future<bool> isAuthenticated() async {
    return tokenStorage.hasTokens();
  }

  @override
  Future<LoggedInUser> updateMe({
    String? name,
    String? preferredCurrency,
  }) async {
    final userModel = await datasource.updateMe(
      name: name,
      preferredCurrency: preferredCurrency,
    );
    return userModel.toEntity();
  }

  @override
  Future<void> verifyEmail({required String token}) async {
    await datasource.verifyEmail(token: token);
  }

  @override
  Future<void> resendVerification({required String email}) async {
    await datasource.resendVerification(email: email);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await datasource.forgotPassword(email: email);
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await datasource.resetPassword(token: token, newPassword: newPassword);
  }
}

/// Provider exposing [IAuthRepository] implementation.
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final datasource = ref.watch(authRemoteDatasourceProvider);
  final tokenStorage = ref.watch(tokenStorageServiceProvider);
  final localDatasource = ref.watch(authLocalDatasourceProvider);
  return AuthRepositoryImpl(
    datasource: datasource,
    tokenStorage: tokenStorage,
    localDatasource: localDatasource,
  );
});
