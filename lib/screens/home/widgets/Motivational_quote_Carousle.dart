import 'package:flutter/material.dart';
import 'package:nohaste/models/Motivational_quote.dart';

class MotivationalQuoteCarousel extends StatefulWidget {
  final List<MotivationalQuote> quotes;
  final double height;
  final bool showIndicators;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Function(int)? onQuoteChanged;

  const MotivationalQuoteCarousel({
    super.key,
    required this.quotes,
    this.height = 200,
    this.showIndicators = true,
    this.margin = const EdgeInsets.symmetric(horizontal: 20),
    this.padding = const EdgeInsets.all(24),
    this.onQuoteChanged,
  });

  @override
  State<MotivationalQuoteCarousel> createState() =>
      _MotivationalQuoteCarouselState();
}

class _MotivationalQuoteCarouselState extends State<MotivationalQuoteCarousel> {
  late PageController _pageController;
  int _currentQuoteIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goToNext() {
    if (_currentQuoteIndex < widget.quotes.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPrevious() {
    if (_currentQuoteIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToIndex(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Quote Carousel
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentQuoteIndex = index;
              });
              widget.onQuoteChanged?.call(index);
            },
            itemCount: widget.quotes.length,
            itemBuilder: (context, index) {
              return _buildQuoteCard(widget.quotes[index]);
            },
          ),
        ),

        // Quote Indicators
        if (widget.showIndicators) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.quotes.length,
              (index) => GestureDetector(
                onTap: () => goToIndex(index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentQuoteIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentQuoteIndex == index
                        ? Colors.blue.shade400
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuoteCard(MotivationalQuote quote) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: quote.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: quote.gradient[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '"${quote.text}"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '— ${quote.author}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.9),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              quote.category,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
