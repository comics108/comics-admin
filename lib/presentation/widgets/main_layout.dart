import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimens.dart';
import '../../core/constants/typography.dart';
import '../../core/l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import 'sidebar.dart';
import 'language_toggle.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userEmail = ref.watch(currentUserEmailProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Title bar
          Container(
            height: AppDimens.titleBarHeight,
            decoration: const BoxDecoration(
              color: AppColors.titleBar,
              border: Border(
                bottom: BorderSide(color: AppColors.titleBarBorder),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${l10n.appTitle} — ${l10n.adminPanel}',
                    style: AppTypography.windowTitle,
                  ),
                ),
                const Spacer(),
                _WindowButton(icon: '─', onTap: () {}),
                _WindowButton(icon: '□', onTap: () {}),
                _WindowButton(icon: '✕', onTap: () {}),
              ],
            ),
          ),

          // Header
          Container(
            height: AppDimens.headerHeight,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(l10n.adminPanel, style: AppTypography.appTitle),
                const Spacer(),
                const LanguageToggle(),
                const SizedBox(width: 12),
                Text(
                  userEmail ?? '',
                  style: AppTypography.appTitle.copyWith(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(width: 12),
                _LogoutButton(
                  onTap: () {
                    ref.read(appConfigProvider.notifier).logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Row(
              children: [
                const Sidebar(),
                Expanded(
                  child: Container(
                    color: AppColors.surface,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _WindowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 46,
        height: AppDimens.titleBarHeight,
        child: Center(
          child: Text(
            icon,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          l10n.logout,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
