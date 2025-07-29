import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nohaste/screens/home/widgets/home_app_bar.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'screens/home/widgets/streak_counter.dart';
import 'screens/progress/Progress_screen.dart';
import 'screens/journal/journal_screen.dart';
import 'screens/emergency/MotivationaL_Screen.dart';
import 'screens/home/widgets/app_drawer.dart';

void main() {
  runApp(const NoHasteApp());
}

class NoHasteApp extends StatelessWidget {
  const NoHasteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoHaste',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      home: const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ProgressScreen(),
    const JournalScreen(),
    const MotivationalSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: GNav(
              rippleColor: AppColors.primary.withOpacity(0.1),
              hoverColor: AppColors.primary.withOpacity(0.05),
              gap: 8,
              activeColor: Colors.white,
              iconSize: 22,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              duration: const Duration(milliseconds: 300),
              color: AppColors.textSecondary,
              tabBackgroundColor: AppColors.primary,
              curve: Curves.easeInOutCubic,
              tabs: const [
                GButton(icon: Icons.home_rounded, text: 'Home'),
                GButton(icon: Icons.analytics_rounded, text: 'Progress'),
                GButton(icon: Icons.menu_book_rounded, text: 'Journal'),
                GButton(icon: Icons.emergency_rounded, text: 'Emergency'),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(scaffoldKey: _scaffoldKey),
      drawer: const AppDrawer(),

      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Streak Counter
              StreakCounter(onStreakReset: () {}),

              const SizedBox(height: 32),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
