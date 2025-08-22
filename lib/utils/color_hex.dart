// lib/utils/color_hex.dart
import 'package:flutter/material.dart';

Color colorFromHex(String hex) {
  var h = hex.replaceAll('#', '').trim();
  if (h.length == 6) h = 'FF$h';
  final v = int.tryParse(h, radix: 16) ?? 0xFFF3F4F6;
  return Color(v);
}
