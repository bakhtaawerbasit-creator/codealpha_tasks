import 'package:flutter/material.dart';

import '../models/quote.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5B50E8),
            Color(0xFF7C6FFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.format_quote,
            color: Colors.white,
            size: 55,
          ),

          const SizedBox(height: 20),

          Text(
            '"${quote.text}"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 25),

          Container(
            width: 50,
            height: 2,
            color: Colors.white54,
          ),

          const SizedBox(height: 20),

          Text(
            '— ${quote.author}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 20),

          IconButton(
            onPressed: onFavorite,
            tooltip: 'Favorite',
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}