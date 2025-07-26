import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/menu_item.dart';
import '../../progress/Progress_screen.dart'; // Add this import
import 'drawer_item.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ..._buildMenuItems(context),
                const Divider(),
                ..._buildSettingsItems(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.drawerHeaderStart, AppColors.drawerHeaderEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.surface,
                child: Icon(Icons.person, size: 40, color: AppColors.primary),
              ),
              SizedBox(height: 16),
              Text(AppStrings.journeyTitle, style: AppTextStyles.drawerTitle),
              Text(AppStrings.appTagline, style: AppTextStyles.drawerSubtitle),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    final menuItems = [
      MenuItem(
        icon: Icons.home,
        title: AppStrings.menuHome,
        onTap: () => Navigator.pop(context),
      ),
      MenuItem(
        icon: Icons.timeline,
        title: AppStrings.menuProgress,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProgressScreen()),
          );
        },
      ),
      MenuItem(
        icon: Icons.emoji_events,
        title: AppStrings.menuAchievements,
        onTap: () => Navigator.pop(context),
      ),
      MenuItem(
        icon: Icons.book,
        title: AppStrings.menuJournal,
        onTap: () => Navigator.pop(context),
      ),
      MenuItem(
        icon: Icons.lightbulb,
        title: AppStrings.menuQuotes,
        onTap: () => Navigator.pop(context),
      ),
      MenuItem(
        icon: Icons.warning,
        title: AppStrings.menuEmergency,
        onTap: () => Navigator.pop(context),
      ),
    ];

    return menuItems.map((item) => DrawerItem(menuItem: item)).toList();
  }

  List<Widget> _buildSettingsItems(BuildContext context) {
    final settingsItems = [
      MenuItem(
        icon: Icons.settings,
        title: AppStrings.menuSettings,
        onTap: () => Navigator.pop(context),
      ),
      MenuItem(
        icon: Icons.info,
        title: AppStrings.menuAbout,
        onTap: () => Navigator.pop(context),
      ),
    ];

    return settingsItems.map((item) => DrawerItem(menuItem: item)).toList();
  }
}
