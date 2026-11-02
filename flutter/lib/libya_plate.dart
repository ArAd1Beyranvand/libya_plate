/// Libya's licence plates for the `plate_core` library.
///
/// The 2013 series in one row (520×110) and two (270×150): private and
/// foreign-owned on white, diplomatic on red, and the five lettered classes
/// on yellow. The 1960s, 1998–2012 Jamahiriya and Italian colonial series are
/// not implemented.
library;

// TODO(py): [D5] one module `plates.countries.libya`; assets via importlib.resources.
// TODO(ts): [D5] one subpath export `./countries/libya`; tree-shakable.
// TODO(kt): [D5] package `countries.libya` in the countries module.
export 'src/libya_alphabets.dart';
export 'src/libya_colors.dart';
export 'src/libya_country.dart';
export 'src/libya_plates.dart';
export 'src/libya_regions.dart';
export 'src/libya_themes.dart';
export 'src/libya_usage.dart';
export 'src/libya_validators.dart';
