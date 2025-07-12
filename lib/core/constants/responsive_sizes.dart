import 'package:flutter/material.dart';

class ResponsiveFontSize {
  static double getFontSize(BuildContext context, {required double baseFontSize}) =>
      baseFontSize * _getScaleFactor(context);

  /// Returns scaled padding (or margins) based on the screen width.
  static EdgeInsets getPadding(BuildContext context, {required EdgeInsets basePadding}) {
    final double scale = _getScaleFactor(context);
    return basePadding * scale;
  }

  /// Returns a scaled width based on the screen width.
  static double getWidth(BuildContext context, {required double baseWidth}) {
    final double scale = _getScaleFactor(context);
    return baseWidth * scale;
  }

  /// Returns a scaled height based on the screen width.
  static double getHeight(BuildContext context, {required double baseHeight}) {
    final double scale = _getScaleFactor(context);
    return baseHeight * scale;
  }

  /// Helper method to get the scale factor based on screen width.
  static double _getScaleFactor(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 250 && screenWidth <= 639) {
      // Mobile: 250px–639px
      return 0.8; // 80% of base size
    } else if (screenWidth >= 640 && screenWidth <= 1023) {
      // Tablet: 640px–1023px
      return 1.0; // 100% of base size
    } else if (screenWidth >= 1024 && screenWidth <= 1280) {
      // Large Desktop: 1024px–1280px
      return 1.2; // 120% of base size
    } else if (screenWidth >= 1281 && screenWidth <= 1536) {
      // Extra Large Desktop: 1281px–1536px
      return 1.4; // 140% of base size
    } else if (screenWidth >= 1537 && screenWidth <= 2559) {
      // 2XL Desktop: 1537px–2559px
      return 1.6; // 160% of base size
    } else {
      // Default for any other size (e.g., very large screens)
      return 1.8;
    }
  }
}
