import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/errors/exceptions.dart';
import 'package:splito_flutter/core/storage/token_storage_service.dart';
import 'package:splito_flutter/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:splito_flutter/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:splito_flutter/features/auth/data/models/token_response_model.dart';
import 'package:splito_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:splito_flutter/features/auth/domain/entities/auth_tokens.dart';

class MockAuthRemoteDatasource extends Mock implements IAuthRemoteDatasource {}

class MockTokenStorageService extends Mock implements ITokenStorageService {}

class MockAuthLocalDatasource extends Mock implements IAuthLocalDatasource {}

void main() {
  late MockAuthRemoteDatasource mockRemoteDatasource;
  late MockTokenStorageService mockTokenStorage;
  late MockAuthLocalDatasource mockLocalDatasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemoteDatasource = MockAuthRemoteDatasource();
    mockTokenStorage = MockTokenStorageService();
    mockLocalDatasource = MockAuthLocalDatasource();
    repository = AuthRepositoryImpl(
      datasource: mockRemoteDatasource,
      tokenStorage: mockTokenStorage,
      localDatasource: mockLocalDatasource,
    );
  });

  group('login', () {
    const email = 'test@example.com';
    const password = 'password123';
    const tokenResponse = TokenResponseModel(
      accessToken: 'access_token_123',
      refreshToken: 'refresh_token_123',
      tokenType: 'Bearer',
    );

    test('returns AuthTokens and saves tokens on success', () async {
      // Arrange
      when(
        () => mockRemoteDatasource.login(email: email, password: password),
      ).thenAnswer((_) async => tokenResponse);
      when(
        () => mockTokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.login(email: email, password: password);

      // Assert
      expect(result, isA<AuthTokens>());
      expect(result.accessToken, equals(tokenResponse.accessToken));
      expect(result.refreshToken, equals(tokenResponse.refreshToken));
      verify(
        () => mockRemoteDatasource.login(email: email, password: password),
      ).called(1);
      verify(
        () => mockTokenStorage.saveTokens(
          accessToken: tokenResponse.accessToken,
          refreshToken: tokenResponse.refreshToken,
        ),
      ).called(1);
    });

    test('throws UnauthorizedException on UnauthorizedException', () async {
      // Arrange
      when(
        () => mockRemoteDatasource.login(email: email, password: password),
      ).thenThrow(const UnauthorizedException('Invalid credentials'));

      // Act & Assert
      expect(
        () => repository.login(email: email, password: password),
        throwsA(isA<UnauthorizedException>()),
      );
      verify(
        () => mockRemoteDatasource.login(email: email, password: password),
      ).called(1);
      verifyNever(
        () => mockTokenStorage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      );
    });

    test('throws NetworkException on NetworkException', () async {
      // Arrange
      when(
        () => mockRemoteDatasource.login(email: email, password: password),
      ).thenThrow(const NetworkException('No connection'));

      // Act & Assert
      expect(
        () => repository.login(email: email, password: password),
        throwsA(isA<NetworkException>()),
      );
      verify(
        () => mockRemoteDatasource.login(email: email, password: password),
      ).called(1);
    });
  });

  group('isAuthenticated', () {
    test('returns true when hasTokens() is true', () async {
      // Arrange
      when(() => mockTokenStorage.hasTokens()).thenAnswer((_) async => true);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, isTrue);
      verify(() => mockTokenStorage.hasTokens()).called(1);
    });

    test('returns false when hasTokens() is false', () async {
      // Arrange
      when(() => mockTokenStorage.hasTokens()).thenAnswer((_) async => false);

      // Act
      final result = await repository.isAuthenticated();

      // Assert
      expect(result, isFalse);
      verify(() => mockTokenStorage.hasTokens()).called(1);
    });
  });

  group('logout', () {
    test('clears tokens and cached user', () async {
      // Arrange
      when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});
      when(
        () => mockLocalDatasource.clearCachedUser(),
      ).thenAnswer((_) async {});

      // Act
      await repository.logout();

      // Assert
      verify(() => mockTokenStorage.clearTokens()).called(1);
      verify(() => mockLocalDatasource.clearCachedUser()).called(1);
    });
  });
}
