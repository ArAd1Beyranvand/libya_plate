import 'package:plate_core/plate_core.dart';

import 'libya_colors.dart';

/// Libya as a `PlateCountry`. The plate carries no flag or country block:
/// `ليبيا` is a label on the spec, so every spec sets `noPanel`.
abstract final class LibyaCountry {
  static const PlateCountry libya = PlateCountry(
    code: 'ly',
    captionLines: <String>[],
    panelColor: LibyaColors.white,
    panelTextColor: LibyaColors.ink,
  );
}
