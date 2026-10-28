FREE PALESTINE 🇮🇷🇵🇸 پاینده ایران

GO VEGAN 🌱

==================================

From the mighty people of Iran to the steadfast people of Libya to view examples:

https://platexample.ir/#/discover/libya

# libya_plate

Libya's licence plates for the `plate_core` library. The 2013 series in one row (520×110) and two (270×150): private and foreign-owned on white, diplomatic on red, and the five lettered classes on yellow. The 1960s, 1998–2012 Jamahiriya and Italian colonial series are not implemented.

## Install

```yaml
dependencies:
  plate_core: ^0.12.0
  libya_plate: ^0.1.0
```

## Use

```dart
import 'package:plate_core/plate_core.dart';
import 'package:libya_plate/libya_plate.dart';

PlateCanvas(
  spec: LibyaPlates.private(),
  theme: LibyaThemes.white,
  validator: const LibyaPlateValidator(),
  autoValidate: true,
  onChooseCharacter: noCharacterChooser,
);
```

## Contains

- `LibyaCountry` — country panel: `libya`.
- `LibyaPlates` — 4 plate specs (factories): `private()`, `foreign()`, `diplomatic()`, `lettered()`.
- `LibyaThemes` — 3 themes: `white`, `yellow`, `red`.
- `LibyaPlateValidator` — advisory validator; flags the frame, never blocks a keystroke.
- `LibyaRegions` — code table.

## Plates

The 2013 series, one row (520×110) or two (270×150). Each field is one slot
sized for its longest run.

* `private`: municipality 1-2 digits, serial 1-7 (7 only in Tripoli).
  Theme `LibyaThemes.white`.
* `foreign`: the owner's country code (2-3 digits) in a blue box, then
  municipality and a 1-4 digit serial. Theme `white`.
* `diplomatic`: a 1-2 digit serial and the mission's country code, with no
  `ليبيا`. Theme `red`.
* `lettered`: the five yellow classes (`LibyaClass`), class letter before
  the municipality code; serial 1-6. Theme `yellow`.

Earlier series (1960s, 1998-2012, colonial) are not implemented.

## Part of plate

Painted by [`plate_core`](https://pub.dev/packages/plate_core); alphabets shared through [`plate_alphabet`](https://pub.dev/packages/plate_alphabet); optional character picker in [`plate_keypad`](https://pub.dev/packages/plate_keypad).

