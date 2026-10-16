import 'package:flutter/widgets.dart';

/// The 2013 plate colours, sampled as the modal colour of each artwork region.
abstract final class LibyaColors {
  static const Color white = Color(0xFFFFFFFF);

  /// Every plate's ink and frame.
  static const Color ink = Color(0xFF000000);

  /// The lettered classes' field: a warm golden yellow, not lemon.
  static const Color yellow = Color(0xFFFFC813);

  /// The diplomatic field.
  static const Color red = Color(0xFFAF1B1F);

  /// The foreign owner's country-code box.
  static const Color foreignBlue = Color(0xFF0279C1);

  static const Color inactive = Color(0xFFB0B0B0);
}
