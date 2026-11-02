## Unreleased

- Each field (country, municipality, serial) is one `PlateSlot` with a `minLength` and `length` instead of a `plateRegister` of single cells. A value is one string per slot: `['8', '616192']`.
- Removed the digit-count parameters of `private`, `foreign`, `diplomatic` and `lettered`; one spec per face now takes every length. Digits centre in the field rather than being laid out per count.
