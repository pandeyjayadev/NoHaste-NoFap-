import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 2,
      shadowColor: AppColors.shadowLight,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: AppColors.textPrimary, size: 28),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: const Text(AppStrings.appName, style: AppTextStyles.appBarTitle),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textPrimary,
            size: 28,
          ),
          onPressed: () {
            // Handle notification tap
            // You can navigate to notifications screen or show a dialog
            print('Notification tapped');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
