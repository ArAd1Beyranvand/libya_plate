import 'dart:math';

import 'package:plate_core/plate_core.dart';

import 'libya_alphabets.dart';
import 'libya_colors.dart';
import 'libya_country.dart';
import 'libya_regions.dart';
import 'libya_usage.dart';

/// Where the ink sits on the 2013 Libyan plates, in millimetres.
///
/// The article gives 520×110 for the one-row plate and 270×150 for the
/// two-row. Every reference is artwork, normalised to those sizes: the white,
/// foreign and diplomatic SVGs (aspect 4.60 and 1.87 against the documented
/// 4.73 and 1.80, so their x is stretched 3% / compressed 4%), and the yellow
/// PNGs cropped first to the outer edge of their frame (4.68, 1.84). Measured
/// ink, centre x / centre y / height:
///
/// * Private one-row (`Single_Row_Regular…`, `Single_Row_License…`):
///   municipality 42.5 / 45.3, dash x 84.3..105.4 y 57.5..67.2, digits
///   y 22..88.4 (66.4 tall, cy 55.2) at a 35.2 pitch for both six and seven
///   digits — the serial re-centres on ~252 as it grows — `ليبيا` x
///   389.8..490.2, cy 56.3.
/// * Foreign one-row: blue strip to x 102.4, code cells 39.2 / 74.6,
///   municipality 140.6, dash x 180.2..200.9, serial centre 294.2, `ليبيا`
///   x 387..489.3.
/// * Diplomatic one-row: serial cells centre 69.5, dash x 126.6..147.7, code
///   centre 205.4, digits cy 53.7; `هيئة سياسية` x 278.1..496.7, y 26.2..81.2.
/// * Lettered one-row (yellow): letter ink 29–45 wide, centred on average
///   38.1 / 61.6 (cx 34.8–41.2, cy 52.9–67.9 by letter), municipality 87.8, dash x 134..146.2 y 54.3..62.7, serial pitch 31.9
///   centre 264.3, digits y 21.2..82.2 (cy 51.7), `ليبيا` x 383.9..490.2.
/// * Private two-row: municipality 67.8 cy 41.6, dash x 99.2..115.7
///   y 43.8..51.7, `ليبيا` x 136.4..215.9 cy 42.4; serial pitch 28.0, digits
///   y 80.5..137.2. The serial centres 138.3 here and 131.4 on the foreign
///   plate; both are put on the plate centre, 135.
/// * Foreign two-row: blue block x ..85.9, y ..69.5; code cells 33.3 / 61.3,
///   municipality 117.4, no dash, `ليبيا` x 147.7..244.6; serial cy 107.
/// * Diplomatic two-row: caption x 45.9..222.4 y 13.1..69.3; serial cells
///   centre 81.6, dash x 126.9..143.5 y 106.2..114.3, code centre 189.5,
///   digits cy 104.
/// * Lettered two-row: municipality 47.5 cy 39.7, dash x 93.2..103.8
///   y 44..51.1, `ليبيا` x 149..235.1 cy 37.8; letter ink 27–37 wide,
///   centred on average 35.9 / 115.1 at the bottom left; serial pitch 26.05 centre 145, cy 108.7.
///
/// The blue code box is a `PlateSection` of the background, running under the
/// frame to the plate edge. Dashes are short `PlateRule`s.
///
/// **Under-size digits, accepted.** The plates use a condensed face; a slot
/// scales its glyph down to fit its cell, and DejaVu/Roboto Bold digits are
/// far wider than the plate's, so the digits are width-limited by the
/// measured pitch and come out shorter than the reference (see the goldens).
/// The x positions are kept; `plate_core` is unchanged.
///
/// **Not drawn.** The artwork's thin outer line and the gap inside it: the
/// engine paints one frame, so the frame is the inner stroke's width at the
/// plate edge. `هيئة سياسية` is set in the theme's face, not Ruqʿah.
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

/// A field of [min]..[max] digits centred on [centre]; the digits centre in a
/// box sized for the longest run.
class _Reg {
  const _Reg(
    this.key,
    this.centre,
    this.cy,
    this.pitch,
    this.height,
    this.max, {
    this.min = 1,
  });
  final String key;
  final double centre, cy, pitch, height;
  final int min, max;
}

/// A fixed word, placed by its ink centre and sized by [glyph].
///
/// [glyph] is the size whose ink spans [width]: measured off the goldens,
/// `ليبيا` inks 1.29 units wide per unit of glyph and the caption 4.37. An
/// overflowing label stops being centred, so the ink must fit the box.
///
/// A label centres its line box, not its ink. [dx] and [dy] (fractions of
/// [glyph]) are where the ink lands relative to the box, measured the same
/// way: `ليبيا` sits 0.06 right and 0.035 low, the caption 0.04 right and
/// low, and the class letters, whose bowls hang below the line, 0.18 low
/// (ر lower, ن higher: one figure for all five). The box is moved by the opposite
/// amount so [cx], [cy] stay the reference's ink centre.
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

/// One design on one format: everything but the digit counts and the class
/// letter.
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

  /// Where the class letter goes; its text is substituted at build time.
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
      PlatePart(
        PlateSection.fill(PlateFill.color(LibyaColors.foreignBlue)),
        end: 102.4,
      ),
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
          PlatePart(
            PlateSection.fill(PlateFill.color(LibyaColors.foreignBlue)),
            end: 85.9,
          ),
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

/// The 2013 series, one row (520×110) or two (270×150).
///
/// * [private] — `8 - 616192 ليبيا`, black on white. Municipality 1–2
///   digits, serial 1–7 (7 only in Tripoli).
/// * [foreign] — the owner's country code (2–3 digits) in a blue box, then
///   municipality and a 1–4 digit serial.
/// * [diplomatic] — `11 - 13 هيئة سياسية` on red: a 1–2 digit serial and the
///   mission's country code, with no `ليبيا`.
/// * [lettered] — the five yellow classes (`LibyaClass`), the class letter
///   before the municipality code; serial 1–6.
///
/// Pair private and foreign with `LibyaThemes.white`, diplomatic with
/// `.red`, lettered with `.yellow`. Each field is one slot, sized for its longest run.
///
/// The foreign-country code table in the article has no code for Israel, so
/// there is nothing to refuse. Not implemented: the 1960s white-on-black, the
/// 1998–2012 `الجماهيرية` series and the Italian colonial plates.
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

  /// Every design, one and two rows.
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

  /// The line box, as a fraction of glyph: `glyphStyle` sets the font size
  /// to 0.72 of it.
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
