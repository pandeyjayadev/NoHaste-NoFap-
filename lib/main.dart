import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'screens/home/widgets/streak_counter.dart';
import 'screens/progress/Progress_screen.dart';
import 'screens/journal/journal_screen.dart';
import 'screens/emergency/emergency_screen.dart';
import 'screens/home/widgets/app_drawer.dart'; // Import the new AppDrawer

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
    const EmergencyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            color: AppColors.textSecondary,
            tabBackgroundColor: AppColors.primary,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.history, text: 'History'),
              GButton(icon: Icons.book, text: 'Journal'),
              GButton(icon: Icons.warning, text: 'Emergency'),
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
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {}),
        ],
      ),
      drawer: const AppDrawer(), // Use the new AppDrawer widget
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            StreakCounter(onStreakReset: () {}),
            const SizedBox(height: 40),
            _buildMotivationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Column(
          children: [
            Icon(Icons.emoji_events, size: 60, color: AppColors.success),
            SizedBox(height: 15),
            Text(
              'Stay Strong!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Every day you resist makes you stronger. Keep going!',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
