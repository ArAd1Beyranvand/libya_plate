import 'package:plate_core/plate_core.dart';

/// Locates a Libyan plate from its municipality code (Wikipedia's
/// "Municipality Codes" table).
abstract final class LibyaRegions {
  static const Map<String, String> _municipalities = <String, String>{
    '1': 'Sabha',
    '2': 'Bayda',
    '3': 'Misrata',
    '4': 'Zawiya',
    '5': 'Tripoli',
    '6': 'Al Khums',
    '7': 'Sirte',
    '8': 'Benghazi',
    '9': 'Zuwarah',
    '10': 'Derna',
    '11': 'Al Shatii al Sharqi',
    '12': 'Ajdabiya',
    '13': 'Hun',
    '14': 'Tobruk',
    '15': 'Murzuq',
    '16': 'Jalu',
    '17': 'Ghadames',
    '18': 'Marj',
    '19': 'Nalut',
    '20': 'Kufra',
    '21': 'Gharyan',
    '22': 'Yafran',
    '24': 'Ubari',
    '25': 'Aziziya',
    '26': 'Sabratha',
    '27': 'Tarhuna',
    '28': 'Bani Walid',
    '30': 'Al Abyar',
    '32': 'Ghat',
    '33': 'Qasr bin Ghashir',
    '35': 'Shahhat (Cyrene)',
    '36': 'Zliten',
    '37': 'Baten Al Jabal',
    '38': 'Mizda',
    '40': 'Jumayl',
    '41': 'Al Ajaylat',
    '42': 'Zintan',
    '43': 'Jadu',
    '44': 'Msallata',
    '45': 'Sahel El-Jebel',
    '46': 'Castelverde',
    '47': 'Sorman',
    '48': 'Kabaw',
    '49': 'Al Qubbah',
    '50': "Al Asbi'a",
    '51': 'Ras Lanuf',
    '52': 'Tocra',
    '53': 'Kikla',
    '54': 'Al Rhibat',
    '55': 'Al Shatii al Gharbi',
    '56': 'Al Rijban',
    '57': 'Harraba',
    '58': 'Southern Marj',
    '59': 'Al Shagiga',
    '60': 'Ras al-Helal',
    '61': 'Zaltan',
    '62': 'Qatrun',
    '63': 'Janzur',
    '64': 'Al Shwayrif',
    '65': 'Al Riyayna',
    '66': 'Suluq/Qaminis',
    '67': 'Awjila/Jikharra',
  };

  /// The municipality [code] already pins down, or null when empty, unlisted,
  /// or still a prefix of codes for different places (`1` may become `12`).
  static String? lookup(String code) {
    if (code.isEmpty) return null;
    final Set<String> names = <String>{
      for (final MapEntry<String, String> e in _municipalities.entries)
        if (e.key.startsWith(code)) e.value,
    };
    return names.length == 1 ? names.single : null;
  }

  /// A [PlateLabelResolver] for [PlateSpec.resolveRegion].
  static String? captionOf(String Function(String key) group) =>
      lookup(group('municipality'));
}
