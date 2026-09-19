import 'package:flutter/material.dart';

import '../models/fitness_activity.dart';
import '../services/database_service.dart';
import '../widgets/stat_card.dart';
import 'add_activity_screen.dart';
import 'history_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  List<FitnessActivity> get todayActivities {
    final now = DateTime.now();

    return activities.where((activity) {
      return activity.date.year == now.year &&
          activity.date.month == now.month &&
          activity.date.day == now.day;
    }).toList();
  }

  int get todaySteps {
    return todayActivities.fold(
      0,
      (sum, activity) => sum + activity.steps,
    );
  }

  int get todayCalories {
    return todayActivities.fold(
      0,
      (sum, activity) => sum + activity.calories,
    );
  }

  int get todayMinutes {
    return todayActivities.fold(
      0,
      (sum, activity) => sum + activity.duration,
    );
  }

  Future<void> openAddActivity() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddActivityScreen(),
      ),
    );

    if (result == true) {
      loadActivities();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepProgress =
        (todaySteps / 10000).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitness Tracker',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Stay active. Stay healthy.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              ).then((_) => loadActivities());
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddActivity,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Activity'),
      ),

      body: RefreshIndicator(
        onRefresh: loadActivities,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              _getGreeting(),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Your Daily Overview',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Steps',
                    value: todaySteps.toString(),
                    unit: '/ 10K',
                    icon: Icons.directions_walk,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Calories',
                    value: todayCalories.toString(),
                    unit: 'kcal',
                    icon: Icons.local_fire_department,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Workout',
                    value: todayMinutes.toString(),
                    unit: 'min',
                    icon: Icons.timer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Activities',
                    value: todayActivities.length.toString(),
                    unit: 'today',
                    icon: Icons.fitness_center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Daily Step Goal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Text(
                    '$todaySteps / 10,000 steps',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: stepProgress,
                      minHeight: 12,
                      backgroundColor:
                          Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation(
                        Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${(stepProgress * 100).toInt()}% completed',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Access',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ProgressScreen(),
                      ),
                    );
                  },
                  child: const Text('View Progress'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _quickCard(
                    Icons.add_circle_outline,
                    'Log Activity',
                    openAddActivity,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickCard(
                    Icons.bar_chart,
                    'Weekly Stats',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ProgressScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _quickCard(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.indigo,
              size: 35,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning! ☀️';
    } else if (hour < 17) {
      return 'Good afternoon! 🌤️';
    } else {
      return 'Good evening! 🌙';
    }
  }
}