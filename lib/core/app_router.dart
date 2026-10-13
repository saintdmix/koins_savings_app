import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth/auth_cubit.dart';
import '../screens/create_savings_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/lock_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_shell.dart';
import '../screens/product_details_screen.dart';
import '../screens/products_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const lock = '/lock';
  static const home = '/home';
  static const products = '/products';
  static const profile = '/profile';
  static const create = '/create';
  static const productDetailsBase = '/product';

  static String productDetails(String id) => '$productDetailsBase/$id';
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  AppRouter._();

  static GoRouter create(AuthCubit auth) {
    final rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

    return GoRouter(
      navigatorKey: rootKey,
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(auth.stream),
      redirect: (context, state) {
        final location = state.matchedLocation;
        final gatePages = {AppRoutes.splash, AppRoutes.login, AppRoutes.lock};

        switch (auth.state.status) {
          case AuthStatus.unknown:
            return location == AppRoutes.splash ? null : AppRoutes.splash;
          case AuthStatus.unauthenticated:
            return location == AppRoutes.login ? null : AppRoutes.login;
          case AuthStatus.locked:
            return location == AppRoutes.lock ? null : AppRoutes.lock;
          case AuthStatus.authenticated:
            return gatePages.contains(location) ? AppRoutes.home : null;
        }
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.lock,
          builder: (context, state) => const LockScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => MainShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: AppRoutes.products,
                builder: (context, state) => const ProductsScreen(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ]),
          ],
        ),
        GoRoute(
          path: '${AppRoutes.productDetailsBase}/:id',
          parentNavigatorKey: rootKey,
          builder: (context, state) => ProductDetailsScreen(
            productId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: AppRoutes.create,
          parentNavigatorKey: rootKey,
          builder: (context, state) => CreateSavingsScreen(
            initialProductId: state.uri.queryParameters['product'],
          ),
        ),
      ],
    );
  }
}
