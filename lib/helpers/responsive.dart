import 'package:flutter/material.dart';

/// Breakpoints pour différentes tailles d'écran
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Classe utilitaire pour le design responsive
class Responsive {
  final BuildContext context;
  final MediaQueryData mediaQuery;

  Responsive(this.context) : mediaQuery = MediaQuery.of(context);

  /// Largeur de l'écran
  double get width => mediaQuery.size.width;

  /// Hauteur de l'écran
  double get height => mediaQuery.size.height;

  /// Orientation
  Orientation get orientation => mediaQuery.orientation;

  /// Est-ce un téléphone ?
  bool get isMobile => width < Breakpoints.mobile;

  /// Est-ce une tablette ?
  bool get isTablet => width >= Breakpoints.mobile && width < Breakpoints.tablet;

  /// Est-ce un desktop ?
  bool get isDesktop => width >= Breakpoints.tablet;

  /// Est-ce un petit téléphone ?
  bool get isSmallMobile => width < 360;

  /// Est-ce un grand téléphone ?
  bool get isLargeMobile => width >= 360 && width < Breakpoints.mobile;

  /// Retourne une valeur adaptée selon la taille d'écran
  T value<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Retourne un double adapté selon la taille d'écran
  double adaptive({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Retourne un EdgeInsets adapté selon la taille d'écran
  EdgeInsets padding({
    required EdgeInsets mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Retourne un int adapté selon la taille d'écran (pour GridView crossAxisCount)
  int columns({
    required int mobile,
    int? tablet,
    int? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Retourne un double pour la taille de police adaptée
  double fontSize({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Retourne un double pour l'espacement adapté
  double spacing({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}

/// Extension pour accéder facilement à Responsive depuis BuildContext
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
}

/// Widget helper pour obtenir des valeurs responsive
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Responsive responsive) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, Responsive(context));
  }
}

