# Waste2Taste Flutter

Active mobile frontend for Waste2Taste.

## Backend Connection

The Flutter app talks only to the Hono API gateway in `../backend/api`. It does not call Supabase or the Python ML service directly.

Local API URLs:

```bash
flutter run -d android --dart-define=API_URL=http://10.0.2.2:8080
flutter run -d iphone --dart-define=API_URL=http://127.0.0.1:8080
```

Use the deployed API gateway URL for production builds.

## Development

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```
