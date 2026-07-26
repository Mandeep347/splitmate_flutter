import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splito_flutter/core/network/connectivity_service.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
  });

  group('isOnline', () {
    test('returns false when connectivity is none', () async {
      final service = ConnectivityService(
        connectivity: mockConnectivity,
        addressLookup: (_) async => [InternetAddress('8.8.8.8')],
      );

      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      final result = await service.isOnline();

      expect(result, isFalse);
    });

    test('returns true when connectivity and lookup succeed', () async {
      final service = ConnectivityService(
        connectivity: mockConnectivity,
        addressLookup: (_) async => [InternetAddress('8.8.8.8')],
      );

      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = await service.isOnline();

      expect(result, isTrue);
    });

    test('returns false when lookup times out', () async {
      final service = ConnectivityService(
        connectivity: mockConnectivity,
        addressLookup: (_) async {
          throw TimeoutException('DNS lookup timeout');
        },
      );

      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = await service.isOnline();

      expect(result, isFalse);
    });
  });
}
