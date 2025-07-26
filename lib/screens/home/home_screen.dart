import 'package:flutter/material.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_drawer.dart';
import 'widgets/home_body.dart';
import '../../core/constants/app_colors.dart'; // Add this import

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
      drawer: const HomeDrawer(),
      body: const HomeBody(),
    );
  }
}
