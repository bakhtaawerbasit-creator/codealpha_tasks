import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';

class StorageService {
  static const String _flashcardsKey = 'flashcards';

  Future<List<Flashcard>> getFlashcards() async {
    final prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString(_flashcardsKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final List<dynamic> decodedData = jsonDecode(data);

    return decodedData
        .map((item) => Flashcard.fromJson(item))
        .toList();
  }

  Future<void> saveFlashcards(List<Flashcard> flashcards) async {
    final prefs = await SharedPreferences.getInstance();

    final String encodedData = jsonEncode(
      flashcards.map((card) => card.toJson()).toList(),
    );

    await prefs.setString(_flashcardsKey, encodedData);
  }
}