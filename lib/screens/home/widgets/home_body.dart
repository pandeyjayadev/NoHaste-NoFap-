import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'streak_counter.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Streak Counter
            StreakCounter(
              onStreakReset: () {
                // This will be called when streak is reset
                // You can add additional actions here if needed
              },
            ),

            const SizedBox(height: 40),

            // Additional content
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
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
                    'Every day is a victory!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Keep building your streak one day at a time.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
