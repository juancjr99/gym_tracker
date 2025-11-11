import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:gym_tracker/presentation/bloc/exercise/exercise_bloc.dart';
import 'package:gym_tracker/presentation/bloc/exercise/exercise_event.dart';
import 'package:gym_tracker/presentation/bloc/exercise/exercise_state.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Bottom sheet para seleccionar un ejercicio
class ExerciseSelectorSheet extends StatefulWidget {
  const ExerciseSelectorSheet({
    required this.onExerciseSelected,
    super.key,
  });

  final void Function(Exercise) onExerciseSelected;

  @override
  State<ExerciseSelectorSheet> createState() => _ExerciseSelectorSheetState();
}

class _ExerciseSelectorSheetState extends State<ExerciseSelectorSheet> {
  final _searchController = TextEditingController();
  MuscleGroup? _selectedMuscleGroup;
  List<Exercise> _allExercises = [];
  List<Exercise> _filteredExercises = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterExercises() {
    setState(() {
      _filteredExercises = _allExercises.where((exercise) {
        // Filtrar por búsqueda de texto
        final matchesSearch = _searchController.text.isEmpty ||
            exercise.name.toLowerCase().contains(_searchController.text.toLowerCase());

        // Filtrar por grupo muscular
        final matchesMuscleGroup = _selectedMuscleGroup == null ||
            exercise.muscleGroups.contains(_selectedMuscleGroup);

        return matchesSearch && matchesMuscleGroup;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cargar ejercicios al abrir el sheet
    context.read<ExerciseBloc>().add(const LoadExercises());
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Color sólido sin transparencia
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildFilters(),
          Expanded(child: _buildExerciseList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'Select Exercise',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search exercises...',
          prefixIcon: Icon(PhosphorIconsBold.magnifyingGlass),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) => _filterExercises(),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _buildMuscleGroupFilter(),
    );
  }

  Widget _buildMuscleGroupFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A), // Color sólido como los TextFields
        border: Border.all(color: AppColors.darkBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<MuscleGroup?>(
        value: _selectedMuscleGroup,
        hint: const Text('Filter by muscle group'),
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: [
          const DropdownMenuItem(
            value: null,
            child: Text('All Muscle Groups'),
          ),
          ...MuscleGroup.values.map((group) {
            return DropdownMenuItem(
              value: group,
              child: Text(_getMuscleGroupName(group)),
            );
          }),
        ],
        onChanged: (value) {
          setState(() => _selectedMuscleGroup = value);
          _filterExercises();
        },
      ),
    );
  }

  Widget _buildExerciseList() {
    return BlocBuilder<ExerciseBloc, ExerciseState>(
      builder: (context, state) {
        if (state is ExerciseLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ExerciseError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIconsBold.warningCircle,
                  size: 64,
                  color: AppColors.darkError,
                ),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ExerciseBloc>().add(const LoadExercises());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ExerciseEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIconsBold.barbell,
                  size: 64,
                  color: AppColors.darkOnSurfaceVariant,
                ),
                const SizedBox(height: 16),
                const Text('No exercises found'),
                const SizedBox(height: 8),
                const Text(
                  'Try a different search or filter',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }

        if (state is ExerciseLoaded) {
          // Guardar todos los ejercicios y aplicar filtros
          if (_allExercises.isEmpty) {
            _allExercises = state.exercises;
            _filteredExercises = state.exercises;
          }

          final exercisesToShow = _filteredExercises.isEmpty && 
                  (_searchController.text.isNotEmpty || _selectedMuscleGroup != null)
              ? <Exercise>[]
              : _filteredExercises;

          if (exercisesToShow.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIconsBold.magnifyingGlass,
                    size: 64,
                    color: AppColors.darkOnSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  const Text('No exercises match your filters'),
                  const SizedBox(height: 8),
                  const Text(
                    'Try adjusting your search or filter',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: exercisesToShow.length,
            itemBuilder: (context, index) {
              final exercise = exercisesToShow[index];
              return _buildExerciseCard(exercise);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: const Color(0xFF2A2A2A), // Color sólido como los TextFields
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.darkBorder,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          widget.onExerciseSelected(exercise);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildExerciseTypeIcon(exercise.type),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: exercise.muscleGroups.map((group) {
                        return Chip(
                          label: Text(
                            _getMuscleGroupName(group),
                            style: const TextStyle(fontSize: 10),
                          ),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Icon(
                PhosphorIconsBold.caretRight,
                color: AppColors.darkOnSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseTypeIcon(ExerciseType type) {
    IconData icon;
    Color color;

    switch (type) {
      case ExerciseType.weight:
        icon = PhosphorIconsBold.barbell;
        color = AppColors.darkError; // Rojo consistente
      case ExerciseType.bodyweight:
        icon = PhosphorIconsBold.personArmsSpread;
        color = Colors.blue;
      case ExerciseType.time:
        icon = PhosphorIconsBold.timer;
        color = AppColors.darkWarning;
      case ExerciseType.combined:
        icon = PhosphorIconsBold.lightningSlash;
        color = Colors.purple;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2), // Opacidad ligera solo para el fondo del icono
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
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
