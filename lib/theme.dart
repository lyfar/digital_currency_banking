import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

// HSBC color palette
class HSBCColors {
  // Primary colors
  static const Color red = Color(0xFFEF0000);      // #EF0000
  static const Color black = Color(0xFF000000);    // #000000
  static const Color grey = Color(0xFF808080);     // #808080
  static const Color white = Color(0xFFFFFFFF);    // #FFFFFF
  
  // Additional colors
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF333333);
  static const Color mediumGrey = Color(0xFF666666);
  static const Color appBarGrey = Color(0xFF2D2D2D); // App bar gray color
  
  // Dark theme specific colors
  static const Color darkBackground = Color(0xFF121212);  // Dark background
  static const Color darkSurface = Color(0xFF1E1E1E);     // Dark surface
  static const Color darkCardColor = Color(0xFF2C2C2C);   // Dark card color
  static const Color darkIconColor = Color(0xFFE0E0E0);   // Light icon color for dark theme
  
  // Semantic colors
  static const Color success = Color(0xFF008A00);
  static const Color warning = Color(0xFFFFB900);
  static const Color error = Color(0xFFE81123);
  static const Color info = Color(0xFF0063B1);
}

// Helper function to create monospace digits style
TextStyle monospaceDigits(TextStyle baseStyle) {
  return baseStyle.copyWith(
    fontFamily: 'monospace',
    fontFeatures: [
      const FontFeature.tabularFigures(),
    ],
  );
}

// Light theme
ThemeData hsbcLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: HSBCColors.red,
    fontFamily: 'UniversNextforHSBC',
    colorScheme: const ColorScheme.light(
      primary: HSBCColors.red,
      onPrimary: HSBCColors.white,
      secondary: HSBCColors.black,
      onSecondary: HSBCColors.white,
      tertiary: HSBCColors.grey,
      background: HSBCColors.lightGrey,
      surface: HSBCColors.white,
      error: HSBCColors.error,
    ),
    scaffoldBackgroundColor: HSBCColors.lightGrey,
    appBarTheme: const AppBarTheme(
      backgroundColor: HSBCColors.appBarGrey,
      foregroundColor: HSBCColors.white,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardTheme(
      color: HSBCColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: HSBCColors.red,
        foregroundColor: HSBCColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: HSBCColors.red,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.black, 
          fontWeight: FontWeight.bold,
        ),
      ),
      headlineMedium: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.black, 
          fontWeight: FontWeight.bold,
        ),
      ),
      titleLarge: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.black, 
          fontWeight: FontWeight.w600,
        ),
      ),
      bodyLarge: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.black,
        ),
      ),
      bodyMedium: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.black,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: HSBCColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: HSBCColors.red, width: 2),
      ),
      filled: true,
      fillColor: HSBCColors.white,
    ),
    dividerTheme: const DividerThemeData(
      color: HSBCColors.grey,
      thickness: 1,
    ),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
  );
}

// Dark theme
ThemeData hsbcDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: HSBCColors.red,
    fontFamily: 'UniversNextforHSBC',
    colorScheme: const ColorScheme.dark(
      primary: HSBCColors.red,
      onPrimary: HSBCColors.white,
      secondary: HSBCColors.grey,
      onSecondary: HSBCColors.white,
      tertiary: HSBCColors.white,
      background: HSBCColors.darkBackground,
      surface: HSBCColors.darkSurface,
      error: HSBCColors.error,
      onBackground: HSBCColors.white,
      onSurface: HSBCColors.white,
    ),
    scaffoldBackgroundColor: HSBCColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: HSBCColors.darkSurface,
      foregroundColor: HSBCColors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: HSBCColors.white),
    ),
    cardTheme: CardTheme(
      color: HSBCColors.darkCardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: HSBCColors.red,
        foregroundColor: HSBCColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: HSBCColors.red,
      ),
    ),
    iconTheme: const IconThemeData(
      color: HSBCColors.darkIconColor,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.white, 
          fontWeight: FontWeight.bold,
        ),
      ),
      headlineMedium: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.white, 
          fontWeight: FontWeight.bold,
        ),
      ),
      titleLarge: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.white, 
          fontWeight: FontWeight.w600,
        ),
      ),
      bodyLarge: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.white,
        ),
      ),
      bodyMedium: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.white,
        ),
      ),
      labelMedium: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: HSBCColors.lightGrey,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: HSBCColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: HSBCColors.red, width: 2),
      ),
      filled: true,
      fillColor: HSBCColors.darkSurface,
      hintStyle: const TextStyle(color: HSBCColors.grey),
    ),
    dividerTheme: const DividerThemeData(
      color: HSBCColors.darkSurface,
      thickness: 1,
    ),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    chipTheme: ChipThemeData(
      backgroundColor: HSBCColors.darkCardColor,
      disabledColor: HSBCColors.darkSurface,
      selectedColor: HSBCColors.red,
      secondarySelectedColor: HSBCColors.red,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(color: HSBCColors.white),
      secondaryLabelStyle: const TextStyle(color: HSBCColors.white),
    ),
  );
}

// Cupertino themes
CupertinoThemeData hsbcCupertinoLightTheme() {
  return const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: HSBCColors.red,
    scaffoldBackgroundColor: HSBCColors.lightGrey,
    barBackgroundColor: HSBCColors.white,
    textTheme: CupertinoTextThemeData(
      primaryColor: HSBCColors.red,
      textStyle: TextStyle(
        color: HSBCColors.black, 
        fontFamily: 'UniversNextforHSBC',
      ),
      navTitleTextStyle: TextStyle(
        color: HSBCColors.black, 
        fontWeight: FontWeight.bold, 
        fontFamily: 'UniversNextforHSBC',
      ),
      navLargeTitleTextStyle: TextStyle(
        color: HSBCColors.black, 
        fontWeight: FontWeight.bold, 
        fontSize: 30, 
        fontFamily: 'UniversNextforHSBC',
      ),
    ),
  );
}

CupertinoThemeData hsbcCupertinoDarkTheme() {
  return const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: HSBCColors.red,
    scaffoldBackgroundColor: HSBCColors.black,
    barBackgroundColor: HSBCColors.black,
    textTheme: CupertinoTextThemeData(
      primaryColor: HSBCColors.red,
      textStyle: TextStyle(
        color: HSBCColors.white, 
        fontFamily: 'UniversNextforHSBC',
      ),
      navTitleTextStyle: TextStyle(
        color: HSBCColors.white, 
        fontWeight: FontWeight.bold, 
        fontFamily: 'UniversNextforHSBC',
      ),
      navLargeTitleTextStyle: TextStyle(
        color: HSBCColors.white, 
        fontWeight: FontWeight.bold, 
        fontSize: 30, 
        fontFamily: 'UniversNextforHSBC',
      ),
    ),
  );
} 