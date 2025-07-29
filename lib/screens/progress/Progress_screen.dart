import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
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
          'Progress & History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading:
            true, // Remove back button since we're using bottom nav
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getStreakIcon(streak.days),
              color: _getStreakColor(streak.days),
              size: 24,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
              onSelected: (value) => _handleMenuAction(value, streak, index),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit, color: AppColors.primary),
                    title: Text('Edit'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleMenuAction(
    String action,
    StreakData streak,
    int index,
  ) async {
    switch (action) {
      case 'edit':
        await _showEditDialog(streak, index);
        break;
      case 'delete':
        await _showDeleteConfirmation(streak, index);
        break;
    }
  }

  Future<void> _showEditDialog(StreakData streak, int index) async {
    DateTime newStartDate = streak.startDate;
    DateTime newEndDate = streak.endDate;

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Streak'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('Start Date & Time'),
                      subtitle: Text(
                        DateFormat('MMM dd, yyyy HH:mm').format(newStartDate),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: newStartDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(newStartDate),
                          );
                          if (time != null) {
                            setState(() {
                              newStartDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                    ListTile(
                      title: const Text('End Date & Time'),
                      subtitle: Text(
                        DateFormat('MMM dd, yyyy HH:mm').format(newEndDate),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: newEndDate,
                          firstDate: newStartDate,
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(newEndDate),
                          );
                          if (time != null) {
                            setState(() {
                              newEndDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newEndDate.isAfter(newStartDate)) {
                      Navigator.of(context).pop(true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('End date must be after start date'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      await _updateStreak(index, newStartDate, newEndDate);
    }
  }

  Future<void> _updateStreak(
    int index,
    DateTime newStartDate,
    DateTime newEndDate,
  ) async {
    try {
      final difference = newEndDate.difference(newStartDate);
      final newStreakData = StreakData(
        startDate: newStartDate,
        endDate: newEndDate,
        days: difference.inDays,
        hours: difference.inHours % 24,
        minutes: difference.inMinutes % 60,
      );

      await StreakService.updateStreakAt(index, newStreakData);
      await _loadStreakHistory();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Streak updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating streak: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmation(StreakData streak, int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Streak'),
          content: Text(
            'Are you sure you want to delete this ${streak.days} day streak? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _deleteStreak(index);
    }
  }

  Future<void> _deleteStreak(int index) async {
    try {
      await StreakService.deleteStreakAt(index);
      await _loadStreakHistory();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Streak deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting streak: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

  IconData? _getStreakIcon(int days) {
    if (days >= 30) return Icons.diamond;
    if (days >= 21) return Icons.star;
    if (days >= 14) return Icons.local_fire_department;
    if (days >= 7) return Icons.trending_up;
    return null; // No icon when days < 7
  }
}
