import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF00FFCC),
      scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF00BFA5),
        secondary: Color(0xFF651FFF),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.black54),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF00FFCC), // Cyberpunk primary
      scaffoldBackgroundColor: const Color(0xFF0A0E17), // Deep space
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFCC),
        secondary: Color(0xFFB13BFF), // Neon purple
        surface: Color(0xFF131A2A),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
