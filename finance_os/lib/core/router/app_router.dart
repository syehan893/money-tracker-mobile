import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import '../../features/accounts/presentation/bloc/accounts_bloc.dart';
import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/accounts/presentation/pages/add_account_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/expenses/presentation/bloc/expenses_bloc.dart';
import '../../features/expenses/presentation/pages/expenses_page.dart';
import '../../features/income/presentation/bloc/income_bloc.dart';
import '../../features/income/presentation/pages/add_income_page.dart';
import '../../features/subscriptions/presentation/bloc/subscriptions_bloc.dart';
import '../../features/subscriptions/presentation/pages/add_subscription_page.dart';
import '../../features/subscriptions/presentation/pages/subscriptions_page.dart';
import '../../features/transfers/presentation/bloc/transfers_bloc.dart';
import '../../features/transfers/presentation/pages/add_transfer_page.dart';
import '../../features/transfers/presentation/pages/transfers_page.dart';
import '../di/injection.dart';
import 'main_shell.dart';

/// Application router configuration using GoRouter
@injectable
class AppRouter {
  final AuthBloc _authBloc;

  AppRouter(this._authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    redirect: (context, state) {
      final authState = _authBloc.state;
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/splash';

      // If still initializing, stay on splash
      if (authState.status == AuthStatus.initial) {
        return isSplash ? null : '/splash';
      }

      // If not logged in and not on auth pages, redirect to login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // If logged in and on auth pages, redirect to dashboard
      if (isLoggedIn && (isLoggingIn || isSplash)) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Main Shell with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Dashboard
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<DashboardBloc>(),
              child: const DashboardPage(),
            ),
          ),

          // Accounts
          GoRoute(
            path: '/accounts',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<AccountsBloc>(),
              child: const AccountsPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => BlocProvider.value(
                  value: context.read<AccountsBloc>(),
                  child: const AddAccountPage(),
                ),
              ),
            ],
          ),

          // Expenses
          GoRoute(
            path: '/expenses',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<ExpensesBloc>(),
              child: const ExpensesPage(),
            ),
          ),

          // Transfers
          GoRoute(
            path: '/transfers',
            builder: (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => getIt<TransfersBloc>()),
                BlocProvider(create: (_) => getIt<AccountsBloc>()),
              ],
              child: const TransfersPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => getIt<TransfersBloc>()),
                    BlocProvider(create: (_) => getIt<AccountsBloc>()),
                  ],
                  child: const AddTransferPage(),
                ),
              ),
            ],
          ),

          // Subscriptions
          GoRoute(
            path: '/subscriptions',
            builder: (context, state) => BlocProvider(
              create: (_) => getIt<SubscriptionsBloc>(),
              child: const SubscriptionsPage(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => BlocProvider(
                  create: (_) => getIt<SubscriptionsBloc>(),
                  child: const AddSubscriptionPage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Income (accessed from dashboard)
      GoRoute(
        path: '/income/add',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<IncomeBloc>(),
          child: const AddIncomePage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Stream wrapper to make BLoC stream compatible with ChangeNotifier for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
