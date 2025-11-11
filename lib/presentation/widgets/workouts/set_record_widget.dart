import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/domain/entities/entities.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Widget para registrar un set individual
class SetRecordWidget extends StatefulWidget {
  const SetRecordWidget({
    required this.setNumber,
    required this.routineExercise,
    required this.exercise,
    required this.onSetCompleted,
    this.setRecord,
    super.key,
  });

  final int setNumber;
  final RoutineExercise routineExercise;
  final Exercise? exercise;
  final SetRecord? setRecord;
  final void Function(SetRecord) onSetCompleted;

  @override
  State<SetRecordWidget> createState() => _SetRecordWidgetState();
}

class _SetRecordWidgetState extends State<SetRecordWidget> {
  late TextEditingController _repsController;
  late TextEditingController _weightController;
  late TextEditingController _durationController;
  bool _isCompleted = false;
  bool _isRestTimerActive = false;
  int _remainingRestTime = 0;
  Timer? _restTimer;

  @override
  void initState() {
    super.initState();
    
    if (widget.setRecord != null) {
      _isCompleted = widget.setRecord!.completed;
      _repsController = TextEditingController(
        text: widget.setRecord!.reps?.toString() ?? '',
      );
      _weightController = TextEditingController(
        text: widget.setRecord!.weight?.toString() ?? '',
      );
      _durationController = TextEditingController(
        text: widget.setRecord!.duration?.toString() ?? '',
      );
    } else {
      // Pre-rellenar con valores planificados
      _repsController = TextEditingController(
        text: widget.routineExercise.reps?.toString() ?? '',
      );
      _weightController = TextEditingController(
        text: widget.routineExercise.weight?.toString() ?? '',
      );
      _durationController = TextEditingController(
        text: widget.routineExercise.duration?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _durationController.dispose();
    _restTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlanned = widget.setNumber <= (widget.routineExercise.sets ?? 0);
    final exerciseType = widget.exercise?.type ?? ExerciseType.weight;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: _isCompleted 
          ? AppColors.darkSuccess.withOpacity(0.1) 
          : AppColors.darkSurface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _isCompleted 
                        ? AppColors.darkSuccess 
                        : AppColors.darkSurfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _isCompleted
                        ? Icon(
                            PhosphorIconsBold.check,
                            size: 16,
                            color: AppColors.darkOnPrimary,
                          )
                        : Text(
                            '${widget.setNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  isPlanned ? 'Set ${widget.setNumber}' : 'Extra Set',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (_isCompleted && _isRestTimerActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkWarning.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIconsBold.timer,
                          size: 14,
                          color: AppColors.darkWarning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatRestTime(_remainingRestTime),
                          style: TextStyle(
                            color: AppColors.darkWarning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInputFields(exerciseType),
            if (!_isCompleted) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _completeSet,
                  icon: Icon(PhosphorIconsBold.check),
                  label: const Text('Complete Set'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkSuccess,
                  ),
                ),
              ),
            ],
            if (_isCompleted && _isRestTimerActive) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: _skipRest,
                    icon: Icon(PhosphorIconsBold.skipForward),
                    label: const Text('Skip Rest'),
                  ),
                  TextButton.icon(
                    onPressed: _pauseRest,
                    icon: Icon(PhosphorIconsBold.pause),
                    label: const Text('Pause'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields(ExerciseType type) {
    switch (type) {
      case ExerciseType.weight:
        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: _repsController,
                decoration: const InputDecoration(
                  labelText: 'Reps',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                enabled: !_isCompleted,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                enabled: !_isCompleted,
              ),
            ),
          ],
        );

      case ExerciseType.bodyweight:
        return TextField(
          controller: _repsController,
          decoration: const InputDecoration(
            labelText: 'Reps',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          enabled: !_isCompleted,
        );

      case ExerciseType.time:
        return TextField(
          controller: _durationController,
          decoration: const InputDecoration(
            labelText: 'Duration (seconds)',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          enabled: !_isCompleted,
        );

      case ExerciseType.combined:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !_isCompleted,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    enabled: !_isCompleted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (seconds)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              enabled: !_isCompleted,
            ),
          ],
        );
    }
  }

  void _completeSet() {
    final setRecord = SetRecord(
      setNumber: widget.setNumber,
      reps: int.tryParse(_repsController.text),
      weight: double.tryParse(_weightController.text),
      duration: int.tryParse(_durationController.text),
      restTime: widget.routineExercise.restTime,
      completed: true,
    );

    widget.onSetCompleted(setRecord);

    setState(() {
      _isCompleted = true;
    });

    // Iniciar temporizador de descanso
    _startRestTimer();
  }

  void _startRestTimer() {
    final restTime = widget.routineExercise.restTime;
    
    setState(() {
      _isRestTimerActive = true;
      _remainingRestTime = restTime;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingRestTime--;
        
        if (_remainingRestTime <= 0) {
          _stopRestTimer();
        }
      });
    });
  }

  void _stopRestTimer() {
    _restTimer?.cancel();
    setState(() {
      _isRestTimerActive = false;
      _remainingRestTime = 0;
    });
  }

  void _skipRest() {
    _stopRestTimer();
  }

  void _pauseRest() {
    if (_isRestTimerActive) {
      _restTimer?.cancel();
      setState(() {
        _isRestTimerActive = false;
      });
    }
  }

  String _formatRestTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (minutes > 0) {
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${seconds}s';
  }
}
