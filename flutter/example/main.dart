import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';
import 'package:libya_plate/libya_plate.dart';

void main() => runApp(
  PlateExampleApp(spec: LibyaPlates.private(), theme: LibyaThemes.white),
);
