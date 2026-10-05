import 'package:flutter/widgets.dart';

/// The colours of the 2013 Libyan plates, sampled as the modal colour of each
/// region of the article's artwork. The white, red and blue plates are one
/// author's SVGs (`Single_Row_*` / `Two_Row_*`); the yellow ones another's
/// PNGs (`Vehicle_Registration_Plate_-_Libya_-_*`).
abstract final class LibyaColors {
  static const Color white = Color(0xFFFFFFFF);

  /// Every plate's ink and frame. Sampled `000000` / `010101`.
  static const Color ink = Color(0xFF000000);

  /// The lettered classes' field, `FFC813`: a warm golden yellow, not the
  /// lemon `FFFF00` the article's "yellow" suggests.
  static const Color yellow = Color(0xFFFFC813);

  /// The diplomatic field, `AF1B1F`: a deep crimson.
  static const Color red = Color(0xFFAF1B1F);

  /// The foreign owner's country-code box, `0279C1`.
  static const Color foreignBlue = Color(0xFF0279C1);

  static const Color inactive = Color(0xFFB0B0B0);
}
