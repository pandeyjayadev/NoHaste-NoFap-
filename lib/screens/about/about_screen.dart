import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        title: const Text(
          'About',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info Section
            _buildSectionHeader('🙌 About This App'),
            const SizedBox(height: 16),
            _buildContentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NoFap Tracker by Jayadev Pandey',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'is a simple and powerful tool to help you stay committed to your NoFap journey. Whether you\'re just getting started or have been trying for a while, this app is designed to keep you motivated, track your progress, and give you the strength to break free from unhealthy habits.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '🧠 Why NoFap?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'NoFap is about more than just quitting a habit — it\'s about reclaiming your focus, energy, and mental clarity. This app helps you track your streaks, journal your thoughts, set reminders, and visualize your growth day by day.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Features Section
            _buildSectionHeader('📲 Core Features'),
            const SizedBox(height: 16),
            _buildFeatureList(),
            const SizedBox(height: 24),
            // About Me Section
            _buildSectionHeader('👨‍💻 About Me'),
            const SizedBox(height: 16),
            _buildContentCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hi, I\'m Jayadev Pandey',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'a frontend developer and cybersecurity enthusiast from Nepal 🇳🇵. I created this app not just as a developer, but as someone who truly understands the struggle and power of the NoFap lifestyle.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'I\'m passionate about building tools that empower people to live more intentionally and grow stronger every day.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Contact Section
            _buildSectionHeader('📬 Contact & Links'),
            const SizedBox(height: 16),
            _buildContactCard(),
            const SizedBox(height: 32),
            // Motivational Footer
            _buildMotivationalFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Daily streak tracker',
      'Relapse log & journal',
      'Motivation vault (quotes & tips)',
      'Clean, distraction-free interface',
      'Privacy-focused (no account needed)',
    ];

    return _buildContentCard(
      child: Column(
        children: features
            .map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildContactCard() {
    return _buildContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContactItem(
            icon: Icons.web,
            title: 'Portfolio',
            subtitle: 'pandeyj.com.np',
            onTap: () => _launchURL('https://pandeyj.com.np'),
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            icon: Icons.email,
            title: 'Email',
            subtitle: 'pandeyjayadev4215@gmail.com',
            onTap: () => _launchEmail('pandeyjayadev4215@gmail.com'),
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            icon: Icons.build,
            title: 'Skills',
            subtitle: 'Flutter, React, Node.js, Cybersecurity',
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalFooter() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Text(
              'Let\'s keep pushing forward.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'One day. One win. One better version of you.',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) {
    // URL launcher implementation would go here
    // For now, we'll use a placeholder
    debugPrint('Launching URL: $url');
  }

  void _launchEmail(String email) {
    // Email launcher implementation would go here
    // For now, we'll use a placeholder
    debugPrint('Launching email: $email');
  }
}
