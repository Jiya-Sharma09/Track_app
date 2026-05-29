import 'package:flutter/material.dart';
import 'package:track_app/screens/home_screen.dart';   // ← your existing file, unchanged
import 'package:track_app/screens/stats_screen.dart';
import 'package:track_app/screens/quotes_screen.dart';

/// This is the ONLY new wrapper. HomeScreen is untouched.
/// Point your post-login navigation here instead of HomeScreen.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // IndexedStack renders all three pages simultaneously but only
  // displays the one at [_currentIndex]. This preserves scroll
  // positions, loaded data, and widget state across tab switches —
  // much better than rebuilding widgets on every tap.
  final List<Widget> _pages = const [
    HomeScreen(),
    StatsScreen(),
    QuotesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      // IndexedStack sits here — no Scaffold inside each child page
      // should define its own bottomNavigationBar, or it will fight
      // with this one. The nav bar lives here and nowhere else.
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.format_quote_outlined),
            selectedIcon: Icon(Icons.format_quote),
            label: 'Inspire',
          ),
        ],
      ),
    );
  }
}