import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/fitness_activity.dart';
import '../services/database_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() =>
      _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
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

  List<FitnessActivity> getWeekActivities() {
    final now = DateTime.now();

    final startOfWeek =
        DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1));

    return activities.where((activity) {
      return !activity.date.isBefore(startOfWeek);
    }).toList();
  }

  double getDailyCalories(int day) {
    final now = DateTime.now();

    final targetDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: 6 - day));

    double total = 0;

    for (final activity in activities) {
      if (activity.date.year == targetDate.year &&
          activity.date.month == targetDate.month &&
          activity.date.day == targetDate.day) {
        total += activity.calories;
      }
    }

    return total;
  }

  int getWeeklySteps() {
    int total = 0;

    for (final activity in getWeekActivities()) {
      total += activity.steps;
    }

    return total;
  }

  int getWeeklyCalories() {
    int total = 0;

    for (final activity in getWeekActivities()) {
      total += activity.calories;
    }

    return total;
  }

  int getWeeklyMinutes() {
    int total = 0;

    for (final activity in getWeekActivities()) {
      total += activity.duration;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Weekly Progress',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: loadActivities,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'This Week',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    'Steps',
                    getWeeklySteps().toString(),
                    Icons.directions_walk,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    'Calories',
                    getWeeklyCalories().toString(),
                    Icons.local_fire_department,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _summaryCard(
              'Workout Time',
              '${getWeeklyMinutes()} min',
              Icons.timer,
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Calories This Week',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        maxY: 1000,
                        alignment: BarChartAlignment.spaceAround,
                        gridData: const FlGridData(
                          show: false,
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget:
                                  (value, meta) {
                                const days = [
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                  'Sun',
                                ];

                                if (value.toInt() >= 0 &&
                                    value.toInt() <
                                        days.length) {
                                  return Text(
                                    days[value.toInt()],
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  );
                                }

                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(
                          7,
                          (index) {
                            final calories =
                                getDailyCalories(index);

                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: calories == 0
                                      ? 5
                                      : calories,
                                  width: 18,
                                  borderRadius:
                                      BorderRadius.circular(5),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.indigo,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}