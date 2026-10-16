import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'libya_colors.dart';

/// Black ink on one field per class. Frame width differs between one- and
/// two-row plates, so it lives on each spec (`borderWidthRatioOverride`). The
/// corner radius is estimated by eye.
abstract final class LibyaThemes {
  /// Private and foreign-owned plates.
  static final PlateTheme white = _ink(LibyaColors.white);

  /// The five lettered classes: agricultural, commercial, taxi, semi-truck,
  /// trailer.
  static final PlateTheme yellow = _ink(LibyaColors.yellow);

  /// Diplomatic and consular plates.
  static final PlateTheme red = _ink(LibyaColors.red);
}

PlateTheme _ink(Color field) => PlateTheme.monochrome(
  field: field,
  ink: LibyaColors.ink,
  inactive: LibyaColors.inactive,
  borderWidthRatio: 0.037,
  plateRadiusRatio: 0.07,
);
