import 'package:flutter/material.dart';

class Constants {
  static const DEFAULT_FONT = 'OpenSans';
  static const HEADING_FONT = 'Montserrat';
  static const FIXED_FONT = 'SourceCodePro';
  static const BG_COLOR = Color.fromRGBO(240, 240, 240, 1);
}

String constructNameForEnum(Object enumEntry) {
  final String description = enumEntry.toString();
  final int indexOfDot = description.indexOf('.');
  assert(indexOfDot != -1 && indexOfDot < description.length - 1);
  return description.substring(indexOfDot + 1);
}
