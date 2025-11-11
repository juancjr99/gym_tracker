import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/app/routes/app_routes.dart';
import 'package:gym_tracker/injection/injection.dart';
import 'package:gym_tracker/presentation/presentation.dart';

/// Página principal / Dashboard de la aplicación
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quick actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _QuickActionCard(
              title: 'Start Workout',
              icon: Icons.fitness_center,
              color: Colors.green,
              onTap: () => context.push(AppRoutes.routines),
            ),
            const SizedBox(height: 12),
            _QuickActionCard(
              title: 'My Routines',
              icon: Icons.list_alt,
              color: Colors.blue,
              onTap: () => context.push(AppRoutes.routines),
            ),
            const SizedBox(height: 12),
            _QuickActionCard(
              title: 'Exercises',
              icon: Icons.fitness_center,
              color: Colors.orange,
              onTap: () => context.push(AppRoutes.exercises),
            ),
            const SizedBox(height: 12),
            _QuickActionCard(
              title: 'Statistics',
              icon: Icons.bar_chart,
              color: Colors.purple,
              onTap: () => context.push(AppRoutes.statistics),
            ),
            const SizedBox(height: 24),
            // Recent workouts section
            Text(
              'Recent Workouts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocProvider(
                create: (_) => getIt<WorkoutBloc>()..add(const LoadWorkouts()),
                child: BlocBuilder<WorkoutBloc, WorkoutState>(
                  builder: (context, state) {
                    if (state is WorkoutLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is WorkoutLoaded) {
                      if (state.workouts.isEmpty) {
                        return const Center(
                          child: Text('No workouts yet. Start your first one!'),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.workouts.length > 5 
                            ? 5 
                            : state.workouts.length,
                        itemBuilder: (context, index) {
                          final workout = state.workouts[index];
                          return ListTile(
                            leading: const Icon(Icons.fitness_center),
                            title: Text('Workout'),
                            subtitle: Text(
                              workout.startTime != null
                                  ? '${workout.startTime.toString().split('.')[0]}'
                                  : workout.date.toString().split(' ')[0],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push(
                              AppRoutes.workoutDetail.replaceAll(
                                ':id',
                                workout.id,
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: Text('No workouts available'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.routines),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Workout'),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
