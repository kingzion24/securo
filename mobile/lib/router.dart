import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/accounts/accounts_screen.dart';
import 'features/assets/assets_screen.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/lock_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/splash_screen.dart';
import 'features/budgets/budgets_screen.dart';
import 'features/categories/categories_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/goals/goals_screen.dart';
import 'features/import/import_screen.dart';
import 'features/invoices/invoices_screen.dart';
import 'features/loans/loans_screen.dart';
import 'features/payees/payees_screen.dart';
import 'features/recurring/recurring_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/rules/rules_screen.dart';
import 'features/shell/app_shell.dart';
import 'features/split_groups/split_groups_screen.dart';
import 'features/transactions/transactions_screen.dart';

/// Bridges a Riverpod [StateNotifier] to go_router's `refreshListenable`, so a
/// change in auth status re-runs the redirect.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(this._ref) {
    _ref.listen<AuthState>(
      authControllerProvider,
      (_, _) => notifyListeners(),
    );
  }
  final Ref _ref;
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefresh(ref);
  ref.onDispose(refresh.dispose);

  // Kick off session restore once the router exists, so the splash route is
  // already on screen while stored credentials are read.
  Future.microtask(() => ref.read(authControllerProvider.notifier).restore());

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final status = ref.read(authControllerProvider).status;
      final location = state.matchedLocation;

      return switch (status) {
        AuthStatus.restoring =>
          location == '/splash' ? null : '/splash',
        AuthStatus.unauthenticated =>
          location == '/login' ? null : '/login',
        AuthStatus.locked => location == '/lock' ? null : '/lock',
        AuthStatus.authenticated =>
          const {'/splash', '/login', '/lock'}.contains(location) ? '/' : null,
      };
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/lock',
        builder: (_, _) => const LockScreen(),
      ),
      // Paths below mirror the web app's routes in `frontend/src/App.tsx`, so
      // a link or habit carries across from the browser.
      ShellRoute(
        builder: (_, _, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, _) => const DashboardScreen()),
          GoRoute(
            path: '/transactions',
            builder: (_, _) => const TransactionsScreen(),
          ),
          GoRoute(
            path: '/accounts',
            builder: (_, _) => const AccountsScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (_, _) => const ReportsScreen(),
          ),
          GoRoute(path: '/invoices', builder: (_, _) => const InvoicesScreen()),
          GoRoute(path: '/import', builder: (_, _) => const ImportScreen()),
          GoRoute(path: '/assets', builder: (_, _) => const AssetsScreen()),
          GoRoute(path: '/budgets', builder: (_, _) => const BudgetsScreen()),
          GoRoute(path: '/goals', builder: (_, _) => const GoalsScreen()),
          GoRoute(path: '/loans', builder: (_, _) => const LoansScreen()),
          GoRoute(path: '/recurring', builder: (_, _) => const RecurringScreen()),
          GoRoute(
            path: '/categories',
            builder: (_, _) => const CategoriesScreen(),
          ),
          GoRoute(path: '/payees', builder: (_, _) => const PayeesScreen()),
          GoRoute(
            path: '/groups',
            builder: (_, _) => const SplitGroupsScreen(),
          ),
          GoRoute(path: '/rules', builder: (_, _) => const RulesScreen()),
        ],
      ),
    ],
  );
});
