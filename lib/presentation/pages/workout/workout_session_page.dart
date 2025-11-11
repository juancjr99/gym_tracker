import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:gym_tracker/injection/injection.dart';
import 'package:gym_tracker/presentation/bloc/exercise/exercise_bloc.dart';
import 'package:gym_tracker/presentation/bloc/exercise/exercise_event.dart';
import 'package:gym_tracker/presentation/bloc/exercise/exercise_state.dart';
import 'package:gym_tracker/presentation/bloc/routine/routine_bloc.dart';
import 'package:gym_tracker/presentation/bloc/routine/routine_event.dart';
import 'package:gym_tracker/presentation/bloc/routine/routine_state.dart';
import 'package:gym_tracker/presentation/bloc/workout/workout_bloc.dart';
import 'package:gym_tracker/presentation/bloc/workout/workout_event.dart';
import 'package:gym_tracker/presentation/bloc/workout/workout_state.dart';
import 'package:gym_tracker/presentation/widgets/workouts/workouts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';

/// Pantalla principal para ejecutar un entrenamiento en tiempo real
class WorkoutSessionPage extends StatefulWidget {
  const WorkoutSessionPage({
    required this.routineId,
    this.workoutId,
    super.key,
  });

  final String routineId;
  final String? workoutId;

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  int _currentExerciseIndex = 0;
  late Routine _routine;
  late WorkoutRecord _workout;
  final Map<String, List<SetRecord>> _completedSets = {};
  Timer? _totalTimeTimer;
  Duration _elapsedTime = Duration.zero;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWorkout();
  }

  void _initializeWorkout() {
    // Iniciar cronómetro total
    _totalTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedTime += const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _totalTimeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<RoutineBloc>()
            ..add(LoadRoutineById(widget.routineId)),
        ),
        BlocProvider(create: (_) => getIt<WorkoutBloc>()),
        BlocProvider(
          create: (_) => getIt<ExerciseBloc>()..add(const LoadExercises()),
        ),
      ],
      child: BlocListener<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.darkSuccess,
              ),
            );
            context.pop();
          } else if (state is WorkoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.darkError,
              ),
            );
          }
        },
        child: BlocBuilder<RoutineBloc, RoutineState>(
          builder: (context, routineState) {
            if (routineState is RoutineLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (routineState is RoutineError) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIconsBold.warningCircle,
                        size: 64,
                        color: AppColors.darkError,
                      ),
                      const SizedBox(height: 16),
                      Text(routineState.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.pop(),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (routineState is RoutineDetailLoaded) {
              _routine = routineState.routine;
              
              if (_isLoading) {
                _isLoading = false;
                _startWorkout(context);
              }

              if (_routine.exercises.isEmpty) {
                return Scaffold(
                  appBar: AppBar(title: Text(_routine.name)),
                  body: const Center(
                    child: Text('No exercises in this routine'),
                  ),
                );
              }

              final currentExercise = _routine.exercises[_currentExerciseIndex];

              return Scaffold(
                appBar: _buildAppBar(),
                body: _buildWorkoutContent(currentExercise),
                bottomNavigationBar: _buildBottomNavigation(currentExercise),
              );
            }

            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_routine.name),
          Text(
            'Exercise ${_currentExerciseIndex + 1}/${_routine.exercises.length} • ${_formatDuration(_elapsedTime)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(PhosphorIconsBold.x),
          onPressed: _showCancelDialog,
        ),
      ],
    );
  }

  Widget _buildWorkoutContent(RoutineExercise routineExercise) {
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, exerciseState) {
        Exercise? exercise;
        
        if (exerciseState is ExerciseLoaded) {
          try {
            exercise = exerciseState.exercises.firstWhere(
              (e) => e.id == routineExercise.exerciseId,
            );
          } catch (_) {
            // Exercise not found
          }
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (exercise != null) ...[
              ExerciseInfoCard(
                exercise: exercise,
                routineExercise: routineExercise,
              ),
              const SizedBox(height: 16),
            ],
            _buildPlannedInfoCard(routineExercise),
            const SizedBox(height: 16),
            _buildSetsSection(routineExercise, exercise),
            const SizedBox(height: 16),
            _buildNotesSection(routineExercise),
            const SizedBox(height: 100),
          ],
        );
      },
    );
  }

  Widget _buildPlannedInfoCard(RoutineExercise routineExercise) {
    final plannedText = _getPlannedText(routineExercise);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkPrimary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIconsBold.target,
            color: AppColors.darkPrimary,
          ),
          const SizedBox(width: 12),
          Text(
            'PLANNED: $plannedText',
            style: TextStyle(
              color: AppColors.darkPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetsSection(RoutineExercise routineExercise, Exercise? exercise) {
    final completedSetsForExercise = 
        _completedSets[routineExercise.exerciseId] ?? [];
    final plannedSets = routineExercise.sets ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sets',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${completedSetsForExercise.length}/$plannedSets completed',
                  style: TextStyle(color: AppColors.darkOnSurface),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(
              plannedSets + 1, // +1 para permitir sets extra
              (index) {
                final setNumber = index + 1;
                final isCompleted = completedSetsForExercise.length > index;
                final setRecord = isCompleted 
                    ? completedSetsForExercise[index] 
                    : null;

                return SetRecordWidget(
                  setNumber: setNumber,
                  routineExercise: routineExercise,
                  exercise: exercise,
                  setRecord: setRecord,
                  onSetCompleted: (newSetRecord) {
                    _recordSet(routineExercise.exerciseId, newSetRecord);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(RoutineExercise routineExercise) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Add notes about this exercise...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                // TODO: Guardar notas del ejercicio
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(RoutineExercise currentExercise) {
    final isLastExercise = _currentExerciseIndex == _routine.exercises.length - 1;
    final hasCompletedSets = 
        (_completedSets[currentExercise.exerciseId] ?? []).isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentExerciseIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousExercise,
                icon: Icon(PhosphorIconsBold.caretLeft),
                label: const Text('Previous'),
              ),
            ),
          if (_currentExerciseIndex > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: hasCompletedSets 
                  ? (isLastExercise ? _showFinishDialog : _nextExercise)
                  : null,
              icon: Icon(
                isLastExercise 
                    ? PhosphorIconsBold.check 
                    : PhosphorIconsBold.caretRight,
              ),
              label: Text(isLastExercise ? 'Finish Workout' : 'Next Exercise'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPlannedText(RoutineExercise exercise) {
    final parts = <String>[];
    
    if (exercise.sets != null && exercise.reps != null) {
      parts.add('${exercise.sets}x${exercise.reps}');
    }
    if (exercise.weight != null) {
      parts.add('@ ${exercise.weight}kg');
    }
    if (exercise.duration != null) {
      parts.add('${exercise.duration}s');
    }
    
    return parts.join(' ');
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startWorkout(BuildContext context) {
    final workout = WorkoutRecord(
      id: widget.workoutId ?? const Uuid().v4(),
      routineId: widget.routineId,
      date: DateTime.now(),
      startTime: DateTime.now(),
      status: WorkoutStatus.inProgress,
      exerciseRecords: [],
    );

    setState(() {
      _workout = workout;
    });

    context.read<WorkoutBloc>().add(StartWorkoutEvent(widget.routineId));
  }

  void _recordSet(String exerciseId, SetRecord setRecord) {
    setState(() {
      if (!_completedSets.containsKey(exerciseId)) {
        _completedSets[exerciseId] = [];
      }
      
      final sets = _completedSets[exerciseId]!;
      final existingIndex = sets.indexWhere(
        (s) => s.setNumber == setRecord.setNumber,
      );
      
      if (existingIndex >= 0) {
        sets[existingIndex] = setRecord;
      } else {
        sets.add(setRecord);
      }
      
      // Ordenar por número de set
      sets.sort((a, b) => a.setNumber.compareTo(b.setNumber));
    });
  }

  void _previousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
      });
    }
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _routine.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
    }
  }

  void _showCancelDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cancel Workout?'),
          content: const Text(
            'Your progress will be lost. Are you sure you want to cancel?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Continue Workout'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<WorkoutBloc>().add(
                      CancelWorkoutEvent(_workout.id),
                    );
                context.pop();
              },
              child: const Text(
                'Cancel Workout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFinishDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        int rating = 3;
        final notesController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Workout Complete! 🎉'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total Time: ${_formatDuration(_elapsedTime)}'),
                  const SizedBox(height: 24),
                  const Text('How did you feel?'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating 
                              ? PhosphorIconsBold.star 
                              : PhosphorIconsRegular.star,
                          color: AppColors.darkPrimary,
                        ),
                        onPressed: () {
                          setStateDialog(() {
                            rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _finishWorkout(rating, notesController.text);
                  },
                  child: const Text('Finish'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _finishWorkout(int rating, String notes) {
    // Construir exerciseRecords desde _completedSets
    final exerciseRecords = <ExerciseRecord>[];
    
    for (final entry in _completedSets.entries) {
      final exerciseId = entry.key;
      final sets = entry.value;
      
      exerciseRecords.add(
        ExerciseRecord(
          exerciseId: exerciseId,
          sets: sets,
          completed: true,
        ),
      );
    }

    final completedWorkout = WorkoutRecord(
      id: _workout.id,
      routineId: widget.routineId,
      date: _workout.date,
      startTime: _workout.startTime,
      endTime: DateTime.now(),
      totalDuration: _elapsedTime,
      status: WorkoutStatus.completed,
      exerciseRecords: exerciseRecords,
      notes: notes.isEmpty ? null : notes,
      rating: rating,
    );

    // Primero actualizamos el workout
    context.read<WorkoutBloc>().add(SaveWorkoutEvent(completedWorkout));
    // Luego marcamos como completado
    context.read<WorkoutBloc>().add(CompleteWorkoutEvent(_workout.id));
  }
}
