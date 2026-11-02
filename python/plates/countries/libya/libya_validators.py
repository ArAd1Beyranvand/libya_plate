"""Port of libya_plate/lib/src/libya_validators.dart. Hand-ported; codegen never overwrites this file."""
from __future__ import annotations

from plates.core.validators.plate_validator import GatedPlateValidator, PlateEntry, PlateValidation, is_digits

_MUNICIPALITIES = frozenset(range(1, 68)) - {23, 29, 31, 34, 39}
_COUNTRIES = frozenset((
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
    28, 30, 31, 32, 33, 34, 35, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
    48, 49, 50, 51, 52, 53, 54, 55, 56, 58, 59, 60, 61, 62, 63, 64, 65, 66,
    67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84,
    85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 99, 106, 108, 111,
    119, 120, 125, 130, 157, 180, 190,
))


class LibyaPlateValidator(GatedPlateValidator):
    gate_group = "serial"
    REASON_MUNICIPALITY = "Not a municipality code in the published table."
    REASON_SERIAL = "The serial does not start with 0."
    REASON_COUNTRY = "Not a country code in the published table."
    municipalities = _MUNICIPALITIES
    countries = _COUNTRIES

    def judge(self, entry: PlateEntry) -> PlateValidation:
        keys = {g.key for g in entry.spec.text_groups}
        if "municipality" in keys:
            m = entry.group("municipality")
            if not is_digits(m) or int(m) not in _MUNICIPALITIES:
                return PlateValidation.invalid(self.REASON_MUNICIPALITY)
        s = entry.group("serial")
        if not is_digits(s) or s.startswith("0"):
            return PlateValidation.invalid(self.REASON_SERIAL)
        if "country" in keys:
            c = entry.group("country")
            if not is_digits(c) or int(c) not in _COUNTRIES:
                return PlateValidation.invalid(self.REASON_COUNTRY)
        return PlateValidation.valid()
