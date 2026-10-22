import 'package:flutter_test/flutter_test.dart';
import 'package:libya_plate/libya_plate.dart';
import 'package:plate_core/plate_core.dart';

void main() {
  PlateValidation judge(PlateSpec spec, String value) =>
      const LibyaPlateValidator().validate(PlateEntry(spec: spec, values: value.split(' ')));

  test('accepts the article examples', () {
    expect(judge(LibyaPlates.private(), '8 616192').isValid, isTrue);
    expect(judge(LibyaPlates.private(), '51 593257').isValid, isTrue);
    expect(judge(LibyaPlates.private(), '5 1593257').isValid, isTrue);
    expect(judge(LibyaPlates.foreign(), '39 3 3123').isValid, isTrue);
    expect(judge(LibyaPlates.diplomatic(), '11 13').isValid, isTrue);
  });

  test('rejects a municipality code missing from the table', () {
    expect(judge(LibyaPlates.private(), '23 616192').isValid, isFalse);
  });

  test('rejects a country code missing from the table', () {
    expect(judge(LibyaPlates.diplomatic(), '11 29').isValid, isFalse);
  });

  test('rejects a leading zero in the serial', () {
    expect(judge(LibyaPlates.private(), '8 016192').isValid, isFalse);
  });

  test('each field is one slot with its own length range', () {
    final private = LibyaPlates.private();
    expect(private.slotCount, 2);
    expect(private.slots.map((s) => (s.minLength, s.length)), <(int, int)>[(1, 2), (1, 7)]);
    final foreign = LibyaPlates.foreign(twoRow: true);
    expect(foreign.slotCount, 3);
    expect(foreign.slots.first.minLength, 2);
    expect(foreign.slots.first.length, 3);
    expect(identical(LibyaPlates.private(), LibyaPlates.private()), isTrue);
  });

  test('every spec passes debugValidateSpec', () {
    for (final spec in LibyaPlates.all) {
      expect(debugValidateSpec(spec), isTrue, reason: spec.id);
    }
  });
}
