import 'dart:math';
import 'package:flutter/material.dart';

typedef Quote = ({String text, String author});

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen>
    with SingleTickerProviderStateMixin {
  static const List<Quote> _quotes = [
    (text: 'The secret of getting ahead is getting started.', author: 'Mark Twain'),
    (text: 'It always seems impossible until it\'s done.', author: 'Nelson Mandela'),
    (text: 'Don\'t watch the clock; do what it does. Keep going.', author: 'Sam Levenson'),
    (text: 'The future depends on what you do today.', author: 'Mahatma Gandhi'),
    (text: 'You don\'t have to be great to start, but you have to start to be great.', author: 'Zig Ziglar'),
    (text: 'Focus on being productive instead of busy.', author: 'Tim Ferriss'),
    (text: 'Action is the foundational key to all success.', author: 'Pablo Picasso'),
    (text: 'You will never find time for anything. If you want time, you must make it.', author: 'Charles Buxton'),
    (text: 'Small daily improvements over time lead to stunning results.', author: 'Robin Sharma'),
    (text: 'Either you run the day or the day runs you.', author: 'Jim Rohn'),
  ];

  late int _currentIndex;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = Random().nextInt(_quotes.length);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose(); // always dispose to avoid memory leaks
    super.dispose();
  }

  Future<void> _nextQuote() async {
    await _fadeController.reverse();
    setState(() {
      int next;
      do {
        next = Random().nextInt(_quotes.length);
      } while (next == _currentIndex && _quotes.length > 1);
      _currentIndex = next;
    });
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final quote = _quotes[_currentIndex];

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Inspire'),
        backgroundColor: scheme.surface,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.format_quote,
                            size: 40, color: scheme.primary),
                        const SizedBox(height: 20),
                        Text(
                          quote.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '— ${quote.author}',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: scheme.onPrimaryContainer.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _nextQuote,
                icon: const Icon(Icons.refresh),
                label: const Text('New Quote'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}