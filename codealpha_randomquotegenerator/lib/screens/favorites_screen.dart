import 'package:flutter/material.dart';

import '../models/quote.dart';
import '../services/storage_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {
  final StorageService _storageService =
      StorageService();

  List<Quote> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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

  Future<void> _removeFavorite(int index) async {
    setState(() {
      _favorites.removeAt(index);
    });

    await _storageService.saveFavorites(_favorites);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B50E8),
        foregroundColor: Colors.white,
        title: const Text(
          'Favorite Quotes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _favorites.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final quote = _favorites[index];

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 14,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.format_quote,
                              color: Color(0xFF5B50E8),
                              size: 35,
                            ),

                            const SizedBox(height: 10),

                            Text(
                              '"${quote.text}"',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.w500,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 15),

                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '— ${quote.author}',
                                    style: TextStyle(
                                      color: Colors
                                          .grey.shade600,
                                      fontStyle:
                                          FontStyle.italic,
                                    ),
                                  ),
                                ),

                                IconButton(
                                  onPressed: () =>
                                      _removeFavorite(
                                    index,
                                  ),
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 85,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              'No Favorite Quotes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Save your favorite quotes and find them here later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}