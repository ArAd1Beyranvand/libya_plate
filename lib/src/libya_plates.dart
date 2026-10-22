import 'dart:math';

import 'package:plate_core/plate_core.dart';

import 'libya_alphabets.dart';
import 'libya_colors.dart';
import 'libya_country.dart';
import 'libya_regions.dart';
import 'libya_usage.dart';

/// Layout constants in millimetres: 520×110 one-row, 270×150 two-row.
///
/// Positions are measured ink centres from reference artwork normalised to
/// those sizes (the white, foreign and diplomatic artwork is stretched 3% /
/// compressed 4% to fit). Where the serial's centre differs between designs it
/// is put on the plate centre.
///
/// The blue code box is a `PlateSection` of the background, running under the
/// frame to the plate edge. Dashes are short `PlateRule`s.
///
/// **Under-size digits, accepted.** The plates use a condensed face; the
/// fallback digits are far wider, so a slot's glyphs are width-limited by the
/// measured pitch and come out shorter than the reference. The x positions are
/// kept.
///
/// **Not drawn.** The artwork's thin outer line and the gap inside it: the
/// engine paints one frame, so the frame is the inner stroke's width.
/// `هيئة سياسية` is set in the theme's face, not Ruqʿah.
abstract final class _Layout {
  static const double oneW = 520, oneH = 110;
  static const double twoW = 270, twoH = 150;
  static const double oneBorder = 4.0 / oneH;
  static const double twoBorder = 3.2 / twoH;

  static const double onePitch = 35.2;
  static const double oneYellowPitch = 31.9;
  static const double twoPitch = 28.0;
  static const double twoYellowPitch = 26.05;
}

/// A field of [min]..[max] digits centred on [centre], in a box sized for the
/// longest run.
class _Reg {
  const _Reg(this.key, this.centre, this.cy, this.pitch, this.height, this.max, {this.min = 1});
  final String key;
  final double centre, cy, pitch, height;
  final int min, max;
}

/// A fixed word, placed by its ink centre and sized by [glyph].
///
/// [glyph] is the size whose ink spans [width] (`ليبيا` inks 1.29 units per
/// unit of glyph, the caption 4.37). An overflowing label stops being centred,
/// so the ink must fit the box.
///
/// A label centres its line box, not its ink. [dx] and [dy] (fractions of
/// [glyph]) are where the ink lands relative to that box; the box is moved by
/// the opposite amount so [cx], [cy] stay the reference's ink centre. The class
/// letters, whose bowls hang below the line, share one [dy] across all five.
class _Text {
  const _Text(
    this.text,
    this.cx,
    this.cy,
    this.width,
    this.glyph, {
    required this.dx,
    required this.dy,
  });
  const _Text.libya(double cx, double cy, double width, double glyph)
    : this('ليبيا', cx, cy, width, glyph, dx: 0.06, dy: 0.035);
  const _Text.caption(double cx, double cy, double width, double glyph)
    : this('هيئة سياسية', cx, cy, width, glyph, dx: 0.04, dy: 0.04);
  const _Text.letter(double cx, double cy, double width, double glyph)
    : this('', cx, cy, width, glyph, dx: 0.02, dy: 0.18);
  final String text;
  final double cx, cy, width, glyph, dx, dy;
}

/// One design on one format.
class _Face {
  const _Face({
    required this.id,
    required this.width,
    required this.height,
    required this.border,
    required this.regs,
    this.background = PlateSection.plain,
    this.dashes = const <PlateBox>[],
    this.texts = const <_Text>[],
    this.letter,
  });
  final String id;
  final double width, height, border;
  final PlateSection background;
  final List<_Reg> regs;
  final List<PlateBox> dashes;
  final List<_Text> texts;

  /// Placement of the class letter; its text is substituted at build time.
  final _Text? letter;
}

abstract final class _Faces {
  static const _Text oneLibya = _Text.libya(440.0, 56.3, 100.4, 77.8);
  static const _Text twoLibya = _Text.libya(176.1, 42.4, 79.5, 64.2);

  static const _Face privateOne = _Face(
    id: 'private.1',
    width: _Layout.oneW,
    height: _Layout.oneH,
    border: _Layout.oneBorder,
    regs: <_Reg>[
      _Reg('municipality', 43.9, 55.2, _Layout.onePitch, 100, 2),
      _Reg('serial', 252.0, 55.2, _Layout.onePitch, 100, 7),
    ],
    dashes: <PlateBox>[PlateBox(84.3, 57.5, 21.1, 9.7)],
    texts: <_Text>[oneLibya],
  );

  static const _Face foreignOne = _Face(
    id: 'foreign.1',
    width: _Layout.oneW,
    height: _Layout.oneH,
    border: _Layout.oneBorder,
    background: PlateSection.columns(<PlatePart>[
      PlatePart(PlateSection.fill(PlateFill.color(LibyaColors.foreignBlue)), end: 102.4),
      PlatePart(PlateSection.plain),
    ]),
    regs: <_Reg>[
      _Reg('country', 56.9, 55.2, _Layout.onePitch, 100, 3, min: 2),
      _Reg('municipality', 140.6, 55.2, _Layout.onePitch, 100, 2),
      _Reg('serial', 294.2, 55.2, _Layout.onePitch, 100, 4),
    ],
    dashes: <PlateBox>[PlateBox(180.2, 57.9, 20.7, 9.5)],
    texts: <_Text>[_Text.libya(438.2, 55.9, 102.3, 79.3)],
  );

  static const _Face diplomaticOne = _Face(
    id: 'diplomatic.1',
    width: _Layout.oneW,
    height: _Layout.oneH,
    border: _Layout.oneBorder,
    regs: <_Reg>[
      _Reg('serial', 69.5, 53.7, _Layout.onePitch, 100, 2),
      _Reg('country', 205.4, 53.7, _Layout.onePitch, 100, 3, min: 2),
    ],
    dashes: <PlateBox>[PlateBox(126.6, 56.3, 21.1, 9.5)],
    texts: <_Text>[_Text.caption(387.4, 53.7, 218.6, 50)],
  );

  static const _Face letteredOne = _Face(
    id: 'lettered.1',
    width: _Layout.oneW,
    height: _Layout.oneH,
    border: _Layout.oneBorder,
    regs: <_Reg>[
      _Reg('municipality', 87.8, 51.7, _Layout.oneYellowPitch, 96, 2),
      _Reg('serial', 264.3, 51.7, _Layout.oneYellowPitch, 96, 6),
    ],
    dashes: <PlateBox>[PlateBox(134.0, 54.3, 12.2, 8.4)],
    texts: <_Text>[_Text.libya(437.0, 54.9, 106.3, 82.4)],
    letter: _Text.letter(38.1, 61.6, 40, 96),
  );

  static const _Face privateTwo = _Face(
    id: 'private.2',
    width: _Layout.twoW,
    height: _Layout.twoH,
    border: _Layout.twoBorder,
    regs: <_Reg>[
      _Reg('municipality', 67.8, 41.6, _Layout.twoPitch, 70, 2),
      _Reg('serial', 135.0, 108.85, _Layout.twoPitch, 70, 7),
    ],
    dashes: <PlateBox>[PlateBox(99.2, 43.8, 16.5, 7.9)],
    texts: <_Text>[twoLibya],
  );

  static const _Face foreignTwo = _Face(
    id: 'foreign.2',
    width: _Layout.twoW,
    height: _Layout.twoH,
    border: _Layout.twoBorder,
    background: PlateSection.rows(<PlatePart>[
      PlatePart(
        PlateSection.columns(<PlatePart>[
          PlatePart(PlateSection.fill(PlateFill.color(LibyaColors.foreignBlue)), end: 85.9),
          PlatePart(PlateSection.plain),
        ]),
        end: 69.5,
      ),
      PlatePart(PlateSection.plain),
    ]),
    regs: <_Reg>[
      _Reg('country', 47.3, 38.65, _Layout.twoPitch, 66, 3, min: 2),
      _Reg('municipality', 117.4, 40.75, _Layout.twoPitch, 70, 2),
      _Reg('serial', 135.0, 107.05, _Layout.twoPitch, 70, 4),
    ],
    texts: <_Text>[_Text.libya(196.2, 41.0, 96.9, 75.1)],
  );

  static const _Face diplomaticTwo = _Face(
    id: 'diplomatic.2',
    width: _Layout.twoW,
    height: _Layout.twoH,
    border: _Layout.twoBorder,
    regs: <_Reg>[
      _Reg('serial', 81.6, 104.0, _Layout.twoPitch, 70, 2),
      _Reg('country', 189.5, 104.0, _Layout.twoPitch, 70, 3, min: 2),
    ],
    dashes: <PlateBox>[PlateBox(126.9, 106.2, 16.6, 8.1)],
    texts: <_Text>[_Text.caption(134.2, 41.2, 176.5, 40)],
  );

  static const _Face letteredTwo = _Face(
    id: 'lettered.2',
    width: _Layout.twoW,
    height: _Layout.twoH,
    border: _Layout.twoBorder,
    regs: <_Reg>[
      _Reg('municipality', 47.5, 39.7, _Layout.twoYellowPitch, 70, 2),
      _Reg('serial', 145.0, 108.7, _Layout.twoYellowPitch, 70, 6),
    ],
    dashes: <PlateBox>[PlateBox(93.2, 44.0, 10.6, 7.1)],
    texts: <_Text>[_Text.libya(192.05, 37.8, 86.1, 66.7)],
    letter: _Text.letter(35.9, 115.1, 36, 82),
  );
}

/// The 2013 series, one row (520×110) or two (270×150). Each field is one slot
/// sized for its longest run.
///
/// * [private]: municipality 1-2 digits, serial 1-7 (7 only in Tripoli).
///   Theme `LibyaThemes.white`.
/// * [foreign]: the owner's country code (2-3 digits) in a blue box, then
///   municipality and a 1-4 digit serial. Theme `white`.
/// * [diplomatic]: a 1-2 digit serial and the mission's country code, with no
///   `ليبيا`. Theme `red`.
/// * [lettered]: the five yellow classes (`LibyaClass`), class letter before
///   the municipality code; serial 1-6. Theme `yellow`.
///
/// Earlier series (1960s, 1998-2012, colonial) are not implemented.
abstract final class LibyaPlates {
  static final Map<String, PlateSpec> _cache = <String, PlateSpec>{};

  static PlateSpec private({bool twoRow = false}) =>
      _build(twoRow ? _Faces.privateTwo : _Faces.privateOne);

  static PlateSpec foreign({bool twoRow = false}) =>
      _build(twoRow ? _Faces.foreignTwo : _Faces.foreignOne);

  static PlateSpec diplomatic({bool twoRow = false}) =>
      _build(twoRow ? _Faces.diplomaticTwo : _Faces.diplomaticOne);

  static PlateSpec lettered(LibyaClass cls, {bool twoRow = false}) =>
      _build(twoRow ? _Faces.letteredTwo : _Faces.letteredOne, cls: cls);

  static List<PlateSpec> get all => <PlateSpec>[
    for (final twoRow in const <bool>[false, true]) ...<PlateSpec>[
      private(twoRow: twoRow),
      foreign(twoRow: twoRow),
      diplomatic(twoRow: twoRow),
      for (final c in LibyaClass.values) lettered(c, twoRow: twoRow),
    ],
  ];

  static PlateSpec _build(_Face face, {LibyaClass? cls}) {
    final id = <String>['ly', face.id, ?cls?.id].join('.');
    return _cache[id] ??= _spec(id, face, cls);
  }

  static PlateSpec _spec(String id, _Face face, LibyaClass? cls) {
    final slots = <PlateSlot>[];
    final groups = <PlateTextGroup>[];
    for (final r in face.regs) {
      groups.add(PlateTextGroup(<int>[slots.length], key: r.key));
      slots.add(
        PlateSlot(
          alphabet: LibyaAlphabets.digits,
          box: PlateBox(
            r.centre - r.max * r.pitch / 2,
            r.cy - r.height / 2,
            r.max * r.pitch,
            r.height,
          ),
          length: r.max,
          minLength: r.min,
          spacing: max(0, r.pitch - 0.6 * 0.72 * r.height),
        ),
      );
    }
    final letter = face.letter;
    return PlateSpec(
      id: id,
      country: LibyaCountry.libya,
      canvasWidth: face.width,
      canvasHeight: face.height,
      panel: const PlatePanel(box: PlateBox(0, 0, 0, 0)),
      noPanel: true,
      background: face.background,
      borderWidthRatioOverride: face.border,
      slots: slots,
      rules: <PlateRule>[for (final b in face.dashes) PlateRule(box: b)],
      labels: <PlateLabel>[
        for (final t in face.texts) _label(t, t.text),
        if (letter != null && cls != null) _label(letter, cls.letter),
      ],
      textGroups: groups,
      resolveRegion: LibyaRegions.captionOf,
    );
  }

  static const double _lineHeight = 0.6;

  /// The line box as a fraction of glyph; `glyphStyle` sets the font size to
  /// 0.72 of it.
  static const double _lineBox = _lineHeight * 0.72;

  static PlateLabel _label(_Text t, String text) => PlateLabel(
    text: text,
    // `Center` only centres a line that fits its box, and a full-height box
    // would leave the canvas once a letter is lifted by its descent; a short
    // line box fits a short label box.
    box: PlateBox(
      t.cx - t.width / 2 - t.dx * t.glyph,
      t.cy - t.dy * t.glyph - _lineBox * t.glyph / 2,
      t.width,
      _lineBox * t.glyph,
    ),
    glyphHeight: t.glyph,
    lineHeight: _lineHeight,
  );
}
