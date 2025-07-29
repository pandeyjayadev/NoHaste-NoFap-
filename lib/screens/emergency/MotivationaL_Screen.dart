import 'package:flutter/material.dart';
import 'package:nohaste/main.dart';
import 'package:nohaste/screens/home/home_screen.dart' hide HomeScreen;
import 'package:nohaste/screens/home/widgets/home_body.dart';
import 'package:url_launcher/url_launcher.dart';

class MotivationalSection extends StatefulWidget {
  const MotivationalSection({super.key});

  @override
  State<MotivationalSection> createState() => _MotivationalSectionState();
}

class _MotivationalSectionState extends State<MotivationalSection> {
  final PageController _pageController = PageController();
  int _currentQuoteIndex = 0;

  final List<MotivationalQuote> _quotes = [
    MotivationalQuote(
      text:
          "The strongest people are not those who show strength in front of us, but those who win battles we know nothing about.",
      author: "Unknown",
      category: "Strength",
      gradient: [Colors.purple.shade400, Colors.purple.shade600],
    ),
    MotivationalQuote(
      text:
          "Every time you resist temptation, you become stronger. Every time you give in, you become weaker.",
      author: "Recovery Wisdom",
      category: "Discipline",
      gradient: [Colors.blue.shade400, Colors.blue.shade600],
    ),
    MotivationalQuote(
      text: "You are not your thoughts. You are the observer of your thoughts.",
      author: "Mindfulness Teaching",
      category: "Mindfulness",
      gradient: [Colors.green.shade400, Colors.green.shade600],
    ),
    MotivationalQuote(
      text:
          "The pain of discipline weighs ounces, but the pain of regret weighs tons.",
      author: "Jim Rohn",
      category: "Discipline",
      gradient: [Colors.orange.shade400, Colors.orange.shade600],
    ),
    MotivationalQuote(
      text:
          "Your future self is counting on you to make the right choice today.",
      author: "Recovery Community",
      category: "Future Focus",
      gradient: [Colors.teal.shade400, Colors.teal.shade600],
    ),
    MotivationalQuote(
      text:
          "Every moment is a fresh beginning. You have the power to start over right now.",
      author: "T.S. Eliot",
      category: "New Beginnings",
      gradient: [Colors.indigo.shade400, Colors.indigo.shade600],
    ),
  ];

  final List<HelpfulResource> _resources = [
    HelpfulResource(
      title: "NoFap Community",
      description: "Join millions on their journey to freedom",
      url: "https://www.nofap.com/",
      icon: Icons.people_rounded,
      color: Colors.red.shade400,
    ),
    HelpfulResource(
      title: "7 Cups - Free Therapy",
      description: "Talk to trained listeners anonymously",
      url: "https://www.7cups.com/",
      icon: Icons.chat_rounded,
      color: Colors.green.shade400,
    ),
    HelpfulResource(
      title: "Meditation - Headspace",
      description: "Guided meditation for better mental health",
      url: "https://www.headspace.com/",
      icon: Icons.self_improvement_rounded,
      color: Colors.blue.shade400,
    ),
    HelpfulResource(
      title: "Cold Shower Benefits",
      description: "Learn about cold therapy for self-control",
      url: "https://www.healthline.com/health/cold-shower-benefits",
      icon: Icons.ac_unit_rounded,
      color: Colors.cyan.shade400,
    ),
    HelpfulResource(
      title: "Exercise & Mental Health",
      description: "How physical activity improves willpower",
      url:
          "https://www.mayoclinic.org/healthy-lifestyle/fitness/in-depth/exercise/art-20048389",
      icon: Icons.fitness_center_rounded,
      color: Colors.orange.shade400,
    ),
    HelpfulResource(
      title: "Addiction Recovery Guide",
      description: "Professional resources for recovery",
      url: "https://www.samhsa.gov/find-help/national-helpline",
      icon: Icons.medical_services_rounded,
      color: Colors.purple.shade400,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text(
          'Daily Motivation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2D3748)),
            onPressed: () {
              setState(() {
                _currentQuoteIndex = 0;
                _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
            tooltip: 'Refresh Quotes',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Fixed Quotes Section (Swipeable)
          Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Motivational Quotes Carousel
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentQuoteIndex = index;
                      });
                    },
                    itemCount: _quotes.length,
                    itemBuilder: (context, index) {
                      return _buildQuoteCard(_quotes[index]);
                    },
                  ),
                ),

                // Quote Indicators
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _quotes.length,
                    (index) => Container(
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

                const SizedBox(height: 20),
              ],
            ),
          ),

          // Scrollable Resources Section
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF7FAFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Resources Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: const Text(
                      'Helpful Resources',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),

                  // Scrollable Resources List
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _resources.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildResourceCard(_resources[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(MotivationalQuote quote) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
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

  Widget _buildResourceCard(HelpfulResource resource) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchURL(resource.url),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: resource.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(resource.icon, color: resource.color, size: 24),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class MotivationalQuote {
  final String text;
  final String author;
  final String category;
  final List<Color> gradient;

  MotivationalQuote({
    required this.text,
    required this.author,
    required this.category,
    required this.gradient,
  });
}

class HelpfulResource {
  final String title;
  final String description;
  final String url;
  final IconData icon;
  final Color color;

  HelpfulResource({
    required this.title,
    required this.description,
    required this.url,
    required this.icon,
    required this.color,
  });
}
