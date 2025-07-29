import 'package:flutter/material.dart';
import 'package:nohaste/core/constants/app_colors.dart';
import 'package:nohaste/core/constants/app_strings.dart';
import 'package:nohaste/screens/about/about_screen.dart';
import 'package:nohaste/screens/emergency/MotivationaL_Screen.dart';
import 'package:nohaste/screens/home/home_screen.dart';
import 'package:nohaste/screens/journal/journal_screen.dart';
import 'package:nohaste/screens/progress/Progress_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
                // Main Menu Items
                _buildDrawerItem(
                  icon: Icons.home,
                  title: AppStrings.menuHome,
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.history,
                  title: AppStrings.menuProgress,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProgressScreen()),
                    );
                    // Navigate to Progress screen
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.book,
                  title: AppStrings.menuJournal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JournalScreen(),
                      ),
                    );
                    // Navigate to Journal tab (index 2)
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.lightbulb,
                  title: AppStrings.menuQuotes,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MotivationalSection(),
                      ),
                    );
                    // Navigate to Journal tab (index 2)
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.warning,
                  title: AppStrings.menuEmergency,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                    // Navigate to Journal tab (index 2)
                  },
                ),

                // Divider
                const Divider(
                  color: AppColors.textLight,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),

                // Settings Section
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: AppStrings.menuSettings,
                  onTap: () => Navigator.pop(context),
                ),

                _buildDrawerItem(
                  icon: Icons.info,
                  title: AppStrings.menuAbout,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  ),
                ),
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
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
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
              Text(
                AppStrings.journeyTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppStrings.appTagline,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
