import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:string_similarity/string_similarity.dart';
import '../data/ingredient_aliases.dart';

class MlKitService {
  static const double _confidenceThreshold = 0.70;
  static const double _similarityThreshold = 0.80;

  final ImageLabeler _labeler = ImageLabeler(
    options: ImageLabelerOptions(confidenceThreshold: _confidenceThreshold),
  );

  /// Detects ingredient IDs from an image file path.
  /// Returns list of matched catalog IDs (may be empty).
  Future<List<String>> detectIngredients(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final labels = await _labeler.processImage(inputImage);

    final detected = <String>[];
    for (final label in labels) {
      final matched = _matchLabelToAlias(label.label.toLowerCase().trim());
      if (matched != null && !detected.contains(matched)) {
        detected.add(matched);
      }
    }
    return detected;
  }

  /// Fuzzy-matches a label string against ingredientAliases map.
  String? _matchLabelToAlias(String label) {
    for (final entry in ingredientAliases.entries) {
      for (final alias in entry.value) {
        final score = label.similarityTo(alias);
        if (score >= _similarityThreshold) return entry.key;
      }
    }
    return null;
  }

  Future<void> dispose() => _labeler.close();
}
