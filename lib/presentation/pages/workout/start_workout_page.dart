import 'package:flutter/material.dart';

/// Página placeholder para iniciar workout
class StartWorkoutPage extends StatelessWidget {
  const StartWorkoutPage({required this.routineId, super.key});

  final String routineId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Workout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 64),
            const SizedBox(height: 16),
            Text('Starting workout with routine: $routineId'),
            const SizedBox(height: 8),
            const Text('Coming soon...'),
          ],
        ),
      ),
    );
  }
}
