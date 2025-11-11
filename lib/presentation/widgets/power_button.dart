import 'package:flutter/material.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:gym_tracker/core/theme/app_text_styles.dart';

/// Botón premium con gradiente personalizable
/// Por defecto usa gradiente dorado, pero acepta cualquier gradiente
class PowerButton extends StatelessWidget {
  const PowerButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.isExpanded = false,
    this.gradient = AppColors.goldGradient,
    super.key,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isExpanded;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isExpanded ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: onPressed != null ? gradient : null,
        color: onPressed == null ? AppColors.darkSurfaceVariant : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.darkPrimary.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Row(
              mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: onPressed != null
                        ? AppColors.darkOnPrimary
                        : AppColors.darkOnSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  label,
                  style: AppTextStyles.button(
                    onPressed != null
                        ? AppColors.darkOnPrimary
                        : AppColors.darkOnSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Botón con gradiente dorado
/// Para CTAs importantes - usa el mismo estilo que GoldButton
class IntenseButton extends StatelessWidget {
  const IntenseButton({
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

/// Botón con gradiente dorado (premium puro)
/// Usado para elementos de logros o características premium
class GoldButton extends StatelessWidget {
  const GoldButton({
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
