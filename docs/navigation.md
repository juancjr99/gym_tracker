# Navegación con Go Router

## Objetivo

Implementar un sistema de navegación robusto usando **GoRouter** que permita navegar entre pantallas de manera declarativa, con soporte para deep linking, rutas parametrizadas y manejo de errores.

---

## ¿Qué es Go Router?

**Go Router** es el paquete oficial de navegación declarativa para Flutter. Ventajas sobre Navigator tradicional:

- **Navegación declarativa**: Define rutas como configuración, no imperativa
- **Deep linking**: Soporte automático para URLs y navegación web
- **Type-safe**: Rutas con parámetros tipados
- **Error handling**: Manejo centralizado de rutas no encontradas
- **Redirección**: Guards y middleware para proteger rutas
- **Mejor para web**: URLs legibles y navegación con historial del navegador

---

## Archivos Añadidos/Modificados

### 📁 Estructura de Rutas (`lib/app/routes/`)

#### **1. app_routes.dart**
Define todas las rutas de la aplicación como constantes:

```dart
class AppRoutes {
  static const String home = '/';
  static const String routines = '/routines';
  static const String routineDetail = '/routines/:id';
  static const String createRoutine = '/routines/create';
  static const String editRoutine = '/routines/:id/edit';
  static const String workouts = '/workouts';
  static const String startWorkout = '/workout/start/:routineId';
  static const String exercises = '/exercises';
  static const String settings = '/settings';
  static const String statistics = '/statistics';
}
```

**Ventajas**:
- Centraliza todas las rutas en un solo lugar
- Evita typos usando constantes
- Fácil refactorización si cambian paths

#### **2. route_params.dart**
Define nombres de parámetros de ruta:

```dart
class RouteParams {
  static const String id = 'id';
  static const String routineId = 'routineId';
  static const String exerciseId = 'exerciseId';
  // Query params
  static const String returnToHome = 'returnToHome';
  static const String selectedDate = 'selectedDate';
}
```

**Uso**: Extrae parámetros de forma type-safe desde `state.pathParameters[RouteParams.id]`

#### **3. app_router.dart**
Configuración principal del router:

```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      // ... más rutas
    ],
    errorBuilder: (context, state) => ErrorPage(path: state.uri.path),
  );
}
```

**Características**:
- `navigatorKey`: Para acceso global al navigator
- `debugLogDiagnostics`: Logs útiles en desarrollo
- `errorBuilder`: Página personalizada para rutas 404
- Rutas con parámetros: `:id`, `:routineId`

#### **4. routes.dart**
Barrel export para facilitar importaciones:

```dart
export 'app_router.dart';
export 'app_routes.dart';
export 'route_params.dart';
```

---

### 📱 Páginas Implementadas (`lib/presentation/pages/`)

#### **Páginas Funcionales**

**1. HomePage** (`home/home_page.dart`)
- Dashboard principal con quick actions
- Lista de entrenamientos recientes (usa WorkoutBloc)
- Navegación a todas las secciones principales
- FloatingActionButton para "Start Workout"

**2. RoutinesListPage** (`routines/routines_list_page.dart`)
- Lista todas las rutinas (usa RoutineBloc con GetIt)
- Estados: loading, error, empty, loaded
- Acciones: ver detalle, editar, duplicar, archivar, eliminar
- FAB para crear nueva rutina
- Modal bottom sheet para opciones de rutina
- Diálogo de confirmación para eliminar

#### **Páginas Placeholder** (estructura básica, listas para implementar)

**3. RoutineDetailPage** (`routines/routine_detail_page.dart`)
- Recibe `routineId` como parámetro
- Placeholder con ID visible

**4. CreateRoutinePage** (`routines/create_routine_page.dart`)
- Modo crear o editar según `routineId` opcional
- Placeholder diferenciado

**5. StartWorkoutPage** (`workout/start_workout_page.dart`)
- Recibe `routineId` como parámetro
- Inicia sesión de entrenamiento

**6. ExercisesPage** (`exercises/exercises_page.dart`)
- Librería de ejercicios
- Placeholder

**7. SettingsPage** (`settings/settings_page.dart`)
- Configuración de la app
- Placeholder

**8. StatisticsPage** (`statistics/statistics_page.dart`)
- Estadísticas y progreso
- Placeholder

#### **pages.dart**
Barrel export de todas las páginas:

```dart
export 'home/home_page.dart';
export 'routines/routines_list_page.dart';
// ... todas las páginas
```

---

### 🔧 Integración con App (`lib/app/view/app.dart`)

Modificado para usar `MaterialApp.router`:

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,  // ← GoRouter config
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // ... localization
    );
  }
}
```

**Cambios clave**:
- `MaterialApp` → `MaterialApp.router`
- Usa `routerConfig` en lugar de `home` o `routes`
- Material Design 3 habilitado

---

## Patrones de Navegación

### **1. Navegación Básica (Push)**

```dart
// Navegar a routines
context.push(AppRoutes.routines);

// Navegar con parámetro
context.push('/routines/123');

// O usar replaceAll para parámetros dinámicos
context.push(
  AppRoutes.routineDetail.replaceAll(':id', routineId),
);
```

### **2. Navegación con Reemplazo (Go)**

```dart
// Reemplaza ruta actual (no añade al stack)
context.go(AppRoutes.home);
```

### **3. Extraer Parámetros de Ruta**

```dart
// En el builder de GoRoute:
GoRoute(
  path: '/routines/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return RoutineDetailPage(routineId: id);
  },
)
```

### **4. Query Parameters** (preparado, no usado aún)

```dart
// Navegar con query params
context.push('/workouts?date=2024-01-15');

// Leer query params
final date = state.uri.queryParameters['date'];
```

### **5. Pop / Volver Atrás**

```dart
// Equivalente a Navigator.pop()
context.pop();

// Con resultado
context.pop(result);
```

---

## Integración con BLoC

### **Patrón usado en HomePage y RoutinesListPage**

```dart
BlocProvider(
  create: (_) => getIt<RoutineBloc>()..add(const LoadRoutines()),
  child: BlocBuilder<RoutineBloc, RoutineState>(
    builder: (context, state) {
      if (state is RoutineLoading) return CircularProgressIndicator();
      if (state is RoutineLoaded) return ListView(...);
      // ...
    },
  ),
)
```

**GetIt + BLoC**:
- `getIt<RoutineBloc>()` resuelve BLoC desde DI
- Se dispara evento inicial en `create`
- `BlocBuilder` reconstruye UI según estado

---

## Rutas Configuradas

| Ruta | Path | Parámetros | Descripción |
|------|------|------------|-------------|
| **home** | `/` | - | Dashboard principal |
| **routines** | `/routines` | - | Lista de rutinas |
| **routine-detail** | `/routines/:id` | `id` | Detalle de rutina |
| **create-routine** | `/routines/create` | - | Crear rutina |
| **edit-routine** | `/routines/:id/edit` | `id` | Editar rutina |
| **start-workout** | `/workout/start/:routineId` | `routineId` | Iniciar workout |
| **exercises** | `/exercises` | - | Librería ejercicios |
| **settings** | `/settings` | - | Configuración |
| **statistics** | `/statistics` | - | Estadísticas |

---

## Manejo de Errores

### **404 - Ruta No Encontrada**

```dart
errorBuilder: (context, state) => Scaffold(
  body: Center(
    child: Column(
      children: [
        Icon(Icons.error_outline),
        Text('Page not found'),
        Text('Path: ${state.uri.path}'),
        ElevatedButton(
          onPressed: () => context.go(AppRoutes.home),
          child: Text('Go Home'),
        ),
      ],
    ),
  ),
),
```

---

## Testing de Navegación

### **Ejemplo: Test de ruta básica**

```dart
testWidgets('Navigate to routines page', (tester) async {
  await tester.pumpWidget(const App());
  
  // Tap en botón de rutinas
  await tester.tap(find.text('My Routines'));
  await tester.pumpAndSettle();
  
  // Verificar que navegó
  expect(find.text('My Routines'), findsOneWidget);
});
```

### **Test con parámetros**

```dart
testWidgets('Navigate to routine detail', (tester) async {
  final router = AppRouter.router;
  router.go('/routines/test-id-123');
  await tester.pumpAndSettle();
  
  expect(find.text('Routine ID: test-id-123'), findsOneWidget);
});
```

---

## Notas y TODOs

### ✅ Completado
- [x] Estructura de rutas con AppRoutes y RouteParams
- [x] AppRouter configurado con GoRouter
- [x] HomePage funcional con navegación
- [x] RoutinesListPage con BLoC integrado
- [x] 6 páginas placeholder (detalle, crear, ejercicios, settings, stats, start workout)
- [x] Error handler para 404
- [x] Integración en App con MaterialApp.router
- [x] Barrel exports (routes.dart, pages.dart)

### 📋 Pendiente
- [ ] Implementar UI completa de CreateRoutinePage
- [ ] Implementar UI completa de RoutineDetailPage
- [ ] Implementar StartWorkoutPage con timer y tracking
- [ ] Añadir navegación con tabs (BottomNavigationBar) si se requiere
- [ ] Implementar guards/redirects (ej: login required)
- [ ] Deep linking en Android/iOS (configurar AndroidManifest y Info.plist)
- [ ] Tests de navegación (widget tests con GoRouter)

### 🎯 Mejoras Futuras
- **Animaciones de transición**: CustomTransitionPage para animaciones personalizadas
- **Bottom Navigation**: ShellRoute para tabs persistentes
- **Nested navigation**: Sub-routers para secciones complejas
- **Route guards**: Redirect callback para proteger rutas (ej: auth)
- **Analytics**: Log de navegación para analytics

---

## Comandos Útiles

### **Verificar Compilación**

```bash
fvm flutter analyze
```

### **Ejecutar App**

```bash
fvm flutter run
```

### **Hot Reload** (durante desarrollo)
Presiona `r` en terminal o guarda archivo en IDE

---

## Ejemplos de Código

### **Navegar desde Widget**

```dart
// Simple push
ElevatedButton(
  onPressed: () => context.push(AppRoutes.routines),
  child: Text('View Routines'),
)

// Push con parámetro dinámico
ListTile(
  title: Text(routine.name),
  onTap: () => context.push(
    AppRoutes.routineDetail.replaceAll(':id', routine.id),
  ),
)
```

### **Navegar con GetIt + BLoC**

```dart
IconButton(
  icon: Icon(Icons.delete),
  onPressed: () {
    // 1. Dispatch evento al BLoC
    context.read<RoutineBloc>().add(DeleteRoutineEvent(id));
    
    // 2. Volver atrás después de eliminar
    context.pop();
  },
)
```

### **Manejo de Resultados**

```dart
// Navegar y esperar resultado
final result = await context.push<bool>(AppRoutes.createRoutine);
if (result == true) {
  // Rutina creada, recargar lista
  context.read<RoutineBloc>().add(LoadRoutines());
}

// En CreateRoutinePage, retornar resultado
context.pop(true);  // Success
```

---

## Recursos

- [Go Router Documentation](https://pub.dev/packages/go_router)
- [Flutter Navigation and Routing](https://docs.flutter.dev/ui/navigation)
- [GoRouter Examples](https://github.com/flutter/packages/tree/main/packages/go_router/example)

---

## Resumen

- **GoRouter** configurado con 9 rutas principales
- **HomePage** y **RoutinesListPage** funcionales con BLoC
- **6 páginas placeholder** listas para implementar UI
- **Navegación declarativa** con type-safe parameters
- **Error handling** para rutas 404
- **Integración completa** con GetIt (DI) y BLoC (state management)
- **Material Design 3** habilitado
- **Estructura escalable** para añadir más rutas fácilmente

**Siguiente paso**: Implementar UI completa de CreateRoutinePage con formularios y gestión de ejercicios.
