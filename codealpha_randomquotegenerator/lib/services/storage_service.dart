import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quote.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_quotes';

  Future<List<Quote>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString(_favoritesKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final List<dynamic> decodedData = jsonDecode(data);

    return decodedData
        .map((item) => Quote.fromJson(item))
        .toList();
  }

  Future<void> saveFavorites(List<Quote> quotes) async {
    final prefs = await SharedPreferences.getInstance();

    final String encodedData = jsonEncode(
      quotes.map((quote) => quote.toJson()).toList(),
    );

    await prefs.setString(_favoritesKey, encodedData);
  }
}