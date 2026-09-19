import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;
  final bool showAnswer;
  final VoidCallback onShowAnswer;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
    required this.showAnswer,
    required this.onShowAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: showAnswer
              ? [
                  const Color(0xFF6C63FF),
                  const Color(0xFF5146D8),
                ]
              : [
                  const Color(0xFF7C6FFF),
                  const Color(0xFF5B50E8),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showAnswer ? Icons.lightbulb : Icons.help_outline,
            color: Colors.white,
            size: 45,
          ),

          const SizedBox(height: 20),

          Text(
            showAnswer ? 'ANSWER' : 'QUESTION',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            showAnswer ? flashcard.answer : flashcard.question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton.icon(
            onPressed: onShowAnswer,
            icon: Icon(
              showAnswer
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            label: Text(
              showAnswer ? 'Hide Answer' : 'Show Answer',
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFF5B50E8),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}