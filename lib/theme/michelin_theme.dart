import 'package:flutter/material.dart';

class MichelinTheme {
  // Michelin Brand Colors
  static const Color blueMichelin = Color(0xFF1C4494);
  static const Color yellowMichelin = Color(0xFFFFF000);
  
  // UI Colors
  static const Color textMuted = Color(0xFF5C76A6);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color borderGrey = Color(0xFFE2E8F0);
  
  // Custom Styles
  static const TextStyle headerStyle = TextStyle(
    color: Colors.white,
    fontSize: 36,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle yellowHeaderStyle = TextStyle(
    color: yellowMichelin,
    fontSize: 36,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );
}
