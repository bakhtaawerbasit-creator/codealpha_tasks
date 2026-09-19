import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../models/quote.dart';
import '../services/storage_service.dart';
import '../widgets/quote_card.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService =
      StorageService();

  final Random _random = Random();

  final List<Quote> _quotes = [
    Quote(
      id: 1,
      text: 'The only way to do great work is to love what you do.',
      author: 'Steve Jobs',
    ),
    Quote(
      id: 2,
      text: 'It always seems impossible until it is done.',
      author: 'Nelson Mandela',
    ),
    Quote(
      id: 3,
      text: 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      author: 'Winston Churchill',
    ),
    Quote(
      id: 4,
      text: 'The future depends on what you do today.',
      author: 'Mahatma Gandhi',
    ),
    Quote(
      id: 5,
      text: 'Believe you can and you are halfway there.',
      author: 'Theodore Roosevelt',
    ),
    Quote(
      id: 6,
      text: 'Do what you can, with what you have, where you are.',
      author: 'Theodore Roosevelt',
    ),
    Quote(
      id: 7,
      text: 'The secret of getting ahead is getting started.',
      author: 'Mark Twain',
    ),
    Quote(
      id: 8,
      text: 'Everything you can imagine is real.',
      author: 'Pablo Picasso',
    ),
    Quote(
      id: 9,
      text: 'Dream big and dare to fail.',
      author: 'Norman Vincent Peale',
    ),
    Quote(
      id: 10,
      text: 'Great things are done by a series of small things brought together.',
      author: 'Vincent van Gogh',
    ),
    Quote(
      id: 11,
      text: 'Act as if what you do makes a difference. It does.',
      author: 'William James',
    ),
    Quote(
      id: 12,
      text: 'Keep your face always toward the sunshine, and shadows will fall behind you.',
      author: 'Walt Whitman',
    ),
  ];

  late Quote _currentQuote;

  List<Quote> _favorites = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _currentQuote = _quotes.first;

    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites =
        await _storageService.getFavorites();

    if (!mounted) return;

    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
  }

  void _generateNewQuote() {
    Quote newQuote;

    do {
      newQuote =
          _quotes[_random.nextInt(_quotes.length)];
    } while (
        _quotes.length > 1 &&
        newQuote.id == _currentQuote.id);

    setState(() {
      _currentQuote = newQuote;
    });
  }

  bool _isFavorite(Quote quote) {
    return _favorites.any(
      (item) => item.id == quote.id,
    );
  }

  Future<void> _toggleFavorite() async {
    final alreadyFavorite =
        _isFavorite(_currentQuote);

    setState(() {
      if (alreadyFavorite) {
        _favorites.removeWhere(
          (item) => item.id == _currentQuote.id,
        );
      } else {
        _favorites.add(_currentQuote);
      }
    });

    await _storageService.saveFavorites(_favorites);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          alreadyFavorite
              ? 'Removed from favorites'
              : 'Added to favorites ❤️',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _copyQuote() {
    final text =
        '"${_currentQuote.text}" — ${_currentQuote.author}';

    Clipboard.setData(
      ClipboardData(text: text),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quote copied to clipboard!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _shareQuote() {
    final text =
        '"${_currentQuote.text}"\n\n— ${_currentQuote.author}';

    SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: 'Inspirational Quote',
      ),
    );
  }

  Future<void> _openFavorites() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const FavoritesScreen(),
      ),
    );

    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5B50E8),
        foregroundColor: Colors.white,

        title: const Text(
          'Daily Quotes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Favorite Quotes',
            onPressed: _openFavorites,
            icon: const Icon(
              Icons.favorite_border,
            ),
          ),
        ],
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      const SizedBox(height: 15),

                      _buildHeader(),

                      const SizedBox(height: 25),

                      QuoteCard(
                        quote: _currentQuote,
                        isFavorite:
                            _isFavorite(_currentQuote),
                        onFavorite:
                            _toggleFavorite,
                      ),

                      const SizedBox(height: 25),

                      _buildActionButtons(),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                              _generateNewQuote,
                          icon: const Icon(
                            Icons.refresh,
                          ),
                          label: const Text(
                            'New Quote',
                          ),
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                              0xFF5B50E8,
                            ),
                            foregroundColor:
                                Colors.white,
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 17,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                            textStyle:
                                const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Tap "New Quote" for another dose of inspiration ✨',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E7FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Color(0xFF5B50E8),
            size: 32,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Daily Inspiration',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Color(0xFF24243A),
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'A little motivation for your day',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        _actionButton(
          icon: Icons.copy_outlined,
          label: 'Copy',
          onPressed: _copyQuote,
        ),

        const SizedBox(width: 15),

        _actionButton(
          icon: Icons.share_outlined,
          label: 'Share',
          onPressed: _shareQuote,
        ),

        const SizedBox(width: 15),

        _actionButton(
          icon: _isFavorite(_currentQuote)
              ? Icons.favorite
              : Icons.favorite_border,
          label: 'Favorite',
          onPressed: _toggleFavorite,
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor:
              const Color(0xFF5B50E8),
          side: const BorderSide(
            color: Color(0xFF5B50E8),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 21),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}