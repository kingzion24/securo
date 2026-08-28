import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/theme.dart';
import '../../core/theme/tokens.dart';
import '../auth/auth_controller.dart';
import '../settings/settings_screen.dart';
import '../workspace/workspace_controller.dart';
import 'nav_items.dart';

/// The web sidebar, as a drawer. Sections and ordering match `nav-items.ts`;
/// which links appear is decided by the workspace's enabled modules.
class AppNavDrawer extends ConsumerWidget {
  const AppNavDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;
    final auth = ref.watch(authControllerProvider);
    final workspace = ref.watch(currentWorkspaceProvider).valueOrNull;
    final location = GoRouterState.of(context).matchedLocation;

    // Until the workspace loads, show nothing rather than guessing at the
    // module list and flashing links that then disappear.
    final sections = workspace == null
        ? <NavSection>[]
        : visibleNavSections(workspace.hasModule);

    return Drawer(
      backgroundColor: colors.sidebar,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(workspaceName: workspace?.name),
            Divider(color: colors.sidebarBorder, height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  for (final section in sections) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                      child: Text(
                        section.label.toUpperCase(),
                        style: text.labelSmall?.copyWith(
                          color: colors.sidebarMuted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    for (final link in section.links)
                      _NavTile(
                        link: link,
                        selected: location == link.path,
                      ),
                  ],
                  if (auth.isAgentsEnabled) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                      child: Text(
                        'AGENTS',
                        style: text.labelSmall?.copyWith(
                          color: colors.sidebarMuted,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    _NavTile(
                      link: const NavLink(
                        key: 'agents',
                        path: '/agents',
                        label: 'Agents',
                        icon: Icons.smart_toy_outlined,
                        module: 'agents',
                      ),
                      selected: location.startsWith('/agents'),
                    ),
                  ],
                ],
              ),
            ),
            Divider(color: colors.sidebarBorder, height: 1),
            _AccountFooter(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.workspaceName});
  final String? workspaceName;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final text = Theme.of(context).textTheme;

    return InkWell(
      // The web app puts the dashboard behind the logo in the sidebar header.
      onTap: () {
        Navigator.of(context).pop();
        GoRouter.of(context).go('/');
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Row(
          children: [
            SvgPicture.asset('assets/images/logo.svg', width: 32, height: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Securo',
                    style: text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.sidebarForeground,
                    ),
                  ),
                  if (workspaceName != null)
                    Text(
                      workspaceName!,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: colors.sidebarMuted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.link, required this.selected});
  final NavLink link;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final foreground =
        selected ? colors.sidebarAccentForeground : colors.sidebarForeground;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: Material(
        color: selected ? colors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(SecuroRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(SecuroRadius.md),
          onTap: () {
            Navigator.of(context).pop();
            GoRouter.of(context).go(link.path);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(link.icon, size: 19, color: foreground),
                const SizedBox(width: 12),
                Text(
                  link.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: foreground,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
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

class _AccountFooter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = SecuroTheme.of(context);
    final user = ref.watch(authControllerProvider).user;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SecuroRadius.md),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              );
            },
            leading: CircleAvatar(
              radius: 15,
              backgroundColor: colors.accent,
              child: Text(
                (user?.label.characters.first ?? '?').toUpperCase(),
                style: TextStyle(
                  color: colors.sidebarAccentForeground,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
            title: Text(
              user?.label ?? '',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              user?.email ?? '',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.sidebarMuted),
            ),
            trailing: IconButton(
              tooltip: 'Sign out',
              icon: Icon(
                Icons.logout,
                size: 19,
                color: colors.sidebarMuted,
              ),
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).logout(),
            ),
          ),
        ],
      ),
    );
  }
}
