import 'package:flutter/material.dart';

import '../models/fitness_activity.dart';

class ActivityTile extends StatelessWidget {
  final FitnessActivity activity;
  final VoidCallback onDelete;

  const ActivityTile({
    super.key,
    required this.activity,
    required this.onDelete,
  });

  IconData _getIcon() {
    switch (activity.exerciseType.toLowerCase()) {
      case 'running':
        return Icons.directions_run;
      case 'walking':
        return Icons.directions_walk;
      case 'cycling':
        return Icons.directions_bike;
      case 'gym':
        return Icons.fitness_center;
      case 'swimming':
        return Icons.pool;
      case 'yoga':
        return Icons.self_improvement;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(),
              color: Colors.indigo,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.exerciseType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${activity.duration} min • '
                  '${activity.calories} kcal • '
                  '${activity.steps} steps',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${activity.date.day}/${activity.date.month}/${activity.date.year}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}