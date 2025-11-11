import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/app/routes/app_routes.dart';
import 'package:gym_tracker/injection/injection.dart';
import 'package:gym_tracker/presentation/presentation.dart';

/// Página que muestra la lista de rutinas
class RoutinesListPage extends StatelessWidget {
  const RoutinesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RoutineBloc>()..add(const LoadRoutines()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Routines'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implementar búsqueda
              },
            ),
          ],
        ),
        body: BlocBuilder<RoutineBloc, RoutineState>(
          builder: (context, state) {
            if (state is RoutineLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RoutineError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<RoutineBloc>().add(const LoadRoutines());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is RoutineEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No routines yet'),
                    const SizedBox(height: 8),
                    const Text('Create your first routine to get started!'),
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

            if (state is RoutineLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.routines.length,
                itemBuilder: (context, index) {
                  final routine = state.routines[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(routine.name[0].toUpperCase()),
                      ),
                      title: Text(routine.name),
                      subtitle: Text(
                        '${routine.exercises.length} exercises • '
                        '${routine.type.name}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () {
                              context.push(
                                AppRoutes.startWorkout.replaceAll(
                                  ':routineId',
                                  routine.id,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              _showRoutineOptions(context, routine.id);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        context.push(
                          AppRoutes.routineDetail.replaceAll(':id', routine.id),
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.createRoutine),
          icon: const Icon(Icons.add),
          label: const Text('New Routine'),
        ),
      ),
    );
  }

  void _showRoutineOptions(BuildContext context, String routineId) {
    showModalBottomSheet<void>(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  context.push(
                    AppRoutes.editRoutine.replaceAll(':id', routineId),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Duplicate'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  // TODO: Implementar duplicar
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive),
                title: const Text('Archive'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  context.read<RoutineBloc>().add(
                        ToggleArchiveRoutineEvent(routineId),
                      );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _confirmDelete(context, routineId);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String routineId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Routine'),
          content: const Text(
            'Are you sure you want to delete this routine? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<RoutineBloc>().add(
                      DeleteRoutineEvent(routineId),
                    );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
