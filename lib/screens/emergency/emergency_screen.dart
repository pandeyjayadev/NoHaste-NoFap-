import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Emergency Support'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Add top spacing
            // Large Construction Icon with Animation - Changed to green
            TweenAnimationBuilder(
              duration: const Duration(seconds: 2),
              tween: Tween<double>(begin: 0.8, end: 1.0),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.1), // Changed to green
                      border: Border.all(
                        color: Colors.green.withOpacity(
                          0.3,
                        ), // Changed to green
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.construction,
                      size: 120,
                      color: Colors.green[600], // Changed to green
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Under Construction Title - Changed to green
            Text(
              'Under Construction',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[700], // Changed to green
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Subtitle
            Text(
              'Emergency Support Feature',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Description
            Container(
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
              child: Column(
                children: [
                  Icon(Icons.upcoming, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    'This feature will be available in the next release!',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We\'re working hard to bring you emergency support resources, crisis helplines, and immediate assistance tools.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Coming Soon Badge - Changed to green
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green[400]!,
                    Colors.green[600]!,
                  ], // Changed to green
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3), // Changed to green
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Coming Soon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Back Button
            TextButton.icon(
              onPressed: () {
                // You can add navigation back to home or previous screen
              },
              icon: Icon(Icons.arrow_back, color: AppColors.primary),
              label: Text(
                'Go Back to Home',
                style: TextStyle(color: AppColors.primary, fontSize: 16),
              ),
            ),

            const SizedBox(height: 40), // Add bottom spacing
          ],
        ),
      ),
    );
  }
}
