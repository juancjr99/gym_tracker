import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Card que muestra información del ejercicio actual
class ExerciseInfoCard extends StatelessWidget {
  const ExerciseInfoCard({
    required this.exercise,
    required this.routineExercise,
    super.key,
  });

  final Exercise exercise;
  final RoutineExercise routineExercise;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Imagen placeholder o icono
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.darkSurfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: exercise.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        exercise.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderIcon();
                        },
                      ),
                    )
                  : _buildPlaceholderIcon(),
            ),
            const SizedBox(height: 16),
            Text(
              exercise.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ...exercise.muscleGroups.map((group) {
                  return Chip(
                    label: Text(_getMuscleGroupName(group)),
                    avatar: Icon(
                      PhosphorIconsBold.target,
                      size: 16,
                    ),
                  );
                }),
                Chip(
                  label: Text(_getExerciseTypeName(exercise.type)),
                  avatar: Icon(
                    _getExerciseTypeIcon(exercise.type),
                    size: 16,
                  ),
                  backgroundColor: _getExerciseTypeColor(exercise.type)
                      .withOpacity(0.2), // Opacidad ligera solo para el chip
                ),
              ],
            ),
            if (exercise.description != null) ...[
              const SizedBox(height: 12),
              Text(
                exercise.description!,
                style: TextStyle(color: AppColors.darkOnSurface),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Center(
      child: Icon(
        _getExerciseTypeIcon(exercise.type),
        size: 64,
        color: AppColors.darkOnSurfaceVariant,
      ),
    );
  }

  IconData _getExerciseTypeIcon(ExerciseType type) {
    switch (type) {
      case ExerciseType.weight:
        return PhosphorIconsBold.barbell;
      case ExerciseType.bodyweight:
        return PhosphorIconsBold.personArmsSpread;
      case ExerciseType.time:
        return PhosphorIconsBold.timer;
      case ExerciseType.combined:
        return PhosphorIconsBold.lightningSlash;
    }
  }

  Color _getExerciseTypeColor(ExerciseType type) {
    switch (type) {
      case ExerciseType.weight:
        return AppColors.darkError; // Rojo consistente
      case ExerciseType.bodyweight:
        return Colors.blue;
      case ExerciseType.time:
        return AppColors.darkWarning;
      case ExerciseType.combined:
        return Colors.purple;
    }
  }

  String _getExerciseTypeName(ExerciseType type) {
    switch (type) {
      case ExerciseType.weight:
        return 'Weight';
      case ExerciseType.bodyweight:
        return 'Bodyweight';
      case ExerciseType.time:
        return 'Time';
      case ExerciseType.combined:
        return 'Combined';
    }
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
