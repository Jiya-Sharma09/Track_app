import 'package:flutter/material.dart';
import 'package:track_app/model/quote_model.dart';
import 'package:track_app/service/api_service.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();

  Quote? _quote;
  bool _isLoading = true;
  String? _error;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _loadQuote(); // fetch on screen open
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadQuote() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _fadeController.reverse(); // fade out before replacing
      final quote = await _apiService.fetchQuote();
      setState(() {
        _quote = quote;
        _isLoading = false;
      });
      _fadeController.forward(); // fade in new quote
    } catch (e) {
      setState(() {
        _error = 'Could not load quote. Tap refresh to try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Inspire'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _buildQuoteCard(scheme),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _loadQuote, // disable while loading
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

  Widget _buildQuoteCard(ColorScheme scheme) {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }

    if (_error != null) {
      return Text(_error!, style: TextStyle(color: scheme.error));
    }

    return FadeTransition(
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
            Icon(Icons.format_quote, size: 40, color: scheme.primary),
            const SizedBox(height: 20),
            Text(
              _quote!.content,
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
                '— ${_quote!.author}',
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
    );
  }
}