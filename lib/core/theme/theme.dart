import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF0D47A1);
  static const Color secondaryColor = Color(0xFF00BFA5);
  static const Color backgroundColor = Color(0xFFF7F9FC);

  // Typography
  static TextTheme get textTheme => TextTheme(
        displayLarge: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(fontSize: 16),
        bodyMedium: GoogleFonts.inter(fontSize: 14),
      );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor, primary: primaryColor, secondary: secondaryColor, background: backgroundColor),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: primaryColor)),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(useMaterial3: true, textTheme: textTheme);
  }
}
