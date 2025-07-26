import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../services/streak_service.dart';

class StreakCounter extends StatefulWidget {
  final VoidCallback? onStreakReset;

  const StreakCounter({super.key, this.onStreakReset});

  @override
  State<StreakCounter> createState() => _StreakCounterState();
}

class _StreakCounterState extends State<StreakCounter>
    with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  DateTime? _startDate;
  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  double hourProgress = 0.0;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _pulseController.repeat(reverse: true);

    // Load streak data and start timer
    _loadStreakData();
  }

  Future<void> _loadStreakData() async {
    _startDate = await StreakService.getCurrentStreakStart();

    // If no streak exists, start a new one
    if (_startDate == null) {
      _startDate = DateTime.now();
      await StreakService.setCurrentStreakStart(_startDate!);
    }

    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    if (_startDate == null) return;

    final now = DateTime.now();
    final difference = now.difference(_startDate!);

    setState(() {
      days = difference.inDays;
      hours = difference.inHours % 24;
      minutes = difference.inMinutes % 60;
      seconds = difference.inSeconds % 60;
      hourProgress = hours / 24.0;
    });
  }

  Color _getProgressColor() {
    if (hourProgress < 0.2) return Colors.red;
    if (hourProgress < 0.4) return Colors.orange;
    if (hourProgress < 0.6) return Colors.yellow;
    if (hourProgress < 0.8) return Colors.green;
    return Colors.blue;
  }

  Future<void> _resetStreak() async {
    final confirmed = await _showConfirmDialog();
    if (confirmed == true) {
      await StreakService.resetStreak();
      await _loadStreakData();
      widget.onStreakReset?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Streak reset successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<bool?> _showConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.confirmReset),
        content: const Text(AppStrings.resetWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.reset),
          ),
        ],
      ),
    );
  }

  Future<void> _setCustomDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startDate ?? DateTime.now()),
      );

      if (time != null) {
        final newStartDate = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        await StreakService.setCurrentStreakStart(newStartDate);
        setState(() {
          _startDate = newStartDate;
        });
        _updateTime();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Start date updated successfully!'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            AppStrings.currentStreak,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 30),

          // Circular Progress with Counter
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background Circle
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),

                      // Hour Progress Ring
                      SizedBox(
                        width: 260,
                        height: 260,
                        child: CircularProgressIndicator(
                          value: hourProgress,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(),
                          ),
                        ),
                      ),

                      // Inner Content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Days Counter
                          Text(
                            '$days',
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Text(
                            AppStrings.days,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Time Display
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${hours.toString().padLeft(2, '0')}:'
                              '${minutes.toString().padLeft(2, '0')}:'
                              '${seconds.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          // Motivational Message with Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _resetStreak,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text(AppStrings.resetStreak),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _setCustomDate,
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: const Text(AppStrings.setCustomDate),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
