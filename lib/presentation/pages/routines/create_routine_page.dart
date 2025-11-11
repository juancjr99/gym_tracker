import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:gym_tracker/presentation/bloc/routine/routine_bloc.dart';
import 'package:gym_tracker/presentation/bloc/routine/routine_event.dart';
import 'package:gym_tracker/presentation/bloc/routine/routine_state.dart';
import 'package:gym_tracker/presentation/widgets/routines/routines.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';

/// Página para crear o editar una rutina
class CreateRoutinePage extends StatefulWidget {
  const CreateRoutinePage({this.routineId, super.key});

  final String? routineId;

  @override
  State<CreateRoutinePage> createState() => _CreateRoutinePageState();
}

class _CreateRoutinePageState extends State<CreateRoutinePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  final List<RoutineExercise> _exercises = [];
  final List<String> _tags = [];
  
  bool get _isEditing => widget.routineId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      // TODO: Cargar datos de la rutina existente
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoutineBloc, RoutineState>(
      listener: (context, state) {
        if (state is RoutineOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else if (state is RoutineError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Routine' : 'Create Routine'),
          actions: [
            TextButton(
              onPressed: _saveRoutine,
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.darkOnBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildExercisesSection(),
              const SizedBox(height: 24),
              _buildTagsSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Routine Name *',
                hintText: 'e.g., Push Day, Full Body Workout',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Describe your routine...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExercisesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Título de la sección
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Exercises',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        
        // Lista de ejercicios
        if (_exercises.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF3A3A3A), // Borde sólido
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  PhosphorIconsBold.barbell,
                  size: 48,
                  color: AppColors.darkOnSurfaceVariant,
                ),
                const SizedBox(height: 12),
                Text(
                  'No exercises yet',
                  style: TextStyle(
                    color: AppColors.darkOnSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _exercises.length,
            onReorder: _reorderExercises,
            itemBuilder: (context, index) {
              return _buildExerciseItem(_exercises[index], index);
            },
          ),
        
        const SizedBox(height: 12),
        
        // Botones de agregar (simples, uno bajo del otro)
        ElevatedButton.icon(
          onPressed: _showExerciseSelector,
          icon: Icon(PhosphorIconsBold.plus),
          label: const Text('Add Exercise'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: AppColors.darkError, // Rojo consistente
            foregroundColor: Colors.white,
          ),
        ),
        
        const SizedBox(height: 8),
        
        OutlinedButton.icon(
          onPressed: _addCircuitSection,
          icon: Icon(PhosphorIconsBold.lightning),
          label: const Text('Add Circuit Section'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            foregroundColor: Colors.orange,
            side: const BorderSide(color: Colors.orange),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseItem(RoutineExercise exercise, int index) {
    return RoutineExerciseItem(
      key: ValueKey('${exercise.exerciseId}_$index'),
      routineExercise: exercise,
      index: index,
      totalCount: _exercises.length,
      onEdit: () => _editExercise(index),
      onRemove: () => _removeExercise(index),
    );
  }

  Widget _buildTagsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tags',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._tags.map(
                  (tag) => Chip(
                    label: Text(tag),
                    onDeleted: () {
                      setState(() => _tags.remove(tag));
                    },
                  ),
                ),
                ActionChip(
                  avatar: Icon(PhosphorIconsBold.plus, size: 16),
                  label: const Text('Add Tag'),
                  onPressed: _showAddTagDialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  

  void _reorderExercises(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final exercise = _exercises.removeAt(oldIndex);
      _exercises.insert(newIndex, exercise);
      
      // Actualizar el orden de todos los ejercicios
      for (var i = 0; i < _exercises.length; i++) {
        _exercises[i] = _exercises[i].copyWith(order: i);
      }
    });
  }

  void _editExercise(int index) {
    _showExerciseConfig(exercise: _exercises[index], index: index);
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
      // Actualizar el orden
      for (var i = 0; i < _exercises.length; i++) {
        _exercises[i] = _exercises[i].copyWith(order: i);
      }
    });
  }

  void _addCircuitSection() {
    // TODO: Implementar agregar circuito
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Circuit Section'),
          content: const Text(
            'Circuit sections allow you to group exercises that should be '
            'performed consecutively without rest.\n\n'
            'Coming soon...',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showExerciseSelector() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Transparente para que se vean los bordes redondeados
      builder: (context) {
        return ExerciseSelectorSheet(
          onExerciseSelected: (exercise) {
            setState(() {
              final newExercise = RoutineExercise(
                exerciseId: exercise.id,
                order: _exercises.length,
                sets: 3,
                reps: 10,
                restTime: 60,
              );
              _exercises.add(newExercise);
            });
            
            // Abrir configuración del ejercicio recién añadido
            Future.delayed(const Duration(milliseconds: 300), () {
              _showExerciseConfig(
                exercise: _exercises.last,
                index: _exercises.length - 1,
              );
            });
          },
        );
      },
    );
  }

  void _showExerciseConfig({required RoutineExercise exercise, required int index}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Transparente para que se vean los bordes redondeados
      builder: (context) {
        return ExerciseConfigSheet(
          exercise: exercise,
          onSave: (updatedExercise) {
            setState(() {
              _exercises[index] = updatedExercise;
            });
          },
        );
      },
    );
  }

  void _showAddTagDialog() {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Tag'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Tag name',
              hintText: 'e.g., Strength, Hypertrophy',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _tags.add(controller.text.trim());
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveRoutine() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one exercise to the routine'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final routine = Routine(
      id: widget.routineId ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      exercises: _exercises,
      type: RoutineType.mixed, // Siempre mixed
      difficulty: RoutineDifficulty.intermediate, // Por defecto
      tags: _tags,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_isEditing) {
      context.read<RoutineBloc>().add(UpdateRoutineEvent(routine));
    } else {
      context.read<RoutineBloc>().add(CreateRoutineEvent(routine));
    }
  }
}

/// Widget para configurar un ejercicio en la rutina
class ExerciseConfigSheet extends StatefulWidget {
  const ExerciseConfigSheet({
    required this.exercise,
    required this.onSave,
    super.key,
  });

  final RoutineExercise exercise;
  final void Function(RoutineExercise) onSave;

  @override
  State<ExerciseConfigSheet> createState() => _ExerciseConfigSheetState();
}

class _ExerciseConfigSheetState extends State<ExerciseConfigSheet> {
  late TextEditingController _setsController;
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  late TextEditingController _durationController;
  late TextEditingController _restTimeController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController(
      text: widget.exercise.sets?.toString() ?? '3',
    );
    _repsController = TextEditingController(
      text: widget.exercise.reps?.toString() ?? '10',
    );
    _weightController = TextEditingController(
      text: widget.exercise.weight?.toString() ?? '',
    );
    _durationController = TextEditingController(
      text: widget.exercise.duration?.toString() ?? '',
    );
    _restTimeController = TextEditingController(
      text: widget.exercise.restTime.toString(),
    );
    _notesController = TextEditingController(
      text: widget.exercise.notes ?? '',
    );
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    _restTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E), // Color sólido oscuro
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20), // Bordes redondeados arriba
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exercise Configuration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _setsController,
                    decoration: const InputDecoration(
                      labelText: 'Sets',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration (s)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _restTimeController,
              decoration: const InputDecoration(
                labelText: 'Rest Time (seconds)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: Icon(PhosphorIconsBold.check),
                label: const Text('Save Configuration'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.darkError, // Rojo sólido sin gradiente
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    final updatedExercise = widget.exercise.copyWith(
      sets: int.tryParse(_setsController.text),
      reps: int.tryParse(_repsController.text),
      weight: double.tryParse(_weightController.text),
      duration: int.tryParse(_durationController.text),
      restTime: int.tryParse(_restTimeController.text) ?? 60,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    widget.onSave(updatedExercise);
    Navigator.pop(context);
  }
}
