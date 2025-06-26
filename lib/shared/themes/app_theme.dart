import 'package:flutter/material.dart';

class AppTheme {
  // Clean white and blue theme
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color accentBlue = Color(0xFF42A5F5);
  
  // White variations
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAFAFA);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF9E9E9E);
  
  // High contrast colors for accessibility
  static const Color highContrastDark = Color(0xFF1A1A1A);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successBlue = Color(0xFF1976D2);
  
  // Gradients
  static const LinearGradient comfortGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryBlue,
      darkBlue,
    ],
  );
  
  static const LinearGradient focusGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      lightBlue,
      primaryBlue,
    ],
  );
  
  // Legacy color aliases for compatibility
  static const Color calmBlue = lightBlue;
  static const Color excitementYellow = accentBlue;
  static const Color comfortGreen = primaryBlue;
  static const Color focusLavender = lightBlue;
  static const Color secondaryGreen = primaryBlue;
  static const Color accentOrange = accentBlue;
  static const Color softPurple = darkBlue;
  static const Color successGreen = primaryBlue;
  
  // Legacy gradient aliases
  static const LinearGradient calmGradient = comfortGradient;
  static const LinearGradient excitementGradient = focusGradient;
  
  // Font families for dyslexia support
  static const String primaryFont = 'ComicNeue';
  static const String dyslexicFont = 'OpenDyslexic';
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: MaterialColor(0xFF2196F3, _createMaterialColor(primaryBlue)),
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: pureWhite,
      
      // Color scheme for Material 3
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: lightBlue,
        tertiary: accentBlue,
        surface: pureWhite,
        background: pureWhite,
        error: errorRed,
        onPrimary: pureWhite,
        onSecondary: highContrastDark,
        onSurface: highContrastDark,
        onBackground: highContrastDark,
        onError: pureWhite,
      ),
      
      // Typography with dyslexia-friendly fonts
      textTheme: _buildTextTheme(primaryFont, highContrastDark),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: pureWhite,
          elevation: 8,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: const TextStyle(
            fontFamily: primaryFont,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Card theme for story containers
      cardTheme: CardTheme(
        elevation: 12,
        shadowColor: primaryBlue.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: pureWhite,
      ),
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: highContrastDark,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: primaryFont,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: highContrastDark,
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: const TextStyle(
          fontFamily: primaryFont,
          color: mediumGray,
        ),
      ),
      
      // Bottom navigation theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 20,
        backgroundColor: pureWhite,
        selectedItemColor: primaryBlue,
        unselectedItemColor: mediumGray,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: primaryFont,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: primaryFont,
        ),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(0xFF2196F3, _createMaterialColor(primaryBlue)),
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: highContrastDark,
      
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: lightBlue,
        tertiary: accentBlue,
        surface: Color(0xFF2A2A2A),
        background: highContrastDark,
        error: errorRed,
        onPrimary: pureWhite,
        onSecondary: highContrastDark,
        onSurface: pureWhite,
        onBackground: pureWhite,
        onError: pureWhite,
      ),
      
      textTheme: _buildTextTheme(primaryFont, pureWhite),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: pureWhite,
          elevation: 8,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: const TextStyle(
            fontFamily: primaryFont,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      cardTheme: CardTheme(
        elevation: 12,
        shadowColor: primaryBlue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: const Color(0xFF2A2A2A),
      ),
      
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: pureWhite,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: primaryFont,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: pureWhite,
        ),
      ),
    );
  }
  
  // Helper method to create MaterialColor
  static Map<int, Color> _createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;
    
    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    
    for (double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return swatch;
  }
  
  // Build text theme with dyslexia-friendly fonts
  static TextTheme _buildTextTheme(String fontFamily, Color color) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.4,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color,
        height: 1.4,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.4,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: color,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: color,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color,
        height: 1.6,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.4,
      ),
    );
  }
} 