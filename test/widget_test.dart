import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/app.dart';
import 'package:splito_flutter/core/storage/token_storage_service.dart';

class FakeTokenStorageService implements ITokenStorageService {
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {}

  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<void> clearTokens() async {}

  @override
  Future<bool> hasTokens() async => false;
}

void main() {
  testWidgets('App initialization compile test', (WidgetTester tester) async {
    // Build our app and trigger a frame within ProviderScope with mocked token storage.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenStorageServiceProvider.overrideWithValue(
            FakeTokenStorageService(),
          ),
        ],
        child: const SplitoApp(),
      ),
    );
  });
}
