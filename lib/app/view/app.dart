import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_tracker/app/routes/app_router.dart';
import 'package:gym_tracker/core/theme/theme.dart';
import 'package:gym_tracker/injection/injection.dart';
import 'package:gym_tracker/l10n/arb/app_localizations.dart';
import 'package:gym_tracker/presentation/bloc/exercise/exercise_bloc.dart';
import 'package:gym_tracker/presentation/bloc/routine/routine_bloc.dart';
import 'package:gym_tracker/presentation/bloc/workout/workout_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => getIt<RoutineBloc>()),
        BlocProvider(create: (_) => getIt<ExerciseBloc>()),
        BlocProvider(create: (_) => getIt<WorkoutBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            
            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            
            // Localization
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
