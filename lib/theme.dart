import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3e6700),
      surfaceTint: Color(0xff3f6900),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4f8200),
      onPrimaryContainer: Color(0xfff9ffea),
      secondary: Color(0xff4b662a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffcceea1),
      onSecondaryContainer: Color(0xff516d2f),
      tertiary: Color(0xff00694e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff008564),
      onTertiaryContainer: Color(0xfff5fff8),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff7fbea),
      onSurface: Color(0xff191d13),
      onSurfaceVariant: Color(0xff424937),
      outline: Color(0xff727a66),
      outlineVariant: Color(0xffc2cab2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3227),
      inversePrimary: Color(0xff97d945),
      primaryFixed: Color(0xffb2f65f),
      onPrimaryFixed: Color(0xff102000),
      primaryFixedDim: Color(0xff97d945),
      onPrimaryFixedVariant: Color(0xff2f4f00),
      secondaryFixed: Color(0xffcceea1),
      onSecondaryFixed: Color(0xff102000),
      secondaryFixedDim: Color(0xffb1d188),
      onSecondaryFixedVariant: Color(0xff344e14),
      tertiaryFixed: Color(0xff7cf9cb),
      onTertiaryFixed: Color(0xff002116),
      tertiaryFixedDim: Color(0xff5ddcb0),
      onTertiaryFixedVariant: Color(0xff00513c),
      surfaceDim: Color(0xffd8dccc),
      surfaceBright: Color(0xfff7fbea),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f5e5),
      surfaceContainer: Color(0xffecf0df),
      surfaceContainerHigh: Color(0xffe6eada),
      surfaceContainerHighest: Color(0xffe0e4d4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff233d00),
      surfaceTint: Color(0xff3f6900),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4a7a00),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff243d03),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff597637),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003f2d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff007c5d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbea),
      onSurface: Color(0xff0e1209),
      onSurfaceVariant: Color(0xff313928),
      outline: Color(0xff4e5543),
      outlineVariant: Color(0xff68705c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3227),
      inversePrimary: Color(0xff97d945),
      primaryFixed: Color(0xff4a7a00),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff395f00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff597637),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff425d21),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff007c5d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff006148),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc4c8b9),
      surfaceBright: Color(0xfff7fbea),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f5e5),
      surfaceContainer: Color(0xffe6eada),
      surfaceContainerHigh: Color(0xffdbdfce),
      surfaceContainerHighest: Color(0xffcfd3c4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1c3200),
      surfaceTint: Color(0xff3f6900),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff305200),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1c3200),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff365116),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003325),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff00543e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7fbea),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff272e1e),
      outlineVariant: Color(0xff444c3a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3227),
      inversePrimary: Color(0xff97d945),
      primaryFixed: Color(0xff305200),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff203900),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff365116),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff213901),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff00543e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003b2a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb6bbab),
      surfaceBright: Color(0xfff7fbea),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff3e2),
      surfaceContainer: Color(0xffe0e4d4),
      surfaceContainerHigh: Color(0xffd2d6c6),
      surfaceContainerHighest: Color(0xffc4c8b9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff97d945),
      surfaceTint: Color(0xff97d945),
      onPrimary: Color(0xff1f3700),
      primaryContainer: Color(0xff64a104),
      onPrimaryContainer: Color(0xff192f00),
      secondary: Color(0xffb1d188),
      onSecondary: Color(0xff1f3700),
      secondaryContainer: Color(0xff365016),
      onSecondaryContainer: Color(0xffa3c37b),
      tertiary: Color(0xff5ddcb0),
      onTertiary: Color(0xff003828),
      tertiaryContainer: Color(0xff05a47c),
      onTertiaryContainer: Color(0xff002f21),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff11150b),
      onSurface: Color(0xffe0e4d4),
      onSurfaceVariant: Color(0xffc2cab2),
      outline: Color(0xff8c947e),
      outlineVariant: Color(0xff424937),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4d4),
      inversePrimary: Color(0xff3f6900),
      primaryFixed: Color(0xffb2f65f),
      onPrimaryFixed: Color(0xff102000),
      primaryFixedDim: Color(0xff97d945),
      onPrimaryFixedVariant: Color(0xff2f4f00),
      secondaryFixed: Color(0xffcceea1),
      onSecondaryFixed: Color(0xff102000),
      secondaryFixedDim: Color(0xffb1d188),
      onSecondaryFixedVariant: Color(0xff344e14),
      tertiaryFixed: Color(0xff7cf9cb),
      onTertiaryFixed: Color(0xff002116),
      tertiaryFixedDim: Color(0xff5ddcb0),
      onTertiaryFixedVariant: Color(0xff00513c),
      surfaceDim: Color(0xff11150b),
      surfaceBright: Color(0xff363b2f),
      surfaceContainerLowest: Color(0xff0b0f07),
      surfaceContainerLow: Color(0xff191d13),
      surfaceContainer: Color(0xff1d2117),
      surfaceContainerHigh: Color(0xff272b21),
      surfaceContainerHighest: Color(0xff32362b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffacf05a),
      surfaceTint: Color(0xff97d945),
      onPrimary: Color(0xff172b00),
      primaryContainer: Color(0xff64a104),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc6e79c),
      onSecondary: Color(0xff172b00),
      secondaryContainer: Color(0xff7c9a57),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff75f3c5),
      onTertiary: Color(0xff002c1f),
      tertiaryContainer: Color(0xff05a47c),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff11150b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd8dfc7),
      outline: Color(0xffadb59e),
      outlineVariant: Color(0xff8b937e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4d4),
      inversePrimary: Color(0xff2f5100),
      primaryFixed: Color(0xffb2f65f),
      onPrimaryFixed: Color(0xff081400),
      primaryFixedDim: Color(0xff97d945),
      onPrimaryFixedVariant: Color(0xff233d00),
      secondaryFixed: Color(0xffcceea1),
      onSecondaryFixed: Color(0xff081400),
      secondaryFixedDim: Color(0xffb1d188),
      onSecondaryFixedVariant: Color(0xff243d03),
      tertiaryFixed: Color(0xff7cf9cb),
      onTertiaryFixed: Color(0xff00150d),
      tertiaryFixedDim: Color(0xff5ddcb0),
      onTertiaryFixedVariant: Color(0xff003f2d),
      surfaceDim: Color(0xff11150b),
      surfaceBright: Color(0xff42463a),
      surfaceContainerLowest: Color(0xff050803),
      surfaceContainerLow: Color(0xff1b1f15),
      surfaceContainer: Color(0xff25291f),
      surfaceContainerHigh: Color(0xff303429),
      surfaceContainerHighest: Color(0xff3b3f34),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcfff95),
      surfaceTint: Color(0xff97d945),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff93d542),
      onPrimaryContainer: Color(0xff050e00),
      secondary: Color(0xffd9fbae),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffadcd84),
      onSecondaryContainer: Color(0xff050e00),
      tertiary: Color(0xffb7ffe0),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff59d8ac),
      onTertiaryContainer: Color(0xff000e08),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff11150b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffebf3da),
      outlineVariant: Color(0xffbec6ae),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4d4),
      inversePrimary: Color(0xff2f5100),
      primaryFixed: Color(0xffb2f65f),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff97d945),
      onPrimaryFixedVariant: Color(0xff081400),
      secondaryFixed: Color(0xffcceea1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb1d188),
      onSecondaryFixedVariant: Color(0xff081400),
      tertiaryFixed: Color(0xff7cf9cb),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff5ddcb0),
      onTertiaryFixedVariant: Color(0xff00150d),
      surfaceDim: Color(0xff11150b),
      surfaceBright: Color(0xff4d5245),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1d2117),
      surfaceContainer: Color(0xff2e3227),
      surfaceContainerHigh: Color(0xff393d32),
      surfaceContainerHighest: Color(0xff44483c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
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
