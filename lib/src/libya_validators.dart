import 'package:plate_core/plate_core.dart';

/// Advisory validator for any `LibyaPlates` value.
///
/// Checks the municipality code against the published table, a serial without
/// a leading zero, and the foreign or diplomatic country code against its
/// table. Groups a spec does not carry are skipped.
class LibyaPlateValidator extends GatedPlateValidator {
  const LibyaPlateValidator();

  @override
  String get gateGroup => 'serial';

  static const String reasonMunicipality =
      'Not a municipality code in the published table.';
  static const String reasonSerial = 'The serial does not start with 0.';
  static const String reasonCountry =
      'Not a country code in the published table.';

  /// The municipality table's codes. 23, 29, 31, 34 and 39 are absent.
  static final Set<int> municipalities = <int>{
    for (var i = 1; i <= 67; i++) i,
  }.difference(const <int>{23, 29, 31, 34, 39});

  static const Set<int> countries = <int>{
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, //
    28, 30, 31, 32, 33, 34, 35, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
    48, 49, 50, 51, 52, 53, 54, 55, 56, 58, 59, 60, 61, 62, 63, 64, 65, 66,
    67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84,
    85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 99, 106, 108, 111,
    119, 120, 125, 130, 157, 180, 190,
  };

  @override
  PlateValidation judge(PlateEntry entry) {
    final keys = entry.spec.textGroups.map((g) => g.key).toSet();
    if (keys.contains('municipality')) {
      final m = entry.group('municipality');
      if (!isDigits(m) || !municipalities.contains(int.parse(m))) {
        return const PlateValidation.invalid(reasonMunicipality);
      }
    }
    final s = entry.group('serial');
    if (!isDigits(s) || s.startsWith('0')) {
      return const PlateValidation.invalid(reasonSerial);
    }
    if (keys.contains('country')) {
      final c = entry.group('country');
      if (!isDigits(c) || !countries.contains(int.parse(c))) {
        return const PlateValidation.invalid(reasonCountry);
      }
    }
    return const PlateValidation.valid();
  }
}
