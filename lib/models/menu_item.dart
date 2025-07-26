import 'package:flutter/material.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
