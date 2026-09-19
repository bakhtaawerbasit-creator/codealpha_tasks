class FitnessActivity {
  final int? id;
  final String exerciseType;
  final int duration;
  final int calories;
  final int steps;
  final DateTime date;

  FitnessActivity({
    this.id,
    required this.exerciseType,
    required this.duration,
    required this.calories,
    required this.steps,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseType': exerciseType,
      'duration': duration,
      'calories': calories,
      'steps': steps,
      'date': date.toIso8601String(),
    };
  }

  factory FitnessActivity.fromMap(Map<String, dynamic> map) {
    return FitnessActivity(
      id: map['id'],
      exerciseType: map['exerciseType'],
      duration: map['duration'],
      calories: map['calories'],
      steps: map['steps'],
      date: DateTime.parse(map['date']),
    );
  }
}