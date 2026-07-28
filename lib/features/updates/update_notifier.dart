import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'update_service.dart';

/// Represents the state of an update check operation.
enum UpdateStatus {
  /// No check has been initiated yet.
  idle,

  /// A check is currently in progress.
  checking,

  /// The check completed and the app is already on the latest version.
  upToDate,

  /// A newer version is available for download.
  updateAvailable,
}

/// Immutable state for the [UpdateNotifier].
class UpdateState {
  /// Current status of the update check.
  final UpdateStatus status;

  /// Available update details (non-null only when [status] is [UpdateStatus.updateAvailable]).
  final UpdateInfo? updateInfo;

  /// Optional error message (currently unused — errors are silently swallowed).
  final String? errorMessage;

  const UpdateState({
    this.status = UpdateStatus.idle,
    this.updateInfo,
    this.errorMessage,
  });

  /// Returns a copy with updated fields.
  UpdateState copyWith({
    UpdateStatus? status,
    UpdateInfo? updateInfo,
    String? errorMessage,
  }) {
    return UpdateState(
      status: status ?? this.status,
      updateInfo: updateInfo ?? this.updateInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Notifier managing update-check state using the GitHub Releases API.
class UpdateNotifier extends AsyncNotifier<UpdateState> {
  @override
  Future<UpdateState> build() async {
    return const UpdateState(status: UpdateStatus.idle);
  }

  /// Initiates a manual update check against GitHub Releases.
  Future<void> checkForUpdate() async {
    state = const AsyncData(UpdateState(status: UpdateStatus.checking));

    final info = await ref.read(updateServiceProvider).checkForUpdate();

    if (info != null) {
      state = AsyncData(
        UpdateState(status: UpdateStatus.updateAvailable, updateInfo: info),
      );
    } else {
      state = const AsyncData(UpdateState(status: UpdateStatus.upToDate));
    }
  }

  /// Opens the APK download URL in the device's external browser / download manager.
  Future<void> downloadUpdate() async {
    final url = state.valueOrNull?.updateInfo?.downloadUrl;
    if (url == null) return;

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      // Silently ignore launch failures.
    }
  }
}

/// Provider for the [UpdateNotifier].
final updateNotifierProvider =
    AsyncNotifierProvider<UpdateNotifier, UpdateState>(UpdateNotifier.new);
