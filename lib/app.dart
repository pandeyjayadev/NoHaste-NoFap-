import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart'; // Add this import

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        elevation: 2,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        //shadowColor: AppColors.shadowLight,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: AppColors.surface),
    );
  }
}
