import 'package:flutter/material.dart';

import '../models/fitness_activity.dart';
import '../services/database_service.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() =>
      _AddActivityScreenState();
}

class _AddActivityScreenState
    extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController durationController =
      TextEditingController();

  final TextEditingController caloriesController =
      TextEditingController();

  final TextEditingController stepsController =
      TextEditingController();

  String selectedExercise = 'Walking';

  final List<String> exercises = [
    'Walking',
    'Running',
    'Cycling',
    'Gym',
    'Swimming',
    'Yoga',
    'Other',
  ];

  @override
  void dispose() {
    durationController.dispose();
    caloriesController.dispose();
    stepsController.dispose();
    super.dispose();
  }

  Future<void> saveActivity() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final activity = FitnessActivity(
      exerciseType: selectedExercise,
      duration: int.parse(durationController.text),
      calories: int.parse(caloriesController.text),
      steps: int.parse(stepsController.text),
      date: DateTime.now(),
    );

    await DatabaseService.instance.insertActivity(activity);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitness activity saved successfully!'),
      ),
    );

    Navigator.pop(context, true);
  }

  String? validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a value';
    }

    if (int.tryParse(value) == null) {
      return 'Enter a valid number';
    }

    if (int.parse(value) < 0) {
      return 'Value cannot be negative';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Add Activity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Log Your Fitness',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Add your workout details below.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Exercise Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: selectedExercise,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: exercises.map((exercise) {
                  return DropdownMenuItem(
                    value: exercise,
                    child: Text(exercise),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedExercise = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                validator: validateNumber,
                decoration: InputDecoration(
                  labelText: 'Workout Duration',
                  hintText: 'e.g. 30',
                  suffixText: 'minutes',
                  prefixIcon: const Icon(Icons.timer_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                validator: validateNumber,
                decoration: InputDecoration(
                  labelText: 'Calories Burned',
                  hintText: 'e.g. 250',
                  suffixText: 'kcal',
                  prefixIcon: const Icon(Icons.local_fire_department),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: stepsController,
                keyboardType: TextInputType.number,
                validator: validateNumber,
                decoration: InputDecoration(
                  labelText: 'Steps',
                  hintText: 'e.g. 3000',
                  prefixIcon: const Icon(Icons.directions_walk),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: saveActivity,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'Save Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}