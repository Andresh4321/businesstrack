import 'package:flutter/material.dart';

/// Helper class for responsive design across mobile and tablet devices
class ResponsiveHelper {
  ResponsiveHelper._();

  // Breakpoint constants
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 900;
  static const double desktopMinWidth = 900;

  /// Check if the current device is a mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMaxWidth;

  /// Check if the current device is a tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < desktopMinWidth;
  }

  /// Check if the current device is desktop or larger tablet
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopMinWidth;

  /// Get appropriate grid cross axis count based on screen size
  static int getGridCrossAxisCount(
    BuildContext context, {
    int mobile = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// Get appropriate horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 32.0;
    if (isTablet(context)) return 24.0;
    return 16.0;
  }

  /// Get appropriate vertical padding based on screen size
  static double getVerticalPadding(BuildContext context) {
    if (isDesktop(context)) return 24.0;
    if (isTablet(context)) return 20.0;
    return 16.0;
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile * 1.2;
    if (isTablet(context)) return tablet ?? mobile * 1.1;
    return mobile;
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(
    BuildContext context, {
    double mobile = 24.0,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile * 1.3;
    if (isTablet(context)) return tablet ?? mobile * 1.15;
    return mobile;
  }

  /// Get responsive card elevation
  static double getCardElevation(BuildContext context) {
    if (isTablet(context) || isDesktop(context)) return 3.0;
    return 2.0;
  }

  /// Get responsive spacing
  static double getSpacing(
    BuildContext context, {
    double mobile = 8.0,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile * 1.5;
    if (isTablet(context)) return tablet ?? mobile * 1.25;
    return mobile;
  }

  /// Get responsive card aspect ratio
  static double getCardAspectRatio(BuildContext context) {
    if (isTablet(context) || isDesktop(context)) return 1.0;
    return 0.85;
  }

  /// Get responsive max width for content
  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 1200;
    return width;
  }

  /// Get responsive list tile padding
  static EdgeInsets getListTilePadding(BuildContext context) {
    final horizontal = getHorizontalPadding(context);
    final vertical = getVerticalPadding(context) / 2;
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  /// Get responsive button height
  static double getButtonHeight(BuildContext context) {
    if (isTablet(context) || isDesktop(context)) return 52.0;
    return 48.0;
  }

  /// Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    if (isTablet(context) || isDesktop(context)) return 64.0;
    return 56.0;
  }

  /// Responsive value selector
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }

  /// Get screen width
  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Get screen height
  static double getScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  /// Get responsive dialog max width
  static double getDialogMaxWidth(BuildContext context) {
    if (isDesktop(context)) return 600;
    if (isTablet(context)) return 500;
    return MediaQuery.of(context).size.width * 0.9;
  }

  /// Get responsive grid spacing
  static double getGridSpacing(BuildContext context) {
    if (isTablet(context) || isDesktop(context)) return 16.0;
    return 12.0;
  }
}

/// Widget wrapper for building responsive layouts
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return desktop?.call(context) ?? tablet?.call(context) ?? mobile(context);
    }
    if (ResponsiveHelper.isTablet(context)) {
      return tablet?.call(context) ?? mobile(context);
    }
    return mobile(context);
  }
}
