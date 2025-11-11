import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/presentation/widgets/power_button.dart';

/// Botón con gradiente dorado (igual que GoldButton)
/// Para elementos premium o features especiales
class CopperButton extends StatelessWidget {
  const CopperButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.isExpanded = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return PowerButton(
      onPressed: onPressed,
      label: label,
      icon: icon,
      isExpanded: isExpanded,
      gradient: AppColors.goldGradient,
    );
  }
}
