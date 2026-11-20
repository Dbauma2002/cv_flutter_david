import 'package:flutter/material.dart';

/// Identité graphique professionnelle commune à toute l'application.
class AppTheme {
  static const navy = Color(0xFF101B35);
  static const blue = Color(0xFF243B64);
  static const violet = Color(0xFF7055D9);
  static const background = Color(0xFFF4F6FA);
  static const text = Color(0xFF333B4F);

  static ThemeData get theme {
    final scheme = ColorScheme.fromSeed(
      seedColor: blue,
      brightness: Brightness.light,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.w800, color: navy, letterSpacing: -0.8),
        headlineMedium: TextStyle(fontWeight: FontWeight.w800, color: navy, letterSpacing: -0.5),
        titleLarge: TextStyle(fontWeight: FontWeight.w700, color: navy),
        titleMedium: TextStyle(fontWeight: FontWeight.w700, color: text),
        bodyLarge: TextStyle(color: text, height: 1.45),
        bodyMedium: TextStyle(color: text, height: 1.42),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: Color(0xFFE8ECF3)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE1E5EE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE1E5EE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: violet, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        elevation: 0,
        backgroundColor: Colors.white,
        indicatorColor: violet.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return const IconThemeData(color: violet);
          return const IconThemeData(color: Color(0xFF8A91A3));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: violet);
          }
          return const TextStyle(fontSize: 12, color: Color(0xFF8A91A3));
        }),
      ),
    );
  }
}
