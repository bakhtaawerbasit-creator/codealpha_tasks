import 'package:flutter/material.dart';

import '../models/flashcard.dart';
import '../services/storage_service.dart';
import '../widgets/flashcard_widget.dart';
import 'manage_cards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();

  List<Flashcard> _flashcards = [];

  int _currentIndex = 0;
  bool _showAnswer = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  Future<void> _loadFlashcards() async {
    final cards = await _storageService.getFlashcards();

    if (cards.isEmpty) {
      final defaultCards = [
        Flashcard(
          id: 1,
          question: 'What is Flutter?',
          answer:
              'Flutter is Google\'s UI toolkit for building cross-platform applications.',
        ),
        Flashcard(
          id: 2,
          question: 'What programming language does Flutter use?',
          answer: 'Flutter uses the Dart programming language.',
        ),
        Flashcard(
          id: 3,
          question: 'What is a Widget in Flutter?',
          answer:
              'A widget is a building block of a Flutter user interface.',
        ),
        Flashcard(
          id: 4,
          question: 'What is Dart?',
          answer:
              'Dart is a programming language developed by Google.',
        ),
        Flashcard(
          id: 5,
          question: 'What is StatefulWidget?',
          answer:
              'A StatefulWidget can change its state during the lifetime of the application.',
        ),
      ];

      await _storageService.saveFlashcards(defaultCards);

      setState(() {
        _flashcards = defaultCards;
        _isLoading = false;
      });
    } else {
      setState(() {
        _flashcards = cards;
        _isLoading = false;
      });
    }
  }

  void _nextCard() {
    if (_flashcards.isEmpty) return;

    setState(() {
      if (_currentIndex < _flashcards.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _showAnswer = false;
    });
  }

  void _previousCard() {
    if (_flashcards.isEmpty) return;

    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        _currentIndex = _flashcards.length - 1;
      }

      _showAnswer = false;
    });
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  Future<void> _openManageCards() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageCardsScreen(
          flashcards: _flashcards,
          onCardsUpdated: (updatedCards) async {
            await _storageService.saveFlashcards(updatedCards);

            setState(() {
              _flashcards = updatedCards;

              if (_flashcards.isEmpty) {
                _currentIndex = 0;
              } else if (_currentIndex >= _flashcards.length) {
                _currentIndex = _flashcards.length - 1;
              }

              _showAnswer = false;
            });
          },
        ),
      ),
    );
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
          'Flashcard Quiz',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Manage Cards',
            icon: const Icon(Icons.library_books_outlined),
            onPressed: _openManageCards,
          ),
        ],
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _flashcards.isEmpty
              ? _buildEmptyState()
              : _buildFlashcardScreen(),
    );
  }

  Widget _buildFlashcardScreen() {
    final flashcard = _flashcards[_currentIndex];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF24243A),
                  ),
                ),

                Text(
                  '${_currentIndex + 1} / ${_flashcards.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B50E8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: (_currentIndex + 1) / _flashcards.length,
              minHeight: 7,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF5B50E8),
              ),
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Center(
                child: FlashcardWidget(
                  flashcard: flashcard,
                  showAnswer: _showAnswer,
                  onShowAnswer: _toggleAnswer,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _previousCard,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5B50E8),
                      side: const BorderSide(
                        color: Color(0xFF5B50E8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _nextCard,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B50E8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _openManageCards,
                icon: const Icon(Icons.edit_note),
                label: const Text('Manage Flashcards'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF5B50E8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.style_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              'No Flashcards Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Create your first flashcard to start learning.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: _openManageCards,
              icon: const Icon(Icons.add),
              label: const Text('Add Flashcard'),
            ),
          ],
        ),
      ),
    );
  }
}