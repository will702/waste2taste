# Flutter Migration Design

**Date:** 2026-06-02  
**Status:** Implemented  
**Branch:** feat/flutter-migration

## Goal

Replace the Expo/React Native frontend with a Flutter app that delivers:
- Material 3 design with dynamic color (seed `#AB2A02`)
- On-device ingredient detection via Google ML Kit (offline, no API key)
- Riverpod state management wired to the existing Hono/Node.js backend

The existing backend (API gateway + Python ML service + Supabase) is unchanged.

---

## Architecture

```
Flutter App (waste2taste_flutter/)
  ├── GoRouter          — navigation + auth redirect
  ├── Riverpod          — state: pantry, auth, recipes, history
  └── Services
        ├── MlKitService    →  on-device ImageLabeler (scan, offline)
        ├── ApiClient       →  Dio + JWT interceptor → Hono API (Cloud Run)
        └── StorageService  →  flutter_secure_storage (JWT)
```

The `/ml/detect` endpoint on the Python service is no longer called by the Flutter app — ML Kit replaces it. The `/ml/recommend` path (HuggingFace scoring) remains in Python and is called via the API gateway as before.

---

## Key Decisions

### ML Kit over Cloud Vision
Python `backend/ml/services/vision.py` uses Google Vision API (cloud round-trip, requires `GOOGLE_APPLICATION_CREDENTIALS`). ML Kit runs on-device: no network, no service account, faster for common pantry items.

Confidence threshold: **0.70** (matches Python service).  
Alias matching: `string_similarity` Dice coefficient at **0.80** (matches Python `fuzz.token_sort_ratio` behavior).

### Riverpod over Context API
`context/PantryContext.tsx` held all pantry state in-memory with no backend sync. Riverpod `AsyncNotifierProvider` provides:
- Async API calls with loading/error states
- Optimistic updates with rollback
- Auto-recompute of recommendations when pantry changes

### GoRouter ShellRoute for tab navigation
Four tabs (Home, Recipes, History, Profile) in `StatefulShellRoute.indexedStack`. Feature screens (add-ingredients, scan, recipe/:id) pushed on top of any tab without the tab bar.

Auth redirect: `GoRouter.redirect` checks `authProvider.isLoading` to avoid redirect flash during JWT bootstrap.

---

## File Structure

```
waste2taste_flutter/lib/
  main.dart                    # ProviderScope + MaterialApp.router
  router.dart                  # GoRouter — 11 routes, auth redirect
  theme.dart                   # M3 ColorScheme.fromSeed + AppThemeExtension
  models/                      # freezed + json_serializable
    ingredient.dart
    recipe.dart
    pantry_item.dart
    cooked_meal.dart
    user.dart
  data/
    catalog.dart               # 12 ingredients, 4 recipes (port of data/catalog.ts)
    ingredient_aliases.dart    # port of backend/ml/services/vision.py INGREDIENT_ALIASES
  services/
    api_client.dart            # Dio, AuthInterceptor, 401 → "session_expired"
    ml_kit_service.dart        # ImageLabeler, fuzzy alias match
    storage_service.dart       # flutter_secure_storage JWT wrapper
  providers/
    providers.dart             # storageServiceProvider, apiClientProvider, mlKitServiceProvider
    auth_provider.dart
    pantry_provider.dart       # optimistic updates, batch addIngredients
    recipes_provider.dart      # RecipesNotifier + RecommendationsNotifier
    history_provider.dart
    ml_kit_service_ext.dart    # detectIngredientsMaybeNull (demo mode guard)
  widgets/
    app_button.dart            # FilledButton/OutlinedButton/TextButton/ghost variants
    brand_mark.dart
    food_visual.dart           # IngredientGlyph + RecipeVisual
    pantry_row.dart
    recipe_card.dart
    metric_pill.dart
    section_title.dart
    screen_wrapper.dart
    ingredient_chip.dart
  screens/
    landing_screen.dart
    auth/
      auth_input.dart          # shared TextField widget
      login_screen.dart
      signup_screen.dart
    home_screen.dart
    recipes_screen.dart
    history_screen.dart
    profile_screen.dart
    add_ingredients_screen.dart
    scan_screen.dart           # camera permission + ML Kit pipeline
    recipe_detail_screen.dart
```

---

## Scan Screen (Known Limitation)

Camera capture is mocked in the current implementation. The ML Kit pipeline is fully wired:

```dart
// Production path (TODO: wire CameraController):
final cameras = await availableCameras();
final controller = CameraController(cameras.first, ResolutionPreset.medium);
await controller.initialize();
final xFile = await controller.takePicture();
final results = await mlKitService.detectIngredients(xFile.path);
```

Current demo mode returns `['tomato', 'paprika', 'chicken']` when `imagePath == null`. All other pipeline steps (permission request, alias matching, pantry update, empty-state dialog) are real. Wire `CameraController` on a physical device to make it production-ready.

---

## Data Model Notes

- `CookedMeal.saved` is `bool?` (not `String?`) — mirrors `saved BOOLEAN DEFAULT false` in Supabase schema
- `Recipe` has dual-mode fields: `ingredientIds`/`steps` for local catalog, `recipeIngredients` for API joins
- `@JsonKey` decorators handle snake_case ↔ camelCase for all API fields

---

## Navigation Routes

| Path | Screen |
|------|--------|
| `/` | LandingScreen |
| `/login` | LoginScreen |
| `/signup` | SignupScreen |
| `/app/home` | HomeScreen (tab 0) |
| `/app/recipes` | RecipesScreen (tab 1) |
| `/app/history` | HistoryScreen (tab 2) |
| `/app/profile` | ProfileScreen (tab 3) |
| `/app/add-ingredients` | AddIngredientsScreen |
| `/app/scan` | ScanScreen |
| `/app/recipe/:id` | RecipeDetailScreen |
