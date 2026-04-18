import 'package:flutter/material.dart';

class AppTheme {
  static const Color _bgLight      = Color.fromARGB(253, 247, 222, 210);
  static const Color _bgDark       = Color(0xFF1A110D);
  static const Color _headingLight = Color.fromARGB(252, 95, 31, 2);
  static const Color _headingDark  = Color(0xFFFBE1D6);
  static const Color _primary      = Color(0xFFEF8757);
  static const Color _primaryLight1 = Color(0xFFF2A07A);
  static const Color _primaryLight3 = Color(0xFFFBE1D6);
  static const Color _grey300      = Color(0xFFD1D5DB);
  static const Color _grey500      = Color(0xFF6B7280);
  static const Color error         = Color(0xFFEF4444);

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _bgLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
    ).copyWith(
      surface: _bgLight,           // covers background + cards + bottom sheets
      onSurface: _headingLight,    // text/icons on top of surface
      error: error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(color: _headingLight, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: _headingLight),
      bodySmall: TextStyle(color: _grey500),
    ),
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _bgDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: _primaryLight1,
      surface: _bgDark,            // covers background
      onSurface: _headingDark,     // text/icons on top of surface
      error: error,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF2C1A12),
      foregroundColor: _headingDark,
      elevation: 0,
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(color: _headingDark, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: _headingDark),
      bodySmall: TextStyle(color: _grey300),
    ),
  );
}


/*


primary       → your main brand color (buttons, FAB, active states)
onPrimary     → text/icons ON primary colored things

surface       → backgrounds, cards, screens
onSurface     → text/icons ON surface colored things

primaryContainer     → softer/muted version of primary (chips, selected states)
onPrimaryContainer   → text ON primaryContainer

outline       → borders and dividers
error         → error states


These exist but you didn't define them — Flutter generated them from your seed. The full list of named roles in Material 3:

// Primary family
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.onPrimary
Theme.of(context).colorScheme.primaryContainer      // muted version of primary
Theme.of(context).colorScheme.onPrimaryContainer

// Secondary family (Flutter chose this from your seed)
Theme.of(context).colorScheme.secondary
Theme.of(context).colorScheme.onSecondary
Theme.of(context).colorScheme.secondaryContainer
Theme.of(context).colorScheme.onSecondaryContainer

// Tertiary family
Theme.of(context).colorScheme.tertiary
Theme.of(context).colorScheme.onTertiary
Theme.of(context).colorScheme.tertiaryContainer
Theme.of(context).colorScheme.onTertiaryContainer

// Surface family
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.onSurface
Theme.of(context).colorScheme.surfaceContainerHighest  // slightly elevated surfaces
Theme.of(context).colorScheme.surfaceContainerHigh
Theme.of(context).colorScheme.surfaceContainer
Theme.of(context).colorScheme.surfaceContainerLow
Theme.of(context).colorScheme.surfaceContainerLowest

// Outline
Theme.of(context).colorScheme.outline          // borders, dividers
Theme.of(context).colorScheme.outlineVariant   // subtle borders

// Error family
Theme.of(context).colorScheme.error
Theme.of(context).colorScheme.onError

 */