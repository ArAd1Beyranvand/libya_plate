import 'package:flutter_test/flutter_test.dart';
import 'package:libya_plate/libya_plate.dart';

void main() {
  test('municipality codes resolve', () {
    expect(LibyaRegions.lookup('8'), 'Benghazi');
    expect(LibyaRegions.lookup('63'), 'Janzur');
    expect(LibyaRegions.lookup('5'), isNull);
  });

  test('ambiguous prefixes, empty and unlisted codes are null', () {
    expect(LibyaRegions.lookup('1'), isNull);
    expect(LibyaRegions.lookup(''), isNull);
    expect(LibyaRegions.lookup('99'), isNull);
  });
}
