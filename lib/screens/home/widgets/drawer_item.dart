import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart'; // Add this import
import '../../../core/constants/app_text_styles.dart';
import '../../../models/menu_item.dart';

class DrawerItem extends StatelessWidget {
  final MenuItem menuItem;

  const DrawerItem({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(menuItem.icon, color: AppColors.textPrimary, size: 24),
      title: Text(menuItem.title, style: AppTextStyles.drawerItem),
      onTap: menuItem.onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
