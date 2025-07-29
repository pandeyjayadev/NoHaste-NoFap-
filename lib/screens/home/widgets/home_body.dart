import 'package:flutter/material.dart';
import 'package:nohaste/screens/home/widgets/Motivational_quote_Carousle.dart';
import 'package:nohaste/screens/home/widgets/streak_counter.dart';
import 'package:nohaste/services/quotes_service.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Streak Counter
            StreakCounter(onStreakReset: () {}),

            const SizedBox(height: 32),

            // Motivational Quote Carousel
            const Text(
              'Daily Motivation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220, // Adjust height as needed
              child: MotivationalQuoteCarousel(
                quotes: QuotesService.getAllQuotes(),
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(20),
              ),
            ),

            const SizedBox(height: 32),

            // Add more widgets here as needed
          ],
        ),
      ),
    );
  }
}
