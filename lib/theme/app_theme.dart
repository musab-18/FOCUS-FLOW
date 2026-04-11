import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const deepCoral = Color(0xFFFF5A5F);
  static const coralLight = Color(0xFFFF8A8E);
  static const coralDark = Color(0xFFD94247);
  static const slateGrey = Color(0xFF4A5568);
  static const slateLight = Color(0xFFEDF2F7);
  static const slateDark = Color(0xFF2D3748);
  static const white = Colors.white;
  static const black = Color(0xFF1A202C);
  static const success = Color(0xFF48BB78);
  static const warning = Color(0xFFECC94B);
  static const info = Color(0xFF4299E1);
  static const purple = Color(0xFF9F7AEA);
  static const teal = Color(0xFF38B2AC);
  static const orange = Color(0xFFED8936);

  // Priority colors
  static const highPriority = Color(0xFFFF5A5F);
  static const mediumPriority = Color(0xFFECC94B);
  static const lowPriority = Color(0xFF48BB78);

  // Dark mode surfaces
  static const darkBackground = Color(0xFF111827);
  static const darkSurface = Color(0xFF1F2937);
  static const darkCard = Color(0xFF374151);
}

class AppTheme {
  static ThemeData getLight(Color primaryColor) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: AppColors.slateGrey,
        surface: AppColors.white,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF7FAFC),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: AppColors.slateGrey.withOpacity(0.1),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.slateDark),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.slateDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: _textTheme(AppColors.slateDark),
      inputDecorationTheme: _inputTheme(Brightness.light, primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle(primaryColor)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: AppColors.slateGrey,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.slateLight,
        selectedColor: primaryColor.withOpacity(0.2),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE2E8F0),
        thickness: 1,
      ),
    );
  }

  static ThemeData getDark(Color primaryColor) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryColor,
        secondary: primaryColor.withOpacity(0.8),
        surface: AppColors.darkSurface,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: _textTheme(AppColors.white),
      inputDecorationTheme: _inputTheme(Brightness.dark, primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle(primaryColor)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFF6B7280),
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkCard,
        selectedColor: primaryColor.withOpacity(0.3),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF374151),
        thickness: 1,
      ),
    );
  }

  static TextTheme _textTheme(Color base) {
    return TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.w700, color: base),
      displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.w700, color: base),
      displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w600, color: base),
      headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, color: base),
      headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: base),
      headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: base),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: base),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: base),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: base),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: base),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: base),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: base.withOpacity(0.7)),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: base),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: base),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: base.withOpacity(0.7)),
    );
  }

  static InputDecorationTheme _inputTheme(Brightness brightness, Color primaryColor) {
    final isDark = brightness == Brightness.dark;
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkCard : AppColors.slateLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkCard : const Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2), 
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(
        color: isDark ? const Color(0xFF6B7280) : const Color(0xFFA0AEC0),
        fontSize: 14,
      ),
    );
  }

  static ButtonStyle _buttonStyle(Color primaryColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }
}
