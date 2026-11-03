FREE PALESTINE 🇮🇷🇵🇸 پاینده ایران

GO VEGAN 🌱

==================================

From the mighty people of Iran to the steadfast people of Libya to view examples:

https://platexample.ir/#/discover/libya:kotlin

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

### Install (Kotlin)

Copy `kotlin/src/commonMain/kotlin/plates/countries/libya/` into `plate_core/kotlin/src/commonMain/kotlin/plates/countries/`.

Then run the tests from `plate_core/kotlin/`: `./gradlew jvmTest`.

### Use

```kotlin
import plates.countries.libya.country

val spec = country.specs["ly.private.1"]
println(country.pkg)
```

## Specs

The specs are the same in every language (they come from shared data).

- `ly.private.1`
- `ly.foreign.1`
- `ly.diplomatic.1`
- `ly.lettered.1.agricultural`
- `ly.lettered.1.commercial`
- `ly.lettered.1.taxi`
- `ly.lettered.1.semiTruck`
- `ly.lettered.1.trailer`
- `ly.private.2`
- `ly.foreign.2`
- `ly.diplomatic.2`
- `ly.lettered.2.agricultural`
- `ly.lettered.2.commercial`
- `ly.lettered.2.taxi`
- `ly.lettered.2.semiTruck`
- `ly.lettered.2.trailer`

## Themes

- `LibyaThemes.white`
- `LibyaThemes.yellow`
- `LibyaThemes.red`

## Change it

- Specs: `country.specs`, by id.
- Themes: `country.themes`.
- Validators: `country.validators` (`LibyaPlateValidator`).

## License

See [LICENSE](https://github.com/ArAd1Beyranvand/libya_plate/blob/main/LICENSE).
