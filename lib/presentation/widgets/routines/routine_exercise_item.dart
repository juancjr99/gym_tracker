import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:gym_tracker/presentation/bloc/exercise/exercise_bloc.dart';
import 'package:gym_tracker/presentation/bloc/exercise/exercise_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Widget que muestra un ejercicio de una rutina con diseño profesional
class RoutineExerciseItem extends StatelessWidget {
  const RoutineExerciseItem({
    required this.routineExercise,
    required this.index,
    required this.totalCount,
    required this.onEdit,
    required this.onRemove,
    super.key,
  });

  final RoutineExercise routineExercise;
  final int index;
  final int totalCount;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, state) {
        Exercise? exercise;
        
        if (state is ExerciseLoaded) {
          try {
            exercise = state.exercises.firstWhere(
              (e) => e.id == routineExercise.exerciseId,
            );
          } catch (_) {
            // Exercise not found
          }
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: const Color(0xFF1E1E1E), // Color sólido sin transparencia
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFF3A3A3A), // Borde sólido
              width: 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Icono del tipo de ejercicio a la izquierda
                  _buildExerciseTypeIcon(exercise?.type),
                  
                  const SizedBox(width: 12),
                  
                  // Contenido principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del ejercicio
                        Text(
                          exercise?.name ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(height: 6),
                        
                        // Sets y reps en una línea
                        _buildExerciseConfig(exercise),
                        
                        const SizedBox(height: 6),
                        
                        // Tags pequeños pegados abajo
                        if (exercise != null && exercise.muscleGroups.isNotEmpty)
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: exercise.muscleGroups.take(3).map((group) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.darkSurfaceVariant,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _getMuscleGroupName(group),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.darkOnSurface,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Menu de 3 puntos a la derecha
                  PopupMenuButton<String>(
                    icon: Icon(
                      PhosphorIconsBold.dotsThreeVertical,
                      color: AppColors.darkOnSurfaceVariant,
                      size: 20,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onRemove();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIconsBold.pencilSimple,
                              size: 18,
                              color: AppColors.darkOnSurface,
                            ),
                            const SizedBox(width: 12),
                            const Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIconsBold.trash,
                              size: 18,
                              color: AppColors.darkError,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Delete',
                              style: TextStyle(color: AppColors.darkError),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseTypeIcon(ExerciseType? type) {
    if (type == null) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.darkSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.fitness_center, size: 16),
      );
    }

    IconData icon;
    Color color;

    switch (type) {
      case ExerciseType.weight:
        icon = PhosphorIconsBold.barbell;
        color = AppColors.darkError; // Rojo consistente
      case ExerciseType.bodyweight:
        icon = PhosphorIconsBold.personArmsSpread;
        color = const Color(0xFF4A90E2);
      case ExerciseType.time:
        icon = PhosphorIconsBold.timer;
        color = AppColors.darkWarning;
      case ExerciseType.combined:
        icon = PhosphorIconsBold.lightning;
        color = const Color(0xFFAB47BC);
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2), // Opacidad ligera solo para el fondo del icono
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }

  Widget _buildExerciseConfig(Exercise? exercise) {
    final parts = <String>[];
    
    if (routineExercise.sets != null) {
      parts.add('${routineExercise.sets} sets');
    }
    
    if (routineExercise.reps != null) {
      parts.add('${routineExercise.reps} reps');
    }
    
    if (routineExercise.weight != null) {
      parts.add('${routineExercise.weight}kg');
    }
    
    if (routineExercise.duration != null) {
      final minutes = routineExercise.duration! ~/ 60;
      final seconds = routineExercise.duration! % 60;
      if (minutes > 0) {
        parts.add('${minutes}m ${seconds}s');
      } else {
        parts.add('${seconds}s');
      }
    }
    
    if (parts.isEmpty) {
      return Text(
        'Tap to configure',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.darkOnSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    
    return Text(
      parts.join(' • '),
      style: TextStyle(
        fontSize: 12,
        color: AppColors.darkOnSurface,
      ),
    );
  }

  String _getMuscleGroupName(MuscleGroup group) {
    switch (group) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.back:
        return 'Back';
      case MuscleGroup.shoulders:
        return 'Shoulders';
      case MuscleGroup.arms:
        return 'Arms';
      case MuscleGroup.legs:
        return 'Legs';
      case MuscleGroup.glutes:
        return 'Glutes';
      case MuscleGroup.core:
        return 'Core';
      case MuscleGroup.cardio:
        return 'Cardio';
      case MuscleGroup.fullBody:
        return 'Full Body';
    }
  }
}
