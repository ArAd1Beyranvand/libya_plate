import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libya_plate/libya_plate.dart';
import 'package:plate_core/plate_core.dart';

/// One golden per design, rendered with real faces and filled with the
/// reference artwork's own values so the ink can be measured against it.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final loader = FontLoader('Roboto');
    for (final path in const <String>[
      '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
      '/usr/share/fonts/truetype/noto/NotoSansArabic-Bold.ttf',
    ]) {
      final file = File(path);
      if (!file.existsSync()) continue;
      loader.addFont(file.readAsBytes().then((b) => ByteData.view(b.buffer)));
    }
    await loader.load();
  });

  final cases = <(String, PlateSpec, PlateTheme, String)>[
    for (final (row, two) in const <(String, bool)>[
      ('1', false),
      ('2', true),
    ]) ...<(String, PlateSpec, PlateTheme, String)>[
      ('private_$row', LibyaPlates.private(twoRow: two), LibyaThemes.white, '8 616192'),
      ('foreign_$row', LibyaPlates.foreign(twoRow: two), LibyaThemes.white, '39 3 3123'),
      ('diplomatic_$row', LibyaPlates.diplomatic(twoRow: two), LibyaThemes.red, '11 13'),
      for (final c in LibyaClass.values)
        ('${c.id}_$row', LibyaPlates.lettered(c, twoRow: two), LibyaThemes.yellow, '8 123456'),
    ],
  ];

  test('every spec has a golden', () {
    expect(cases.map((c) => c.$2).toSet(), LibyaPlates.all.toSet());
  });

  for (final (name, spec, theme, values) in cases) {
    testWidgets(name, (tester) async {
      final controller = PlateController.fromValues(spec, values.split(' '));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFF808080),
            body: Center(
              child: SizedBox(
                width: 780,
                height: 780 * spec.canvasHeight / spec.canvasWidth,
                child: PlateView(controller: controller, theme: theme, country: LibyaCountry.libya),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(find.byType(PlateView), matchesGoldenFile('goldens/$name.png'));
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }
}
