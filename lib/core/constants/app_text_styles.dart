import 'package:flutter/material.dart';
import 'app_colors.dart'; // Add this import

class AppTextStyles {
  // App Bar
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  // Drawer Header
  static const TextStyle drawerTitle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle drawerSubtitle = TextStyle(
    color: Colors.white70,
    fontSize: 14,
  );

  // Drawer Items
  static const TextStyle drawerItem = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // Home Screen
  static const TextStyle welcomeTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle welcomeSubtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const TextStyle comingNext = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
    fontStyle: FontStyle.italic,
  );
}
