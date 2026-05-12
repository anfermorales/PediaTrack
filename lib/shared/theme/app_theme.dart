import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Tema refactorizado con paleta moderna y accesible
/// Compatible con modo claro y oscuro
class AppTheme {
  AppTheme._();

  // ═══════════════════════════════════════════════════════════════
  // CONFIGURACIÓN DE TIPOGRAFÍA
  // ═══════════════════════════════════════════════════════════════

  static TextTheme get _buildTextTheme {
    return TextTheme(
      displayLarge: GoogleFonts.nunito(fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25),
      displayMedium: GoogleFonts.nunito(fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w400),
      headlineLarge: GoogleFonts.nunito(fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
      titleSmall: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      bodyLarge: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
      bodyMedium: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      bodySmall: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
      labelLarge: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      labelMedium: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
      labelSmall: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // ESTILOS BASE
  // ═══════════════════════════════════════════════════════════════

  static CardThemeData get _cardTheme => const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        clipBehavior: Clip.antiAlias,
      );

  static InputDecorationTheme get _inputDecorationThemeLight => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey20,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryMid, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: GoogleFonts.nunito(color: AppColors.grey100, fontSize: 14),
        prefixIconColor: AppColors.grey100,
        suffixIconColor: AppColors.grey100,
      );

  static InputDecorationTheme get _inputDecorationThemeDark => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.darkBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.darkBorder)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkError, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: GoogleFonts.nunito(color: AppColors.darkTextTertiary, fontSize: 14),
        prefixIconColor: AppColors.darkTextSecondary,
        suffixIconColor: AppColors.darkTextSecondary,
      );

  static ElevatedButtonThemeData get _elevatedButtonThemeLight => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMid,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static ElevatedButtonThemeData get _elevatedButtonThemeDark => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.darkBackground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static FilledButtonThemeData get _filledButtonThemeLight => FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryMid,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static FilledButtonThemeData get _filledButtonThemeDark => FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.darkBackground,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonThemeLight => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryMid,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: const BorderSide(color: AppColors.primaryMid, width: 1.5),
          textStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonThemeDark => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
          textStyle: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static FloatingActionButtonThemeData get _fabThemeLight => FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryMid,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      );

  static FloatingActionButtonThemeData get _fabThemeDark => FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.darkBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      );

  static ChipThemeData get _chipThemeLight => ChipThemeData(
        backgroundColor: AppColors.grey20,
        selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.nunito(color: AppColors.grey300, fontSize: 13, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );

  static ChipThemeData get _chipThemeDark => ChipThemeData(
        backgroundColor: AppColors.darkCard,
        selectedColor: AppColors.primaryLight.withValues(alpha: 0.25),
        labelStyle: GoogleFonts.nunito(color: AppColors.darkTextSecondary, fontSize: 13, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );

  static NavigationBarThemeData get _navigationBarThemeLight => NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: AppColors.primaryLight.withValues(alpha: 0.15),
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.nunito(color: AppColors.primaryMid, fontWeight: FontWeight.w700, fontSize: 12);
          }
          return GoogleFonts.nunito(color: AppColors.grey100, fontWeight: FontWeight.w500, fontSize: 12);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryMid, size: 24);
          }
          return const IconThemeData(color: AppColors.grey100, size: 24);
        }),
      );

  static NavigationBarThemeData get _navigationBarThemeDark => NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        indicatorColor: AppColors.primaryLight.withValues(alpha: 0.2),
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.nunito(color: AppColors.primaryLight, fontWeight: FontWeight.w700, fontSize: 12);
          }
          return GoogleFonts.nunito(color: AppColors.darkTextSecondary, fontWeight: FontWeight.w500, fontSize: 12);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryLight, size: 24);
          }
          return const IconThemeData(color: AppColors.darkTextSecondary, size: 24);
        }),
      );

  static DividerThemeData get _dividerThemeLight => const DividerThemeData(
        color: AppColors.grey30,
        thickness: 1,
        space: 1,
      );

  static DividerThemeData get _dividerThemeDark => const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      );

  static BottomSheetThemeData get _bottomSheetThemeLight => BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        elevation: 8,
      );

  static BottomSheetThemeData get _bottomSheetThemeDark => BottomSheetThemeData(
        backgroundColor: AppColors.darkCard,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        elevation: 8,
      );

  static DialogThemeData get _dialogThemeLight => DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
      );

  static DialogThemeData get _dialogThemeDark => DialogThemeData(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
      );

  // ═══════════════════════════════════════════════════════════════
  // TEMA CLARO
  // ═══════════════════════════════════════════════════════════════

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryMid,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primarySurface,
        onPrimaryContainer: AppColors.primaryDeep,
        secondary: AppColors.secondaryMid,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondarySurface,
        onSecondaryContainer: AppColors.secondaryDeep,
        tertiary: AppColors.accentMid,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.accentSurface,
        onTertiaryContainer: AppColors.accentDeep,
        surface: Colors.white,
        onSurface: AppColors.grey500,
        surfaceContainerHighest: AppColors.grey20,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.errorDark,
        outline: AppColors.grey50,
        outlineVariant: AppColors.grey30,
      ),
      scaffoldBackgroundColor: AppColors.grey10,
      textTheme: _buildTextTheme.apply(bodyColor: AppColors.grey500, displayColor: AppColors.grey500),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.grey500,
        titleTextStyle: GoogleFonts.nunito(color: AppColors.grey500, fontSize: 18, fontWeight: FontWeight.w700),
        iconTheme: const IconThemeData(color: AppColors.grey500),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: _cardTheme.copyWith(color: Colors.white),
      inputDecorationTheme: _inputDecorationThemeLight,
      elevatedButtonTheme: _elevatedButtonThemeLight,
      outlinedButtonTheme: _outlinedButtonThemeLight,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryMid,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: _filledButtonThemeLight,
      floatingActionButtonTheme: _fabThemeLight,
      chipTheme: _chipThemeLight,
      navigationBarTheme: _navigationBarThemeLight,
      dividerTheme: _dividerThemeLight,
      bottomSheetTheme: _bottomSheetThemeLight,
      dialogTheme: _dialogThemeLight,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey500,
        contentTextStyle: GoogleFonts.nunito(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // TEMA OSCURO - Optimizado para máxima legibilidad
  // ═══════════════════════════════════════════════════════════════

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.darkBackground,
        primaryContainer: AppColors.primaryDeep,
        onPrimaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.darkBackground,
        secondaryContainer: AppColors.secondaryDeep,
        onSecondaryContainer: AppColors.secondaryLight,
        tertiary: AppColors.accentLight,
        onTertiary: AppColors.darkBackground,
        tertiaryContainer: AppColors.accentDeep,
        onTertiaryContainer: AppColors.accentLight,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkCard,
        error: AppColors.darkError,
        onError: AppColors.darkBackground,
        errorContainer: AppColors.errorDark,
        onErrorContainer: AppColors.darkError,
        outline: AppColors.darkBorder,
        outlineVariant: AppColors.darkBorderLight,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      // Texto principal en blanco puro para máxima legibilidad de valores
      textTheme: _buildTextTheme.apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        titleTextStyle: GoogleFonts.nunito(color: AppColors.darkTextPrimary, fontSize: 18, fontWeight: FontWeight.w700),
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: _cardTheme.copyWith(color: AppColors.darkCard),
      inputDecorationTheme: _inputDecorationThemeDark,
      elevatedButtonTheme: _elevatedButtonThemeDark,
      outlinedButtonTheme: _outlinedButtonThemeDark,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: _filledButtonThemeDark,
      floatingActionButtonTheme: _fabThemeDark,
      chipTheme: _chipThemeDark,
      navigationBarTheme: _navigationBarThemeDark,
      dividerTheme: _dividerThemeDark,
      bottomSheetTheme: _bottomSheetThemeDark,
      dialogTheme: _dialogThemeDark,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkCardElevated,
        contentTextStyle: GoogleFonts.nunito(color: AppColors.darkTextPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}