import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF42A5F5);
  static const _secondaryColor = Color(0xFF66BB6A);
  static const _accentColor = Color(0xFFFFCA28);
  static const _backgroundColor = Color(0xFFF5FAFF);
  static const _surfaceColor = Color(0xFFFFFFFF);
  static const _textPrimary = Color(0xFF263238);
  static const _textSecondary = Color(0xFF607D8B);
  static const _errorColor = Color(0xFFEF5350);

  static const _healthyColor = Color(0xFF66BB6A);
  static const _alertColor = Color(0xFFEF5350);
  static const _vaccinePendingColor = Color(0xFFFFCA28);
  static const _appointmentColor = Color(0xFF42A5F5);
  static const _growthExcellentColor = Color(0xFF66BB6A);

  static Color get healthyColor => _healthyColor;
  static Color get alertColor => _alertColor;
  static Color get vaccinePendingColor => _vaccinePendingColor;
  static Color get appointmentColor => _appointmentColor;
  static Color get growthExcellentColor => _growthExcellentColor;

  static TextTheme _buildTextTheme(Color textColor, Color secondaryTextColor) {
    return TextTheme(
      displayLarge: GoogleFonts.nunito(color: textColor),
      displayMedium: GoogleFonts.nunito(color: textColor),
      displaySmall: GoogleFonts.nunito(color: textColor),
      headlineLarge: GoogleFonts.nunito(color: textColor, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.nunito(color: textColor, fontWeight: FontWeight.bold),
      headlineSmall: GoogleFonts.nunito(color: textColor, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.nunito(color: textColor, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.nunito(color: textColor, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.nunito(color: textColor, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.nunito(color: textColor),
      bodyMedium: GoogleFonts.nunito(color: textColor),
      bodySmall: GoogleFonts.nunito(color: secondaryTextColor),
      labelLarge: GoogleFonts.nunito(color: textColor, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.nunito(color: secondaryTextColor),
      labelSmall: GoogleFonts.nunito(color: textColor, fontWeight: FontWeight.w500),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _accentColor,
        surface: _surfaceColor,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _textPrimary,
        onError: Colors.white,
        primaryContainer: const Color(0xFFE3F2FD),
        onPrimaryContainer: _textPrimary,
      ),
      scaffoldBackgroundColor: _backgroundColor,
      textTheme: _buildTextTheme(_textPrimary, _textSecondary),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _surfaceColor,
        foregroundColor: _textPrimary,
        titleTextStyle: GoogleFonts.nunito(
          color: _textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: _surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _primaryColor.withOpacity(0.15)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: _primaryColor.withOpacity(0.5)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _backgroundColor,
        selectedColor: _primaryColor.withOpacity(0.15),
        labelStyle: GoogleFonts.nunito(color: _textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _surfaceColor,
        indicatorColor: _primaryColor.withOpacity(0.15),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.nunito(
              color: _primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return GoogleFonts.nunito(
            color: _textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _primaryColor, size: 24);
          }
          return const IconThemeData(color: _textSecondary, size: 24);
        }),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade100,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    const darkSurface = Color(0xFF1E2A32);
    const darkBackground = Color(0xFF141C24);
    const darkCard = Color(0xFF1E2A32);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _accentColor,
        surface: darkSurface,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
        primaryContainer: const Color(0xFF1565C0),
        onPrimaryContainer: Colors.white,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: _buildTextTheme(Colors.white, Colors.grey.shade400),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: _primaryColor.withOpacity(0.5)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: _primaryColor.withOpacity(0.25),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.nunito(
              color: _primaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return GoogleFonts.nunito(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _primaryColor, size: 24);
          }
          return IconThemeData(color: Colors.grey.shade400, size: 24);
        }),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade800,
        thickness: 1,
        space: 1,
      ),
    );
  }
}