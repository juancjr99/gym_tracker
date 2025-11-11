import 'package:flutter/material.dart';

/// Página placeholder para crear/editar rutina
class CreateRoutinePage extends StatelessWidget {
  const CreateRoutinePage({this.routineId, super.key});

  final String? routineId;

  @override
  Widget build(BuildContext context) {
    final isEditing = routineId != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Routine' : 'Create Routine'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64),
            const SizedBox(height: 16),
            Text(isEditing ? 'Editing routine: $routineId' : 'Create new routine'),
            const SizedBox(height: 8),
            const Text('Coming soon...'),
          ],
        ),
      ),
    );
  }
}
