FREE PALESTINE 🇮🇷🇵🇸 پاینده ایران

GO VEGAN 🌱

==================================

From the mighty people of Iran to the steadfast people of Libya to view examples:

https://platexample.ir/#/discover/libya:flutter

# libya_plate

Libya's licence plates for plate_core: the 2013 series in one and two rows: private, foreign-owned, diplomatic and the five lettered yellow classes, and more.

## Languages

| Language | Folder | Example |
| --- | --- | --- |
| Flutter / Dart | [`flutter/`](https://github.com/ArAd1Beyranvand/libya_plate/tree/main/flutter) | [platexample](https://platexample.ir/#/discover/libya:flutter) |
| Kotlin | [`kotlin/`](https://github.com/ArAd1Beyranvand/libya_plate/tree/main/kotlin) | [platexample](https://platexample.ir/#/discover/libya:kotlin) |
| Python | [`python/`](https://github.com/ArAd1Beyranvand/libya_plate/tree/main/python) | [platexample](https://platexample.ir/#/discover/libya:python) |
| TypeScript | [`typescript/`](https://github.com/ArAd1Beyranvand/libya_plate/tree/main/typescript) | [platexample](https://platexample.ir/#/discover/libya:typescript) |

## Quick start

### Install

```yaml
dependencies:
  plate_core: ^0.12.0
  libya_plate: ^0.1.0
```

### Use

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

## Specs

Each spec is one plate layout.

- `LibyaPlates.private`(…)
- `LibyaPlates.foreign`(…)
- `LibyaPlates.diplomatic`(…)
- `LibyaPlates.lettered`(…)

## Themes

- `LibyaThemes.white`
- `LibyaThemes.yellow`
- `LibyaThemes.red`

## Change it

`PlateCanvas` takes `spec:` (an entry of `LibyaPlates`) and `theme:` (an entry of `LibyaThemes`). Set `validator:` to `LibyaPlateValidator()` and `autoValidate: true` to show validation hints.

## Also included

- `LibyaCountry` — the country panel.
- `LibyaPlateValidator` — the plate validator.
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

## License

See [LICENSE](https://github.com/ArAd1Beyranvand/libya_plate/blob/main/LICENSE).
