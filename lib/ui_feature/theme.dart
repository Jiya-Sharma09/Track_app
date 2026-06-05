import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4355b9),
      surfaceTint: Color(0xff4355b9),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdee0ff),
      onPrimaryContainer: Color(0xff00105c),
      secondary: Color(0xff5b5d72),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe0e1f9),
      onSecondaryContainer: Color(0xff181a2c),
      tertiary: Color(0xff77536d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd7f1),
      onTertiaryContainer: Color(0xff2d1228),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffbf8ff),
      onSurface: Color(0xff1b1b1f),
      onSurfaceVariant: Color(0xff46464f),
      outline: Color(0xff767680),
      outlineVariant: Color(0xffc7c5d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303034),
      inversePrimary: Color(0xffbac3ff),
      primaryFixed: Color(0xffdee0ff),
      onPrimaryFixed: Color(0xff00105c),
      primaryFixedDim: Color(0xffbac3ff),
      onPrimaryFixedVariant: Color(0xff2a3c9e),
      secondaryFixed: Color(0xffe0e1f9),
      onSecondaryFixed: Color(0xff181a2c),
      secondaryFixedDim: Color(0xffc3c5dd),
      onSecondaryFixedVariant: Color(0xff434659),
      tertiaryFixed: Color(0xffffd7f1),
      onTertiaryFixed: Color(0xff2d1228),
      tertiaryFixedDim: Color(0xffe6b8d7),
      onTertiaryFixedVariant: Color(0xff5d3c55),
      surfaceDim: Color(0xffdbd9e0),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f2f9),
      surfaceContainer: Color(0xffefedf4),
      surfaceContainerHigh: Color(0xffe9e7ef),
      surfaceContainerHighest: Color(0xffe4e1e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff263799),
      surfaceTint: Color(0xff4355b9),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5a6ccf),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3f4155),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff717389),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff593851),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8f6984),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffbf8ff),
      onSurface: Color(0xff1b1b1f),
      onSurfaceVariant: Color(0xff42424b),
      outline: Color(0xff5e5e67),
      outlineVariant: Color(0xff7a7983),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303034),
      inversePrimary: Color(0xffbac3ff),
      primaryFixed: Color(0xff5a6ccf),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3f52b6),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff717389),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff585a6f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8f6984),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff74516a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdbd9e0),
      surfaceBright: Color(0xfffbf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f2f9),
      surfaceContainer: Color(0xffefedf4),
      surfaceContainerHigh: Color(0xffe9e7ef),
      surfaceContainerHighest: Color(0xffe4e1e9),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbac3ff),
      surfaceTint: Color(0xffbac3ff),
      onPrimary: Color(0xff08218a),
      primaryContainer: Color(0xff2a3c9e),
      onPrimaryContainer: Color(0xffdee0ff),
      secondary: Color(0xffc3c5dd),
      onSecondary: Color(0xff2d2f42),
      secondaryContainer: Color(0xff434659),
      onSecondaryContainer: Color(0xffe0e1f9),
      tertiary: Color(0xffe6b8d7),
      onTertiary: Color(0xff44263e),
      tertiaryContainer: Color(0xff5d3c55),
      onTertiaryContainer: Color(0xffffd7f1),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      // ── Deep blue-purple surfaces (Option A) ─────────────────────
      surface: Color(0xff0f1128),
      onSurface: Color(0xffe4e1ff),
      onSurfaceVariant: Color(0xffc7c5e0),
      outline: Color(0xff9090b0),
      outlineVariant: Color(0xff3a3a5c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1e9),
      inversePrimary: Color(0xff4355b9),
      primaryFixed: Color(0xffdee0ff),
      onPrimaryFixed: Color(0xff00105c),
      primaryFixedDim: Color(0xffbac3ff),
      onPrimaryFixedVariant: Color(0xff2a3c9e),
      secondaryFixed: Color(0xffe0e1f9),
      onSecondaryFixed: Color(0xff181a2c),
      secondaryFixedDim: Color(0xffc3c5dd),
      onSecondaryFixedVariant: Color(0xff434659),
      tertiaryFixed: Color(0xffffd7f1),
      onTertiaryFixed: Color(0xff2d1228),
      tertiaryFixedDim: Color(0xffe6b8d7),
      onTertiaryFixedVariant: Color(0xff5d3c55),
      surfaceDim: Color(0xff0f1128),
      surfaceBright: Color(0xff2e3060),
      surfaceContainerLowest: Color(0xff090b1e),
      surfaceContainerLow: Color(0xff13163a),
      surfaceContainer: Color(0xff181b40),
      surfaceContainerHigh: Color(0xff1f2248),
      surfaceContainerHighest: Color(0xff272a52),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}