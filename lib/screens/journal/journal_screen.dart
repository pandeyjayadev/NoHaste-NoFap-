import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Journal'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Add top spacing
            // Large Journal Icon with Animation
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
                      color: Colors.green.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.edit_note,
                      size: 120,
                      color: Colors.green[600],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Under Construction Title
            Text(
              'Under Construction',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Subtitle
            Text(
              'Personal Journal Feature',
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
                    'We\'re developing a personal journaling system.',
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

            // Coming Soon Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
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

            // Preview Features Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeaturePreview(
                  icon: Icons.create,
                  label: 'Write Entries',
                  color: Colors.blue,
                ),
                _buildFeaturePreview(
                  icon: Icons.mood,
                  label: 'Mood Tracking',
                  color: Colors.purple,
                ),
                _buildFeaturePreview(
                  icon: Icons.search,
                  label: 'Search Notes',
                  color: Colors.teal,
                ),
              ],
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

  Widget _buildFeaturePreview({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
