import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const primary = Color(0xFF25160E);
  static const primaryContainer = Color(0xFF3C2A21);
  static const secondary = Color(0xFF615E57);
  static const secondaryContainer = Color(0xFFE7E2D9);
  static const background = Color(0xFFFCF9F8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFF6F3F2);
  static const surfaceContainer = Color(0xFFF0EDED);
  static const surfaceVariant = Color(0xFFE4E2E1);
  static const onSurface = Color(0xFF1B1C1C);
  static const onSurfaceVariant = Color(0xFF4F4540);
  static const outline = Color(0xFF81756F);
  static const outlineVariant = Color(0xFFD3C3BD);
  static const error = Color(0xFFBA1A1A);
  static const honey = Color(0xFFD4A373);

  static const pagePadding = 20.0;
  static const contentMaxWidth = 480.0;
  static const sectionGap = 32.0;
  static const itemGap = 12.0;

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: primaryContainer,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        surface: background,
        onSurface: onSurface,
        error: error,
        outline: outline,
      ),
    );

    return base.copyWith(
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: onSurface,
          letterSpacing: -0.6,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 20,
          height: 1.35,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        titleMedium: GoogleFonts.playfairDisplay(
          fontSize: 16,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          height: 1.6,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.w400,
          color: onSurface,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          height: 1.35,
          fontWeight: FontWeight.w400,
          color: onSurfaceVariant,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          height: 1,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.2,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w600,
          color: onSurface,
          letterSpacing: 0.4,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          height: 1,
          fontWeight: FontWeight.w600,
          color: onSurfaceVariant,
          letterSpacing: 0.6,
        ),
      ),
      dividerColor: surfaceVariant,
      iconTheme: const IconThemeData(color: primary, size: 22),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLow,
        hintStyle: GoogleFonts.inter(fontSize: 13, color: outline),
        prefixIconColor: outline,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: primary),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static const cardShadow = [
    BoxShadow(color: Color(0x0B000000), blurRadius: 20, offset: Offset(0, 4)),
  ];

  static const floatingShadow = [
    BoxShadow(color: Color(0x1F25160E), blurRadius: 14, offset: Offset(0, 6)),
  ];
}
