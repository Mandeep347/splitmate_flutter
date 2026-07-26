import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splito_flutter/core/network/connectivity_notifier.dart';

/// Top overlay banner displaying network status transitions (Offline / Back Online).
/// Automatically slides back up after 3 seconds so it never blocks or overlaps main screen UI.
class ConnectivityBanner extends ConsumerStatefulWidget {
  const ConnectivityBanner({super.key});

  @override
  ConsumerState<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends ConsumerState<ConnectivityBanner> {
  bool? _previousIsOnline;
  bool _isVisible = false;
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _triggerAutoDismiss() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(isOnlineProvider);

    if (_previousIsOnline != isOnline) {
      if (_previousIsOnline != null) {
        _isVisible = true;
        _triggerAutoDismiss();
      }
      _previousIsOnline = isOnline;
    }

    final isOffline = !isOnline;
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

    final backgroundColor = isOffline
        ? const Color(0xFFDC2626) // Sleek Crimson Red
        : const Color(0xFF10B981); // Emerald Green

    final icon = isOffline
        ? Icons.wifi_off_rounded
        : Icons.wifi_rounded;

    final text = isOffline
        ? 'No internet connection'
        : 'Back online';

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
      top: _isVisible ? 0 : -(topPadding + 50),
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          setState(() => _isVisible = false);
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: topPadding + 4,
              bottom: 6,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 15),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
