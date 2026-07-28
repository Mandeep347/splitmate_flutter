import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:splito_flutter/core/router/route_names.dart';

/// Standalone download page at [AppRoutes.downloadPath].
///
/// Does NOT require authentication — it is a public portfolio/marketing page
/// that visitors can reach directly at /download.
class DownloadPage extends StatefulWidget {
  /// Creates a const [DownloadPage] instance.
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with SingleTickerProviderStateMixin {
  static const _githubApiUrl =
      'https://api.github.com/repos/Mandeep347/splito_flutter/releases/latest';
  static const _githubReleasesUrl =
      'https://github.com/Mandeep347/splito_flutter/releases';
  static const _githubSourceUrl =
      'https://github.com/Mandeep347/splito_flutter';

  bool _isFetchingUrl = true;
  String? _apkUrl;
  String? _latestVersion;
  int? _apkSizeBytes;

  late final AnimationController _animController;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _fetchLatestRelease();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetchLatestRelease() async {
    try {
      final dio = Dio();
      final response = await dio.get<dynamic>(_githubApiUrl);
      final data = response.data as Map<String, dynamic>?;
      if (data == null || !mounted) return;

      final tagName = data['tag_name'] as String? ?? '';
      final assets = data['assets'] as List<dynamic>? ?? [];

      String? apkUrl;
      int? apkSize;
      for (final asset in assets) {
        if (asset is Map<String, dynamic>) {
          final name = asset['name'] as String? ?? '';
          if (name.toLowerCase().endsWith('.apk')) {
            apkUrl = asset['browser_download_url'] as String?;
            apkSize = asset['size'] as int?;
            break;
          }
        }
      }

      if (mounted) {
        setState(() {
          _latestVersion = tagName.isNotEmpty ? tagName : null;
          _apkUrl = apkUrl;
          _apkSizeBytes = apkSize;
          _isFetchingUrl = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isFetchingUrl = false);
      }
    }
  }

  Future<void> _onDownloadTap() async {
    final url = _apkUrl ?? _githubReleasesUrl;
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _onGithubTap() async {
    try {
      await launchUrl(
        Uri.parse(_githubSourceUrl),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
  }

  String _formatSize(int bytes) {
    if (bytes > 1024 * 1024) {
      return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    return '${(bytes / 1024).toStringAsFixed(0)} KB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isNarrow = size.width < 600;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: FadeTransition(
        opacity: _fadeIn,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isNarrow ? 24 : 48,
                  vertical: isNarrow ? 48 : 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── App logo ──────────────────────────────────────────
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.4),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          'assets/icon/splash_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── App name ──────────────────────────────────────────
                    Text(
                      'Splitmate',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    // ── Tagline ───────────────────────────────────────────
                    Text(
                      'Split expenses. Settle debts. Stay friends.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // ── Download section ──────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.android_rounded,
                                color: Color(0xFF3DDC84),
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Download for Android',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Version + size info
                          if (!_isFetchingUrl) ...[
                            if (_latestVersion != null || _apkSizeBytes != null)
                              Wrap(
                                spacing: 12,
                                runSpacing: 6,
                                alignment: WrapAlignment.center,
                                children: [
                                  if (_latestVersion != null)
                                    _InfoChip(
                                      icon: Icons.tag_rounded,
                                      label: _latestVersion!,
                                      color: colorScheme.primary,
                                    ),
                                  if (_apkSizeBytes != null)
                                    _InfoChip(
                                      icon: Icons.download_outlined,
                                      label: _formatSize(_apkSizeBytes!),
                                      color: colorScheme.secondary,
                                    ),
                                ],
                              ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: _onDownloadTap,
                                icon: const Icon(Icons.download_rounded),
                                label: const Text('Download APK'),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  textStyle: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 20),
                            const CircularProgressIndicator(),
                            const SizedBox(height: 12),
                            Text(
                              'Fetching latest release…',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Tech stack chips ──────────────────────────────────
                    const Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _TechChip('Flutter'),
                        _TechChip('FastAPI'),
                        _TechChip('PostgreSQL'),
                        _TechChip('Riverpod'),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // ── Footer links ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: _onGithubTap,
                          icon: const Icon(Icons.code_rounded, size: 18),
                          label: const Text('View Source on GitHub'),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '·',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => context.go(AppRoutes.loginPath),
                          child: const Text('Open Web App'),
                        ),
                      ],
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;

  const _TechChip(this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
