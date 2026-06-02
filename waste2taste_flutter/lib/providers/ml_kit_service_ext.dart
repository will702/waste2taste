import '../services/ml_kit_service.dart';

/// Extension on MlKitService that handles a nullable imagePath.
/// When imagePath is null (demo/test mode), returns a hardcoded list.
/// When a real path is provided, delegates to detectIngredients().
extension MlKitServiceExt on MlKitService {
  Future<List<String>> detectIngredientsMaybeNull(String? imagePath) async {
    if (imagePath == null) {
      // Demo mode — no real camera image available yet.
      // TODO: Remove when camera capture is wired in.
      return ['tomato', 'paprika', 'chicken'];
    }
    return detectIngredients(imagePath);
  }
}
