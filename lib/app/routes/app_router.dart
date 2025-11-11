import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_tracker/app/routes/app_routes.dart';
import 'package:gym_tracker/app/routes/route_params.dart';
import 'package:gym_tracker/app/view/app_scaffold.dart';
import 'package:gym_tracker/presentation/pages/exercises/exercises_page.dart';
import 'package:gym_tracker/presentation/pages/home/home_page.dart';
import 'package:gym_tracker/presentation/pages/routines/create_routine_page.dart';
import 'package:gym_tracker/presentation/pages/routines/routine_detail_page.dart';
import 'package:gym_tracker/presentation/pages/routines/routines_list_page.dart';
import 'package:gym_tracker/presentation/pages/settings/settings_page.dart';
import 'package:gym_tracker/presentation/pages/statistics/statistics_page.dart';
import 'package:gym_tracker/presentation/pages/workout/start_workout_page.dart';

/// Configuración del router de la aplicación usando GoRouter
class AppRouter {
  AppRouter._();

  /// Clave global para el navegador
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// Instancia singleton del router
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      // Shell route con Bottom Navigation Bar
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          // Home/Workout tab
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const HomePage(),
            ),
          ),

          // Routines tab (lista completa)
          GoRoute(
            path: AppRoutes.routines,
            name: 'routines',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const RoutinesListPage(),
            ),
          ),

          // Statistics tab
          GoRoute(
            path: AppRoutes.statistics,
            name: 'statistics',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const StatisticsPage(),
            ),
          ),

          // Settings tab
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const SettingsPage(),
            ),
          ),
        ],
      ),

      // Rutas fuera del bottom nav (pantallas completas)
      GoRoute(
        path: AppRoutes.createRoutine,
        name: 'create-routine',
        builder: (context, state) => const CreateRoutinePage(),
      ),
      GoRoute(
        path: AppRoutes.editRoutine,
        name: 'edit-routine',
        builder: (context, state) {
          final id = state.pathParameters[RouteParams.id];
          return CreateRoutinePage(routineId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.routineDetail,
        name: 'routine-detail',
        builder: (context, state) {
          final id = state.pathParameters[RouteParams.id]!;
          return RoutineDetailPage(routineId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.startWorkout,
        name: 'start-workout',
        builder: (context, state) {
          final routineId = state.pathParameters[RouteParams.routineId]!;
          return StartWorkoutPage(routineId: routineId);
        },
      ),
      GoRoute(
        path: AppRoutes.exercises,
        name: 'exercises',
        builder: (context, state) => const ExercisesPage(),
      ),
    ],
    
    // Manejo de errores de navegación
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Page not found'),
            const SizedBox(height: 8),
            Text('Path: ${state.uri.path}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
