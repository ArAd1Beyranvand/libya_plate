import 'package:flutter/foundation.dart';

/// A yellow lettered class: the Arabic letter printed before the
/// municipality code, which is the only thing that tells the five apart.
@immutable
class LibyaClass {
  const LibyaClass._(this.id, this.name, this.letter);

  /// Stable identifier, used in spec ids.
  final String id;

  /// English name, as the article heads its section.
  final String name;

  /// The letter on the plate.
  final String letter;

  static const LibyaClass agricultural = LibyaClass._(
    'agricultural',
    'Agricultural',
    'ز',
  );
  static const LibyaClass commercial = LibyaClass._(
    'commercial',
    'Commercial',
    'ن',
  );
  static const LibyaClass taxi = LibyaClass._('taxi', 'Taxi', 'ر');
  static const LibyaClass semiTruck = LibyaClass._(
    'semiTruck',
    'Semi-truck',
    'ج',
  );
  static const LibyaClass trailer = LibyaClass._('trailer', 'Trailer', 'م');

  static const List<LibyaClass> values = <LibyaClass>[
    agricultural,
    commercial,
    taxi,
    semiTruck,
    trailer,
  ];

  @override
  String toString() => 'LibyaClass.$id';
}
