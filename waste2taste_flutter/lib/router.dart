import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// TODO(Phase 4): Replace this stub with a real auth provider that reads the
// stored JWT from flutter_secure_storage.
final authProvider = StateProvider<bool>((ref) => false);

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
class _LandingScreen extends StatelessWidget {
  const _LandingScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('LandingScreen')));
}

class _LoginScreen extends StatelessWidget {
  const _LoginScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('LoginScreen')));
}

class _SignupScreen extends StatelessWidget {
  const _SignupScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('SignupScreen')));
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('HomeScreen')));
}

class _RecipesScreen extends StatelessWidget {
  const _RecipesScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('RecipesScreen')));
}

class _HistoryScreen extends StatelessWidget {
  const _HistoryScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('HistoryScreen')));
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('ProfileScreen')));
}

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
  final isAuthenticated = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.landing,
    redirect: (BuildContext context, GoRouterState state) {
      final location = state.matchedLocation;

      // Skip redirect for landing page
      if (location == AppRoutes.landing) return null;

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
        builder: (context, state) => const _LandingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const _LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const _SignupScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const _HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.recipes,
                builder: (context, state) => const _RecipesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const _HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const _ProfileScreen(),
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
