import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/recipes_screen.dart';
export 'providers/auth_provider.dart' show authProvider;

// ---------------------------------------------------------------------------
// Route paths
// ---------------------------------------------------------------------------
abstract final class AppRoutes {
  static const landing = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/app/home';
  static const recipes = '/app/recipes';
  static const history = '/app/history';
  static const profile = '/app/profile';
  static const addIngredients = '/app/add-ingredients';
  static const scan = '/app/scan';
  static const recipeDetail = '/app/recipe/:id';

  static String recipeDetailPath(String id) => '/app/recipe/$id';
}

// ---------------------------------------------------------------------------
// Placeholder screens — will be replaced in later phases
// ---------------------------------------------------------------------------
// Landing, Login, Signup, Home, Recipes, History, and Profile are real screens.

class _AddIngredientsScreen extends StatelessWidget {
  const _AddIngredientsScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('AddIngredientsScreen')));
}

class _ScanScreen extends StatelessWidget {
  const _ScanScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('ScanScreen')));
}

class _RecipeDetailScreen extends StatelessWidget {
  const _RecipeDetailScreen({required this.id});
  final String id;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('RecipeDetailScreen: $id')));
}

// ---------------------------------------------------------------------------
// Shell with NavigationBar (4 tabs)
// ---------------------------------------------------------------------------
class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) =>
            navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined), label: 'Recipes'),
          NavigationDestination(
              icon: Icon(Icons.history_outlined), label: 'History'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Router provider
// ---------------------------------------------------------------------------
final routerProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.landing,
    redirect: (BuildContext context, GoRouterState state) {
      final location = state.matchedLocation;

      // Skip redirect for landing page
      if (location == AppRoutes.landing) return null;

      // While auth state is loading, don't redirect
      if (authAsync.isLoading) return null;

      final isAuthenticated = authAsync.valueOrNull != null;
      final isAppRoute = location.startsWith('/app');
      final isAuthRoute =
          location == AppRoutes.login || location == AppRoutes.signup;

      if (isAppRoute && !isAuthenticated) {
        return AppRoutes.login;
      }
      if (isAuthRoute && isAuthenticated) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.landing,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.recipes,
                builder: (context, state) => const RecipesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.addIngredients,
        builder: (context, state) => const _AddIngredientsScreen(),
      ),
      GoRoute(
        path: AppRoutes.scan,
        builder: (context, state) => const _ScanScreen(),
      ),
      GoRoute(
        path: AppRoutes.recipeDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _RecipeDetailScreen(id: id);
        },
      ),
    ],
  );
});
