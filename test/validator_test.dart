import 'package:flutter_test/flutter_test.dart';
import 'package:libya_plate/libya_plate.dart';
import 'package:plate_core/plate_core.dart';

void main() {
  PlateValidation judge(PlateSpec spec, String value) =>
      const LibyaPlateValidator().validate(
        PlateEntry(spec: spec, values: value.split('')),
      );

  test('accepts the article examples', () {
    expect(judge(LibyaPlates.private(), '8616192').isValid, isTrue);
    expect(
      judge(LibyaPlates.private(serialDigits: 7), '51593257').isValid,
      isTrue,
    );
    expect(judge(LibyaPlates.foreign(), '3933123').isValid, isTrue);
    expect(judge(LibyaPlates.diplomatic(), '1113').isValid, isTrue);
  });

  test('rejects a municipality code missing from the table', () {
    expect(
      judge(LibyaPlates.private(municipalityDigits: 2), '23616192').isValid,
      isFalse,
    );
  });

  test('rejects a country code missing from the table', () {
    expect(judge(LibyaPlates.diplomatic(), '1129').isValid, isFalse);
  });

  test('rejects a leading zero in the serial', () {
    expect(judge(LibyaPlates.private(), '8016192').isValid, isFalse);
  });

  test('slot counts follow the digit parameters', () {
    expect(LibyaPlates.private(serialDigits: 7).slotCount, 8);
    expect(LibyaPlates.foreign(countryDigits: 3, twoRow: true).slotCount, 8);
    expect(identical(LibyaPlates.private(), LibyaPlates.private()), isTrue);
  });

  test('every digit combination builds a valid spec', () {
    for (final two in const <bool>[false, true]) {
      for (var m = 1; m <= 2; m++) {
        for (var s = 1; s <= 7; s++) {
          expect(
            debugValidateSpec(
              LibyaPlates.private(
                twoRow: two,
                municipalityDigits: m,
                serialDigits: s,
              ),
            ),
            isTrue,
          );
        }
      }
      for (var c = 2; c <= 3; c++) {
        expect(
          debugValidateSpec(
            LibyaPlates.foreign(
              twoRow: two,
              countryDigits: c,
              municipalityDigits: 2,
            ),
          ),
          isTrue,
        );
        expect(
          debugValidateSpec(
            LibyaPlates.diplomatic(twoRow: two, countryDigits: c),
          ),
          isTrue,
        );
      }
    }
  });
}
