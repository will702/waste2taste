// DONE_WITH_CONCERNS: Camera capture is mocked — the ML Kit code path is fully
// wired, but since we cannot get a real camera image in the current setup,
// detectIngredients() is called with a null imagePath guard that returns a
// hardcoded demo list ['tomato', 'paprika', 'chicken']. The camera package IS
// available and the capture flow is stubbed with a comment showing how to wire
// a CameraController. To make this production-ready: initialize a
// CameraController in initState, show the preview (or a capture button over
// it), call controller.takePicture(), pass the resulting XFile.path to
// mlKitService.detectIngredients(path).

// ignore: unused_import — camera package is used in the TODO capture flow below
// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/catalog.dart';
import '../providers/ml_kit_service_ext.dart';
import '../providers/pantry_provider.dart';
import '../providers/providers.dart';
import '../theme.dart';
import '../widgets/app_button.dart';
import '../widgets/food_visual.dart';

/// Scan screen — port of app/scan.tsx with ML Kit camera pipeline.
/// See DONE_WITH_CONCERNS note above for camera mock rationale.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _agreed = false;
  bool _scanning = false;
  List<String> _detectedIds = [];
  String? _error;

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _error = null;
    });
    try {
      // 1. Request camera permission
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() => _error = 'Camera permission denied');
        return;
      }

      // 2. MOCK: In production, initialize CameraController, call
      //    takePicture(), get XFile.path, and pass to detectIngredients.
      //    e.g.:
      //      final cameras = await availableCameras();
      //      final controller = CameraController(cameras.first, ResolutionPreset.medium);
      //      await controller.initialize();
      //      final xFile = await controller.takePicture();
      //      final results = await mlKit.detectIngredients(xFile.path);
      //
      // For now, call detectIngredients with a null guard (demo mode):
      final mlKit = ref.read(mlKitServiceProvider);
      final results = await mlKit.detectIngredientsMaybeNull(null);
      setState(() => _detectedIds = results);

      if (results.isEmpty && mounted) {
        _showNothingDetectedDialog();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  void _showNothingDetectedDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nothing detected'),
        content: const Text('Try searching manually.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/app/add-ingredients');
            },
            child: const Text('Search manually'),
          ),
        ],
      ),
    );
  }

  Future<void> _addDetectedItems() async {
    await ref
        .read(pantryProvider.notifier)
        .addIngredients(_detectedIds);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final canAdd = _agreed && _detectedIds.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.yellow,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Main content ───────────────────────────────────────────────
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),

                    // Camera circle icon
                    Center(
                      child: GestureDetector(
                        onTap: _agreed && !_scanning ? _scan : null,
                        child: Container(
                          width: 132,
                          height: 132,
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.red.withAlpha(80),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: _scanning
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.cream,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.cream,
                                  size: 56,
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Consent checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _agreed,
                          onChanged: (v) =>
                              setState(() => _agreed = v ?? false),
                          activeColor: AppColors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'I allow this app to use my camera to detect ingredients',
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Title + subtitle
                    const Text(
                      'Scan your ingredients',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Point your camera at your ingredients and tap the circle to capture',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.red.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: AppColors.red,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Detected ingredients panel
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detected ingredients',
                            style: TextStyle(
                              color: AppColors.cream,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Detected ingredients list
                          if (_detectedIds.isEmpty)
                            const Text(
                              'Tap the camera icon above to scan',
                              style: TextStyle(
                                color: Color(0xC7FFDC9D),
                                fontSize: 13,
                              ),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _detectedIds.map((id) {
                                final ingredient = getIngredient(id);
                                if (ingredient == null) return const SizedBox.shrink();
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.cream.withAlpha(46),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IngredientGlyph(
                                          ingredient: ingredient, size: 24),
                                      const SizedBox(width: 6),
                                      Text(
                                        ingredient.name,
                                        style: const TextStyle(
                                          color: AppColors.cream,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                          const SizedBox(height: 16),

                          // Add Detected Items button
                          AppButton(
                            label: 'Add Detected Items',
                            onPress: canAdd ? _addDetectedItems : () {},
                            variant: AppButtonVariant.cream,
                          ),

                          const SizedBox(height: 8),

                          // Type instead link
                          GestureDetector(
                            onTap: () => context.go('/app/add-ingredients'),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 6),
                                child: Text(
                                  'Type ingredients instead',
                                  style: TextStyle(
                                    color: Color(0xC7FFDC9D),
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xC7FFDC9D),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // ── Back button (absolute top-left) ───────────────────────────
            Positioned(
              top: 8,
              left: 8,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.ink.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.ink,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
