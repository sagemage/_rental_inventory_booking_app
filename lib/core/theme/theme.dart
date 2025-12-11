import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Theme Configuration
/// 
/// Provides a cohesive Material Design 3 theme with:
/// - Custom color scheme optimized for rental/booking experience
/// - Google Fonts typography (Poppins for headers, Inter for body)
/// - Consistent widget customizations

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ============================================================================
  // COLOR SCHEME
  // ============================================================================
  
  /// Primary color - Professional Blue (Trust & Reliability)
  static const Color primaryColor = Color(0xFF0066CC); // Vibrant Blue
  
  /// Secondary color - Vibrant Teal (Energy & Growth)
  static const Color secondaryColor = Color(0xFF00BFA5); // Teal
  
  /// Tertiary color - Warm Orange (Engagement & Warmth)
  static const Color tertiaryColor = Color(0xFFFF6B35); // Warm Orange
  
  /// Background color - Clean White
  static const Color backgroundColor = Color(0xFFFAFAFA); // Off-white
  
  /// Surface color - Light Gray
  static const Color surfaceColor = Color(0xFFF5F5F5);
  
  /// Error color - Red
  static const Color errorColor = Color(0xFFE74C3C); // Bright Red
  
  /// Success color - Green
  static const Color successColor = Color(0xFF27AE60); // Forest Green
  
  /// Warning color - Amber
  static const Color warningColor = Color(0xFFF39C12); // Amber
  
  /// Text colors
  static const Color textDarkColor = Color(0xFF1A1A1A); // Near Black
  static const Color textLightColor = Color(0xFF666666); // Medium Gray
  static const Color textHintColor = Color(0xFF999999); // Light Gray
  
  /// Divider color
  static const Color dividerColor = Color(0xFFE0E0E0);

  // ============================================================================
  // TYPOGRAPHY - POPPINS (Headers & Bold) + INTER (Body & Regular)
  // ============================================================================
  
  /// Display Large - Hero titles (28sp, bold, tracking: 0)
  static TextStyle get displayLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    color: textDarkColor,
  );

  /// Display Medium - Large section titles (24sp, bold)
  static TextStyle get displayMedium => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    color: textDarkColor,
  );

  /// Display Small - Medium section titles (20sp, bold)
  static TextStyle get displaySmall => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    color: textDarkColor,
  );

  /// Headline Large - Page titles (22sp, semibold)
  static TextStyle get headlineLarge => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: textDarkColor,
  );

  /// Headline Medium - Subsection titles (18sp, semibold)
  static TextStyle get headlineMedium => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: textDarkColor,
  );

  /// Headline Small - Card titles (16sp, semibold)
  static TextStyle get headlineSmall => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: textDarkColor,
  );

  /// Title Large - Strong body text (16sp, semibold)
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: textDarkColor,
  );

  /// Title Medium - Medium emphasis text (14sp, medium)
  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: textDarkColor,
  );

  /// Title Small - Small emphasis text (12sp, medium)
  static TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: textDarkColor,
  );

  /// Body Large - Primary body text (16sp, regular)
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    color: textDarkColor,
    height: 1.5,
  );

  /// Body Medium - Secondary body text (14sp, regular)
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    color: textLightColor,
    height: 1.43,
  );

  /// Body Small - Tertiary body text (12sp, regular)
  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    color: textLightColor,
    height: 1.33,
  );

  /// Label Large - Button labels (14sp, medium)
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: Colors.white,
  );

  /// Label Medium - Badge/chip text (12sp, medium)
  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: textDarkColor,
  );

  /// Label Small - Caption text (11sp, medium)
  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: textHintColor,
  );

  // ============================================================================
  // MATERIAL THEME DATA
  // ============================================================================

  /// Light Theme for the app
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        tertiary: tertiaryColor,
        onTertiary: Colors.white,
        error: errorColor,
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: textDarkColor,
        background: backgroundColor,
        onBackground: textDarkColor,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: backgroundColor,
      
      // App Bar
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: textDarkColor,
        centerTitle: false,
        titleTextStyle: headlineLarge.copyWith(color: textDarkColor),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          textStyle: labelLarge,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: labelLarge.copyWith(color: primaryColor),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: labelLarge.copyWith(color: primaryColor),
        ),
      ),
      
      // Input Decoration (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: bodyMedium.copyWith(color: textHintColor),
        labelStyle: bodyMedium.copyWith(color: textLightColor),
        errorStyle: bodySmall.copyWith(color: errorColor),
        prefixIconColor: textLightColor,
        suffixIconColor: textLightColor,
      ),
      
      // Card Theme
      cardTheme: const CardThemeData().copyWith(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: primaryColor,
        disabledColor: dividerColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: labelMedium,
        secondaryLabelStyle: labelMedium.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 0,
      ),
      
      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: dividerColor,
        circularTrackColor: dividerColor,
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: primaryColor,
        unselectedItemColor: textLightColor,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Dark Theme for the app (optional)
  static ThemeData get darkTheme {
    const darkBg = Color(0xFF121212);
    const darkSurface = Color(0xFF1E1E1E);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.black,
        tertiary: tertiaryColor,
        onTertiary: Colors.black,
        error: errorColor,
        onError: Colors.black,
        surface: darkSurface,
        onSurface: Colors.white,
        background: darkBg,
        onBackground: Colors.white,
      ),
      
      scaffoldBackgroundColor: darkBg,
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        centerTitle: false,
        titleTextStyle: headlineLarge.copyWith(color: Colors.white),
      ),
      
      textTheme: TextTheme(
        displayLarge: displayLarge.copyWith(color: Colors.white),
        displayMedium: displayMedium.copyWith(color: Colors.white),
        displaySmall: displaySmall.copyWith(color: Colors.white),
        headlineLarge: headlineLarge.copyWith(color: Colors.white),
        headlineMedium: headlineMedium.copyWith(color: Colors.white),
        headlineSmall: headlineSmall.copyWith(color: Colors.white),
        titleLarge: titleLarge.copyWith(color: Colors.white),
        titleMedium: titleMedium.copyWith(color: Colors.white70),
        titleSmall: titleSmall.copyWith(color: Colors.white60),
        bodyLarge: bodyLarge.copyWith(color: Colors.white),
        bodyMedium: bodyMedium.copyWith(color: Colors.white70),
        bodySmall: bodySmall.copyWith(color: Colors.white60),
        labelLarge: labelLarge,
        labelMedium: labelMedium.copyWith(color: Colors.white),
        labelSmall: labelSmall.copyWith(color: Colors.white54),
      ),
    );
  }
}