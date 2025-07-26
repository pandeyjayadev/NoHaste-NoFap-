import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../services/streak_service.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<StreakData> _streakHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStreakHistory();
  }

  Future<void> _loadStreakHistory() async {
    setState(() => _isLoading = true);

    final history = await StreakService.getStreakHistory();

    setState(() {
      _streakHistory = history;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 2,
        shadowColor: AppColors.shadowLight,
        title: const Text(
          'Progress History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading:
            false, // Remove back button since we're using bottom nav
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: _loadStreakHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_streakHistory.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildStatsHeader(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _streakHistory.length,
            itemBuilder: (context, index) {
              return _buildStreakTile(_streakHistory[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatsHeader() {
    final totalStreaks = _streakHistory.length;
    final longestStreak = _streakHistory.isNotEmpty
        ? _streakHistory.first.days
        : 0;
    final totalDays = _streakHistory.fold<int>(
      0,
      (sum, streak) => sum + streak.days,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total\nStreaks', '$totalStreaks'),
          _buildStatItem('Longest\nStreak', '$longestStreak days'),
          _buildStatItem('Total\nDays', '$totalDays'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStreakTile(StreakData streak, int index) {
    final formatter = DateFormat('MMM dd, yyyy');
    final timeFormatter = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: _buildLeadingIcon(streak, index),
        title: Text(
          '${streak.days} ${streak.days == 1 ? 'Day' : 'Days'} Streak',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Started: ${formatter.format(streak.startDate)} at ${timeFormatter.format(streak.startDate)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Ended: ${formatter.format(streak.endDate)} at ${timeFormatter.format(streak.endDate)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Duration: ${streak.days}d ${streak.hours}h ${streak.minutes}m',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        trailing: Icon(
          _getStreakIcon(streak.days),
          color: _getStreakColor(streak.days),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(StreakData streak, int index) {
    // Show trophy for top 3, numbers for the rest
    if (index < 3) {
      Color trophyColor;
      if (index == 0) {
        trophyColor = Colors.amber; // Gold
      } else if (index == 1) {
        trophyColor = Colors.grey[400]!; // Silver
      } else {
        trophyColor = Colors.brown[300]!; // Bronze
      }

      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: trophyColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(Icons.emoji_events, color: trophyColor, size: 32),
      );
    } else {
      // Show rank number for positions 4+
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: _getStreakColor(streak.days).withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            '#${index + 1}',
            style: TextStyle(
              color: _getStreakColor(streak.days),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timeline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              'No Streak History Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Start your first streak and it will appear here when you reset it.',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Since we're using bottom nav, no need to navigate back
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Start Your Journey'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStreakColor(int days) {
    if (days >= 30) return Colors.purple;
    if (days >= 21) return Colors.blue;
    if (days >= 14) return Colors.green;
    if (days >= 7) return Colors.orange;
    return const Color.fromARGB(255, 198, 15, 15);
  }

  IconData _getStreakIcon(int days) {
    if (days >= 30) return Icons.diamond;
    if (days >= 21) return Icons.star;
    if (days >= 14) return Icons.local_fire_department;
    if (days >= 7) return Icons.trending_up;
    return Icons.support;
  }
}
