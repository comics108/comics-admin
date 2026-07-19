import 'package:flutter/material.dart';

/// VPN Client Pro Design System Colors
class AppColors {
  AppColors._();

  // Primary (gradient endpoints)
  static const primary = Color(0xFF00C6FB);
  static const primaryDark = Color(0xFF005BEA);

  // Gradient for primary actions
  static const gradientStart = Color(0xFF00C6FB);
  static const gradientEnd = Color(0xFF005BEA);
  static const primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Backgrounds
  static const background = Color(0xFFF8F9FA);
  static const surface = Color(0xFFFFFFFF);
  static const sidebar = Color(0xFFFFFFFF);

  // Text
  static const textPrimary = Color(0xFF303F49);
  static const textSecondary = Color(0xFF5C6771);

  // Borders (hairline)
  static const border = Color(0x1A9CB2C2); // rgba(156,178,194,0.1)
  static const inputBorder = Color(0xFFDCE4E8);

  // Header / Title bar
  static const titleBar = Color(0xFFF8F9FA);
  static const titleBarBorder = Color(0xFFE8ECF0);

  // Status colors
  static const error = Color(0xFFE53935);
  static const success = Color(0xFF43A047);
  static const warning = Color(0xFFFB8C00);

  // Table
  static const tableHeader = Color(0xFFF8F9FA);
  static const tableRowAlt = Color(0xFFFCFCFD);

  // Shadows
  static const cardShadow = Color(0x0A000000);
}
