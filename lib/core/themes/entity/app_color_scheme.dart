import 'package:flutter/material.dart';

class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Brightness? brightness;
  final Color? primary;
  final Color? onPrimary;
  final Color? primaryContainer;
  final Color? onPrimaryContainer;
  final Color? primaryFixed;
  final Color? primaryFixedDim;
  final Color? onPrimaryFixed;
  final Color? onPrimaryFixedVariant;
  final Color? secondary;
  final Color? onSecondary;
  final Color? secondaryContainer;
  final Color? onSecondaryContainer;
  final Color? secondaryFixed;
  final Color? secondaryFixedDim;
  final Color? onSecondaryFixed;
  final Color? onSecondaryFixedVariant;
  final Color? tertiary;
  final Color? onTertiary;
  final Color? tertiaryContainer;
  final Color? onTertiaryContainer;
  final Color? tertiaryFixed;
  final Color? tertiaryFixedDim;
  final Color? onTertiaryFixed;
  final Color? onTertiaryFixedVariant;
  final Color? error;
  final Color? onError;
  final Color? errorContainer;
  final Color? onErrorContainer;
  final Color? surface;
  final Color? onSurface;
  final Color? surfaceDim;
  final Color? surfaceBright;
  final Color? surfaceContainerLowest;
  final Color? surfaceContainerLow;
  final Color? surfaceContainer;
  final Color? surfaceContainerHigh;
  final Color? surfaceContainerHighest;
  final Color? onSurfaceVariant;
  final Color? outline;
  final Color? outlineVariant;
  final Color? shadow;
  final Color? scrim;
  final Color? inverseSurface;
  final Color? onInverseSurface;
  final Color? inversePrimary;
  final Color? surfaceTint;

  const AppColorScheme({
    this.brightness,
    this.primary,
    this.onPrimary,
    this.primaryContainer,
    this.onPrimaryContainer,
    this.primaryFixed,
    this.primaryFixedDim,
    this.onPrimaryFixed,
    this.onPrimaryFixedVariant,
    this.secondary,
    this.onSecondary,
    this.secondaryContainer,
    this.onSecondaryContainer,
    this.secondaryFixed,
    this.secondaryFixedDim,
    this.onSecondaryFixed,
    this.onSecondaryFixedVariant,
    this.tertiary,
    this.onTertiary,
    this.tertiaryContainer,
    this.onTertiaryContainer,
    this.tertiaryFixed,
    this.tertiaryFixedDim,
    this.onTertiaryFixed,
    this.onTertiaryFixedVariant,
    this.error,
    this.onError,
    this.errorContainer,
    this.onErrorContainer,
    this.surface,
    this.onSurface,
    this.surfaceDim,
    this.surfaceBright,
    this.surfaceContainerLowest,
    this.surfaceContainerLow,
    this.surfaceContainer,
    this.surfaceContainerHigh,
    this.surfaceContainerHighest,
    this.onSurfaceVariant,
    this.outline,
    this.outlineVariant,
    this.shadow,
    this.scrim,
    this.inverseSurface,
    this.onInverseSurface,
    this.inversePrimary,
    this.surfaceTint,
  });

  @override
  ThemeExtension<AppColorScheme> copyWith({
    Brightness? brightness,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? surface,
    Color? onSurface,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
  }) {
    return AppColorScheme(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      primaryFixed: primaryFixed ?? this.primaryFixed,
      primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      onPrimaryFixedVariant:
          onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      secondaryFixed: secondaryFixed ?? this.secondaryFixed,
      secondaryFixedDim: secondaryFixedDim ?? this.secondaryFixedDim,
      onSecondaryFixed: onSecondaryFixed ?? this.onSecondaryFixed,
      onSecondaryFixedVariant:
          onSecondaryFixedVariant ?? this.onSecondaryFixedVariant,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      tertiaryFixed: tertiaryFixed ?? this.tertiaryFixed,
      tertiaryFixedDim: tertiaryFixedDim ?? this.tertiaryFixedDim,
      onTertiaryFixed: onTertiaryFixed ?? this.onTertiaryFixed,
      onTertiaryFixedVariant:
          onTertiaryFixedVariant ?? this.onTertiaryFixedVariant,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      surfaceTint: surfaceTint ?? this.surfaceTint,
    );
  }

  @override
  ThemeExtension<AppColorScheme> lerp(
    ThemeExtension<AppColorScheme>? other,
    double t,
  ) {
    if (other is! AppColorScheme) {
      return this;
    }

    return AppColorScheme(
      brightness: brightness,
      primary: Color.lerp(primary, other.primary, t),
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t),
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t),
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      ),
      primaryFixed: Color.lerp(primaryFixed, other.primaryFixed, t),
      primaryFixedDim: Color.lerp(primaryFixedDim, other.primaryFixedDim, t),
      onPrimaryFixed: Color.lerp(onPrimaryFixed, other.onPrimaryFixed, t),
      onPrimaryFixedVariant: Color.lerp(
        onPrimaryFixedVariant,
        other.onPrimaryFixedVariant,
        t,
      ),
      secondary: Color.lerp(secondary, other.secondary, t),
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t),
      secondaryContainer: Color.lerp(
        secondaryContainer,
        other.secondaryContainer,
        t,
      ),
      onSecondaryContainer: Color.lerp(
        onSecondaryContainer,
        other.onSecondaryContainer,
        t,
      ),
      secondaryFixed: Color.lerp(secondaryFixed, other.secondaryFixed, t),
      secondaryFixedDim: Color.lerp(
        secondaryFixedDim,
        other.secondaryFixedDim,
        t,
      ),
      onSecondaryFixed: Color.lerp(onSecondaryFixed, other.onSecondaryFixed, t),
      onSecondaryFixedVariant: Color.lerp(
        onSecondaryFixedVariant,
        other.onSecondaryFixedVariant,
        t,
      ),
      tertiary: Color.lerp(tertiary, other.tertiary, t),
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t),
      tertiaryContainer: Color.lerp(
        tertiaryContainer,
        other.tertiaryContainer,
        t,
      ),
      onTertiaryContainer: Color.lerp(
        onTertiaryContainer,
        other.onTertiaryContainer,
        t,
      ),
      tertiaryFixed: Color.lerp(tertiaryFixed, other.tertiaryFixed, t),
      tertiaryFixedDim: Color.lerp(tertiaryFixedDim, other.tertiaryFixedDim, t),
      onTertiaryFixed: Color.lerp(onTertiaryFixed, other.onTertiaryFixed, t),
      onTertiaryFixedVariant: Color.lerp(
        onTertiaryFixedVariant,
        other.onTertiaryFixedVariant,
        t,
      ),
      error: Color.lerp(error, other.error, t),
      onError: Color.lerp(onError, other.onError, t),
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t),
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t),
      surface: Color.lerp(surface, other.surface, t),
      onSurface: Color.lerp(onSurface, other.onSurface, t),
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t),
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t),
      surfaceContainerLowest: Color.lerp(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
        t,
      ),
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      ),
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t),
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      ),
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      ),
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t),
      outline: Color.lerp(outline, other.outline, t),
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t),
      shadow: Color.lerp(shadow, other.shadow, t),
      scrim: Color.lerp(scrim, other.scrim, t),
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t),
      onInverseSurface: Color.lerp(onInverseSurface, other.onInverseSurface, t),
      inversePrimary: Color.lerp(inversePrimary, other.inversePrimary, t),
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t),
    );
  }
}
