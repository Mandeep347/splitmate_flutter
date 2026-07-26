import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/constants/storage_keys.dart';
import 'core/logger/app_logger.dart';
import 'core/errors/global_error_handler.dart';
import 'core/storage/hive_storage_service.dart';
import 'core/utils/package_info_service.dart';
import 'features/settings/presentation/providers/settings_providers.dart';

void main() async {
  // Global error handler initialized first before any other framework calls
  GlobalErrorHandler.initialize();

  // Ensure native bindings are bound before initializing asynchronous services
  WidgetsFlutterBinding.ensureInitialized();

  // Accessibility Audit: Ensure system text scaling is respected without clamping limits.

  // Instantiate Riverpod ProviderContainer for pre-boot DI queries
  final providerContainer = ProviderContainer();

  // Watch logger provider to log bootstrap progress and catch exceptions
  final logger = providerContainer.read(loggerProvider);

  // Set up uncaught Flutter framework error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    logger.error(
      'Uncaught Flutter Framework Error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // Set up uncaught platform-level asynchronous error handler
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    logger.error(
      'Uncaught Asynchronous Platform Error',
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  try {
    logger.info('Loading environment configuration (.env)...');
    await dotenv.load(fileName: 'config/env/.env');

    logger.info('Initializing persistent Hive caching storage services...');
    
    // Access and initialize NoSQL database caching engine (Hive)
    final hiveStorage = providerContainer.read(hiveStorageServiceProvider);
    await hiveStorage.init();

    // Open persistent database files (boxes) required by the app core
    await hiveStorage.openBox(StorageKeys.settingsBox);
    await hiveStorage.openBox(StorageKeys.offlineQueueBox);
    await hiveStorage.openBox(StorageKeys.groupsCacheBox);
    await hiveStorage.openBox(StorageKeys.expensesCacheBox);
    await hiveStorage.openBox(StorageKeys.activityCacheBox);
    
    logger.info('Hive databases successfully mounted.');

    // Pre-warm settings to avoid theme flash on startup
    logger.info('Pre-warming settings configurations...');
    try {
      await providerContainer.read(settingsProvider.future);
      logger.info('Settings pre-warmed successfully.');
    } catch (_) {
      // settings load failure is non-fatal — defaults apply
      logger.warning('Failed to pre-warm settings. Using default configurations.');
    }

    logger.info('Initializing package info service...');
    await PackageInfoService.init();
  } catch (error, stack) {
    logger.error(
      'Pre-boot initialization failed',
      error: error,
      stackTrace: stack,
    );
  }

  logger.info('Starting Splito Application Widget Tree...');

  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const SplitoApp(),
    ),
  );
}
