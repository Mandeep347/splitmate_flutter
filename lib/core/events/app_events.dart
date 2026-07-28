import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider used as an event bus to signal when an offline sync has completed.
/// Feature modules can watch this to invalidate their own data without
/// coupling the core networking layer to feature providers.
final syncCompletedProvider = StateProvider<int>((ref) => 0);
