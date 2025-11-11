import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/core/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Scaffold principal con Bottom Navigation Bar
/// Wrapper para las 4 pantallas principales: Workout, Create, Stats, Settings
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  /// Determina el índice activo basado en la ruta actual
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    
    if (location.startsWith('/routines')) return 1;
    if (location.startsWith('/statistics')) return 2;
    if (location.startsWith('/settings')) return 3;
    
    return 0; // Home/Workout por defecto
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/routines');
      case 2:
        context.go('/statistics');
      case 3:
        context.go('/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          top: BorderSide(
            color: AppColors.darkBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: PhosphorIconsBold.barbell,
                label: 'Workout',
                isSelected: selectedIndex == 0,
                onTap: () => _onItemTapped(context, 0),
              ),
              _NavItem(
                icon: PhosphorIconsBold.plusCircle,
                label: 'Create',
                isSelected: selectedIndex == 1,
                onTap: () => _onItemTapped(context, 1),
              ),
              _NavItem(
                icon: PhosphorIconsBold.chartLine,
                label: 'Stats',
                isSelected: selectedIndex == 2,
                onTap: () => _onItemTapped(context, 2),
              ),
              _NavItem(
                icon: PhosphorIconsBold.gear,
                label: 'Settings',
                isSelected: selectedIndex == 3,
                onTap: () => _onItemTapped(context, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.darkPrimary : AppColors.darkOnSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicator line (dorado cuando activo)
            Container(
              height: 3,
              width: 40,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkPrimary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Icon
            Icon(
              icon,
              size: 24,
              color: color,
            ),
            
            const SizedBox(height: 4),
            
            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
