import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:splito_flutter/features/auth/presentation/providers/auth_provider.dart';

/// A bottom-sheet-style banner shown exclusively on the web platform.
///
/// Behaviour:
/// - Only renders when [kIsWeb] is true.
/// - Waits 3 seconds after first mount (so it doesn't block the initial render).
/// - Auto-dismisses after 30 seconds of no user interaction.
/// - Never shows again after being dismissed within the same session.
/// - Only shown after the user is authenticated (is inside the main shell).
class DownloadAppBanner extends ConsumerStatefulWidget {
  /// Creates a const [DownloadAppBanner] instance.
  const DownloadAppBanner({super.key});

  @override
  ConsumerState<DownloadAppBanner> createState() => _DownloadAppBannerState();
}

class _DownloadAppBannerState extends ConsumerState<DownloadAppBanner>
    with SingleTickerProviderStateMixin {
  static const _githubApiUrl =
      'https://api.github.com/repos/Mandeep347/splito_flutter/releases/latest';
  static const _githubReleasesUrl =
      'https://github.com/Mandeep347/splito_flutter/releases';

  bool _visible = false;
  bool _dismissed = false;
  bool _isFetchingUrl = false;
  String? _apkUrl;

  Timer? _showTimer;
  Timer? _autoDismissTimer;

  late final AnimationController _animController;
  late final Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    // Start the 3-second delay before showing.
    _showTimer = Timer(const Duration(seconds: 3), _tryShow);
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    _autoDismissTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _tryShow() {
    if (_dismissed || !mounted) return;
    // Only show when user is authenticated (inside the main app shell).
    final isAuth =
        ref.read(authNotifierProvider).valueOrNull is AuthStateAuthenticated;
    if (!isAuth) return;

    setState(() => _visible = true);
    _animController.forward();
    _fetchApkUrl();

    // Auto-dismiss after 30 seconds.
    _autoDismissTimer = Timer(const Duration(seconds: 30), _dismiss);
  }

  Future<void> _fetchApkUrl() async {
    setState(() => _isFetchingUrl = true);
    try {
      final dio = Dio();
      final response = await dio.get<dynamic>(_githubApiUrl);
      final data = response.data as Map<String, dynamic>?;
      if (data == null || !mounted) return;
      final assets = data['assets'] as List<dynamic>? ?? [];
      for (final asset in assets) {
        if (asset is Map<String, dynamic>) {
          final name = asset['name'] as String? ?? '';
          if (name.toLowerCase().endsWith('.apk')) {
            if (mounted) {
              setState(() {
                _apkUrl = asset['browser_download_url'] as String?;
              });
            }
            break;
          }
        }
      }
    } catch (_) {
      // Silently ignore — fallback will use releases page.
    } finally {
      if (mounted) setState(() => _isFetchingUrl = false);
    }
  }

  void _dismiss() {
    if (!mounted) return;
    _autoDismissTimer?.cancel();
    _animController.reverse().then((_) {
      if (mounted) setState(() => _dismissed = true);
    });
  }

  Future<void> _onDownloadTap() async {
    final url = _apkUrl ?? _githubReleasesUrl;
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {}
    _dismiss();
  }

  @override
  Widget build(BuildContext context) {
    // Only render on web — compile-time constant, zero overhead on native.
    if (!kIsWeb) return const SizedBox.shrink();
    if (_dismissed || !_visible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1.5),
          end: Offset.zero,
        ).animate(_slideAnim),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(18),
              color: colorScheme.surfaceContainerHighest,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/icon/splash_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Text
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Get Splitmate on Android',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Better experience on the mobile app',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Download button
                    if (_isFetchingUrl)
                      const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      FilledButton(
                        onPressed: _onDownloadTap,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          textStyle: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Download APK'),
                      ),
                    const SizedBox(width: 8),

                    // Dismiss
                    IconButton(
                      onPressed: _dismiss,
                      icon: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      tooltip: 'Not now',
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
