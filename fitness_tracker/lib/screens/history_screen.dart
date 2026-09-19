import 'package:flutter/material.dart';

import '../models/fitness_activity.dart';
import '../services/database_service.dart';
import '../widgets/activity_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<FitnessActivity> activities = [];

  @override
  void initState() {
    super.initState();
    loadActivities();
  }

  Future<void> loadActivities() async {
    final data =
        await DatabaseService.instance.getActivities();

    if (!mounted) return;

    setState(() {
      activities = data;
    });
  }

  Future<void> deleteActivity(int id) async {
    await DatabaseService.instance.deleteActivity(id);
    await loadActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Activity History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: activities.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center_outlined,
                    size: 70,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'No activities yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Start logging your fitness activities.',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadActivities,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];

                  return ActivityTile(
                    activity: activity,
                    onDelete: () {
                      deleteActivity(activity.id!);
                    },
                  );
                },
              ),
            ),
    );
  }
}