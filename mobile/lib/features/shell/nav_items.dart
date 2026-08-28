import 'package:flutter/material.dart';

/// Destinations, ported from `frontend/src/lib/nav-items.ts`.
///
/// Every entry carries the module it belongs to. That is what makes the
/// "a personal workspace shows exactly what it always showed" guarantee
/// checkable rather than aspirational — the server decides which modules are
/// on, and this list is filtered against that.
class NavLink {
  const NavLink({
    required this.key,
    required this.path,
    required this.label,
    required this.icon,
    required this.module,
  });

  final String key;
  final String path;
  final String label;
  final IconData icon;
  final String module;
}

class NavSection {
  const NavSection(this.label, this.links);
  final String label;
  final List<NavLink> links;
}

/// The sidebar sections from the web app, in the same order. The dashboard is
/// absent here for the same reason it is there: it is reached from the
/// drawer's own header (tapping the logo), not listed as a menu item.
const navSections = <NavSection>[
  NavSection('Accounts', [
    NavLink(
      key: 'transactions',
      path: '/transactions',
      label: 'Transactions',
      icon: Icons.swap_horiz,
      module: 'transactions',
    ),
    NavLink(
      key: 'invoices',
      path: '/invoices',
      label: 'Invoices',
      icon: Icons.receipt_long_outlined,
      module: 'invoices',
    ),
    NavLink(
      key: 'accounts',
      path: '/accounts',
      label: 'Accounts',
      icon: Icons.account_balance_outlined,
      module: 'accounts',
    ),
    NavLink(
      key: 'import',
      path: '/import',
      label: 'Import',
      icon: Icons.upload_outlined,
      module: 'import',
    ),
    // Not in the web sidebar either (reached from elsewhere in that app),
    // but it's a real full-CRUD page with no module flag of its own — tying
    // it to the accounts module (what it groups) rather than inventing a
    // module key the backend doesn't know, which would just hide it.
    NavLink(
      key: 'collections',
      path: '/collections',
      label: 'Collections',
      icon: Icons.folder_outlined,
      module: 'accounts',
    ),
  ]),
  NavSection('Analysis', [
    NavLink(
      key: 'reports',
      path: '/reports',
      label: 'Reports',
      icon: Icons.bar_chart_outlined,
      module: 'reports',
    ),
    NavLink(
      key: 'assets',
      path: '/assets',
      label: 'Assets',
      icon: Icons.landscape_outlined,
      module: 'assets',
    ),
  ]),
  NavSection('Setup', [
    NavLink(
      key: 'budgets',
      path: '/budgets',
      label: 'Budgets',
      icon: Icons.savings_outlined,
      module: 'budgets',
    ),
    NavLink(
      key: 'goals',
      path: '/goals',
      label: 'Goals',
      icon: Icons.flag_outlined,
      module: 'goals',
    ),
    NavLink(
      key: 'loans',
      path: '/loans',
      label: 'Loans',
      icon: Icons.handshake_outlined,
      module: 'loans',
    ),
    NavLink(
      key: 'recurring',
      path: '/recurring',
      label: 'Recurring',
      icon: Icons.repeat,
      module: 'recurring',
    ),
    NavLink(
      key: 'categories',
      path: '/categories',
      label: 'Categories',
      icon: Icons.sell_outlined,
      module: 'categories',
    ),
    NavLink(
      key: 'payees',
      path: '/payees',
      label: 'Payees',
      icon: Icons.people_outline,
      module: 'payees',
    ),
    NavLink(
      key: 'splitGroups',
      path: '/groups',
      label: 'Groups',
      icon: Icons.call_split,
      module: 'split_groups',
    ),
    NavLink(
      key: 'rules',
      path: '/rules',
      label: 'Rules',
      icon: Icons.tune,
      module: 'rules',
    ),
  ]),
];

/// Drops links whose module is off, then drops any section left with nothing
/// under it — without that second pass, hiding a section's only link leaves a
/// floating heading.
List<NavSection> visibleNavSections(bool Function(String module) hasModule) {
  final result = <NavSection>[];
  for (final section in navSections) {
    final links = section.links.where((l) => hasModule(l.module)).toList();
    if (links.isNotEmpty) result.add(NavSection(section.label, links));
  }
  return result;
}
