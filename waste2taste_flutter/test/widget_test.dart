// Basic smoke test for the Waste2Taste Flutter app.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:waste2taste_flutter/main.dart';

void main() {
  testWidgets('App smoke test — mounts without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: Waste2TasteApp()),
    );
    // App renders without throwing.
    expect(tester.takeException(), isNull);
  });
}
