import 'package:flutter/material.dart';

import '../models/flashcard.dart';

class ManageCardsScreen extends StatefulWidget {
  final List<Flashcard> flashcards;
  final Function(List<Flashcard>) onCardsUpdated;

  const ManageCardsScreen({
    super.key,
    required this.flashcards,
    required this.onCardsUpdated,
  });

  @override
  State<ManageCardsScreen> createState() =>
      _ManageCardsScreenState();
}

class _ManageCardsScreenState
    extends State<ManageCardsScreen> {
  late List<Flashcard> _flashcards;

  @override
  void initState() {
    super.initState();

    _flashcards = List.from(widget.flashcards);
  }

  void _addFlashcard() {
    _showFlashcardDialog();
  }

  void _editFlashcard(int index) {
    _showFlashcardDialog(
      existingCard: _flashcards[index],
      index: index,
    );
  }

  void _showFlashcardDialog({
    Flashcard? existingCard,
    int? index,
  }) {
    final questionController = TextEditingController(
      text: existingCard?.question ?? '',
    );

    final answerController = TextEditingController(
      text: existingCard?.answer ?? '',
    );

    final isEditing = existingCard != null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isEditing
                ? 'Edit Flashcard'
                : 'Add Flashcard',
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Question',
                    hintText: 'Enter your question',
                    prefixIcon: const Icon(Icons.help_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: answerController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    hintText: 'Enter the answer',
                    prefixIcon: const Icon(Icons.lightbulb_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                final question =
                    questionController.text.trim();

                final answer =
                    answerController.text.trim();

                if (question.isEmpty || answer.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter both question and answer.',
                      ),
                    ),
                  );

                  return;
                }

                setState(() {
                  if (isEditing && index != null) {
                    _flashcards[index] = Flashcard(
                      id: existingCard.id,
                      question: question,
                      answer: answer,
                    );
                  } else {
                    _flashcards.add(
                      Flashcard(
                        id: DateTime.now()
                            .millisecondsSinceEpoch,
                        question: question,
                        answer: answer,
                      ),
                    );
                  }
                });

                widget.onCardsUpdated(_flashcards);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing
                          ? 'Flashcard updated successfully!'
                          : 'Flashcard added successfully!',
                    ),
                  ),
                );
              },
              child: Text(
                isEditing ? 'Save' : 'Add',
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteFlashcard(int index) {
    final card = _flashcards[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Flashcard?'),

          content: Text(
            'Are you sure you want to delete this flashcard?\n\n'
            '${card.question}',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _flashcards.removeAt(index);
                });

                widget.onCardsUpdated(_flashcards);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Flashcard deleted successfully!',
                    ),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
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
          'Manage Flashcards',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addFlashcard,
        backgroundColor: const Color(0xFF5B50E8),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Card'),
      ),

      body: _flashcards.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _flashcards.length,
              itemBuilder: (context, index) {
                final card = _flashcards[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E7FF),
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Color(0xFF5B50E8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.question,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                card.answer,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editFlashcard(index);
                            } else if (value == 'delete') {
                              _deleteFlashcard(index);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 10),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Delete'),
                                ],
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.style_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              'No Flashcards',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Tap the button below to create your first card.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}