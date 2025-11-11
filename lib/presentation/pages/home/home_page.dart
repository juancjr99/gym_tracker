import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/app/routes/app_routes.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_text_styles.dart';
import 'package:gym_tracker/domain/entities/routine.dart';
import 'package:gym_tracker/domain/entities/workout_record.dart';
import 'package:gym_tracker/injection/injection.dart';
import 'package:gym_tracker/presentation/presentation.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Workout Home - Pantalla principal enfocada en quick start
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: AppTextStyles.bodyLarge(
                        AppColors.darkOnSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Athlete',
                      style: AppTextStyles.headlineLarge(
                        AppColors.darkOnBackground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Streak card
                    _StreakCard(),
                  ],
                ),
              ),
            ),

            // Quick Start Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Text(
                  'QUICK START',
                  style: AppTextStyles.labelLarge(
                    AppColors.darkOnSurfaceVariant,
                  ),
                ),
              ),
            ),

            // Rutinas frecuentes para quick start
            SliverToBoxAdapter(
              child: BlocProvider(
                create: (_) => getIt<RoutineBloc>()..add(const LoadRoutines()),
                child: BlocBuilder<RoutineBloc, RoutineState>(
                  builder: (context, state) {
                    if (state is RoutineLoading) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is RoutineLoaded && state.routines.isNotEmpty) {
                      // Mostrar las primeras 3 rutinas
                      final quickRoutines = state.routines.take(3).toList();
                      
                      return Column(
                        children: [
                          // Primera rutina (card grande)
                          if (quickRoutines.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                              child: _QuickStartCard(
                                routine: quickRoutines[0],
                                isPrimary: true,
                              ),
                            ),
                          
                          // Siguientes 2 rutinas (cards medianas)
                          if (quickRoutines.length > 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _QuickStartCard(
                                      routine: quickRoutines[1],
                                      isPrimary: false,
                                    ),
                                  ),
                                  if (quickRoutines.length > 2) ...[
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _QuickStartCard(
                                        routine: quickRoutines[2],
                                        isPrimary: false,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                        ],
                      );
                    }

                    // Estado vacío
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: _EmptyQuickStart(),
                    );
                  },
                ),
              ),
            ),

            // This Week Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  'THIS WEEK',
                  style: AppTextStyles.labelLarge(
                    AppColors.darkOnSurfaceVariant,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _WeekStatsCards(),
              ),
            ),

            // Recent Activity
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RECENT ACTIVITY',
                      style: AppTextStyles.labelLarge(
                        AppColors.darkOnSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.routines),
                      child: Text(
                        'View All',
                        style: AppTextStyles.labelMedium(
                          AppColors.darkPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Lista de workouts recientes
            SliverToBoxAdapter(
              child: BlocProvider(
                create: (_) => getIt<WorkoutBloc>()..add(const LoadWorkouts()),
                child: BlocBuilder<WorkoutBloc, WorkoutState>(
                  builder: (context, state) {
                    if (state is WorkoutLoading) {
                      return const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is WorkoutLoaded && state.workouts.isNotEmpty) {
                      final recentWorkouts = state.workouts.take(5).toList();
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: recentWorkouts.map((workout) {
                            return _RecentWorkoutTile(workout: workout);
                          }).toList(),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No workouts yet. Start your first one!',
                          style: AppTextStyles.bodyMedium(
                            AppColors.darkOnSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== WIDGETS ====================

/// Streak card - muestra racha de días consecutivos
class _StreakCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient, // Solo dorado
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkPrimary.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIconsBold.fire,
            size: 32,
            color: AppColors.darkOnPrimary,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '0 day streak',
                style: AppTextStyles.titleLarge(AppColors.darkOnPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                'Keep it up!',
                style: AppTextStyles.bodySmall(
                  AppColors.darkOnPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Quick start card - rutina lista para empezar
class _QuickStartCard extends StatelessWidget {
  const _QuickStartCard({
    required this.routine,
    required this.isPrimary,
  });

  final Routine routine;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a start workout
        context.push(
          AppRoutes.startWorkout.replaceAll(':routineId', routine.id),
        );
      },
      child: Container(
        height: isPrimary ? 160 : 140,
        padding: EdgeInsets.all(isPrimary ? 20 : 16),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.darkBorder.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.darkPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    PhosphorIconsBold.barbell,
                    color: AppColors.darkPrimary,
                    size: isPrimary ? 24 : 20,
                  ),
                ),
                const Spacer(),
                Icon(
                  PhosphorIconsBold.play,
                  color: AppColors.darkPrimary,
                  size: isPrimary ? 28 : 24,
                ),
              ],
            ),
            const Spacer(),
            Text(
              routine.name,
              style: isPrimary
                  ? AppTextStyles.titleLarge(AppColors.darkOnBackground)
                  : AppTextStyles.titleMedium(AppColors.darkOnBackground),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${routine.exercises.length} exercises',
              style: AppTextStyles.bodySmall(AppColors.darkOnSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state cuando no hay rutinas
class _EmptyQuickStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.darkBorder.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            PhosphorIconsBold.folderOpen,
            size: 64,
            color: AppColors.darkOnSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No routines yet',
            style: AppTextStyles.titleMedium(AppColors.darkOnSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first routine to get started',
            style: AppTextStyles.bodySmall(AppColors.darkOnSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push(AppRoutes.createRoutine),
            icon: const Icon(Icons.add),
            label: const Text('Create Routine'),
          ),
        ],
      ),
    );
  }
}

/// Week stats cards - mini estadísticas de la semana
class _WeekStatsCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniStatCard(
            icon: PhosphorIconsBold.barbell,
            value: '0',
            label: 'Workouts',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniStatCard(
            icon: PhosphorIconsBold.clock,
            value: '0h',
            label: 'Time',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniStatCard(
            icon: PhosphorIconsBold.trendUp,
            value: '0kg',
            label: 'Volume',
          ),
        ),
      ],
    );
  }
}

/// Mini stat card
class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkBorder.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.darkPrimary,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.statsNumber(
              AppColors.darkPrimary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall(AppColors.darkOnSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Recent workout tile
class _RecentWorkoutTile extends StatelessWidget {
  const _RecentWorkoutTile({required this.workout});

  final WorkoutRecord workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkBorder.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.darkPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              PhosphorIconsBold.barbell,
              color: AppColors.darkPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workout',
                  style: AppTextStyles.titleSmall(AppColors.darkOnSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  workout.startTime != null
                      ? '${workout.startTime.toString().split('.')[0]}'
                      : workout.date.toString().split(' ')[0],
                  style: AppTextStyles.bodySmall(AppColors.darkOnSurfaceVariant),
                ),
              ],
            ),
          ),
          Icon(
            PhosphorIconsBold.caretRight,
            color: AppColors.darkOnSurfaceVariant,
            size: 20,
          ),
        ],
      ),
    );
  }
}
