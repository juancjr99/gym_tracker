# Presentation Layer & Dependency Injection

## Objetivo

Implementar la **capa de presentación** con el patrón **BLoC** para gestión de estado y configurar la **inyección de dependencias** con GetIt + Injectable para conectar todas las capas de la arquitectura.

---

## Archivos Añadidos/Modificados

### 📦 Presentation Layer - BLoCs

#### **1. Routine BLoC** (`lib/presentation/bloc/routine/`)
- **routine_event.dart**: 10 eventos (LoadRoutines, LoadRoutinesByType, LoadRoutineById, SearchRoutinesEvent, CreateRoutineEvent, UpdateRoutineEvent, DeleteRoutineEvent, DuplicateRoutineEvent, ToggleArchiveRoutineEvent, ReorderRoutineExercisesEvent)
- **routine_state.dart**: 7 estados (RoutineInitial, RoutineLoading, RoutineLoaded, RoutineDetailLoaded, RoutineOperationSuccess, RoutineError, RoutineEmpty)
- **routine_bloc.dart**: BLoC que inyecta 10 use cases y maneja todos los eventos relacionados con rutinas
- **routine.dart**: Barrel export

**Características**:
- Eventos nombrados con sufijo "Event" para evitar colisión con use cases
- Import de use cases con alias `as uc` para claridad
- Auto-reload después de mutaciones (create/update/delete)
- 10 handlers mapeados a use cases del dominio

#### **2. Workout BLoC** (`lib/presentation/bloc/workout/`)
- **workout_event.dart**: 12 eventos (LoadWorkouts, LoadWorkoutsByDateRange, LoadWorkoutById, LoadWorkoutsByRoutine, LoadLastWorkout, LoadActiveWorkouts, StartWorkoutEvent, CompleteWorkoutEvent, CancelWorkoutEvent, UpdateExerciseRecordEvent, SaveWorkoutEvent, DeleteWorkoutEvent)
- **workout_state.dart**: 8 estados (WorkoutInitial, WorkoutLoading, WorkoutLoaded, WorkoutDetailLoaded, WorkoutInProgress, WorkoutOperationSuccess, WorkoutError, WorkoutEmpty)
- **workout_bloc.dart**: BLoC que inyecta 12 use cases para gestión completa del ciclo de vida de entrenamientos
- **workout.dart**: Barrel export

**Características**:
- Estado especial `WorkoutInProgress` para entrenamientos activos
- Lógica condicional: si workout.status == WorkoutStatus.inProgress → emite WorkoutInProgress
- Maneja el ciclo completo: start → in-progress → complete/cancel
- 12 handlers para CRUD + lifecycle management

#### **3. Exercise BLoC** (`lib/presentation/bloc/exercise/`)
- **exercise_event.dart**: 5 eventos (LoadExercises, LoadExercisesByMuscleGroup, SearchExercisesEvent, CreateExerciseEvent, ToggleFavoriteExercise)
- **exercise_state.dart**: 7 estados (ExerciseInitial, ExerciseLoading, ExerciseLoaded, ExerciseDetailLoaded, ExerciseOperationSuccess, ExerciseError, ExerciseEmpty)
- **exercise_bloc.dart**: BLoC simplificado con 6 use cases
- **exercise.dart**: Barrel export

**Características**:
- Más simple que Routine/Workout (solo ejercicios personalizados y búsqueda)
- Toggle de favoritos (preparado para implementación futura)
- 5 handlers para operaciones básicas

#### **4. Presentation Barrel Export** (`lib/presentation/presentation.dart`)
- Exporta todos los BLoCs para facilitar importaciones

---

### 🔌 Dependency Injection

#### **1. Database Module** (`lib/injection/database_module.dart`)
- Registra `AppDatabase` como singleton con `@preResolve` (inicialización asíncrona)
- Provee todos los DAOs como singletons:
  - ExerciseDao
  - RoutineDao
  - RoutineExerciseDao
  - WorkoutRecordDao
  - ExerciseRecordDao
  - SetRecordDao

#### **2. Injection Setup** (`lib/injection/injection.dart`)
- `getIt`: Instancia global de GetIt
- `configureDependencies()`: Función async que inicializa todas las dependencias
- Usa código generado `injection.config.dart` por Injectable

#### **3. Bootstrap Integration** (`lib/bootstrap.dart`)
- Inicializa DI antes de `runApp()` con `await configureDependencies()`
- Garantiza que todas las dependencias estén listas antes de iniciar la app

---

### 📝 Anotaciones Injectable

#### **Repositorios** (`@LazySingleton`)
- `ExerciseRepositoryImpl` → `ExerciseRepository`
- `RoutineRepositoryImpl` → `RoutineRepository`
- `WorkoutRepositoryImpl` → `WorkoutRepository`

#### **Use Cases** (`@injectable`)
**Exercise Use Cases** (6):
- GetAllExercises
- GetExercisesByMuscleGroup
- SearchExercises
- CreateCustomExercise
- GetFavoriteExercises
- ToggleExerciseFavorite

**Routine Use Cases** (10):
- GetAllRoutines
- GetRoutinesByType
- GetRoutineById
- SearchRoutines
- CreateRoutine
- UpdateRoutine
- DeleteRoutine
- DuplicateRoutine
- GetTemplateRoutines
- GetArchivedRoutines
- ToggleArchiveRoutine
- GetRoutinesByTags
- ReorderRoutineExercises

**Workout Use Cases** (15):
- GetAllWorkouts
- GetWorkoutsByDateRange
- GetWorkoutById
- GetWorkoutsByRoutine
- GetLastWorkout
- GetActiveWorkouts
- StartWorkout
- CompleteWorkout
- CancelWorkout
- UpdateExerciseRecord
- SaveWorkout
- DeleteWorkout
- GetExerciseStats
- GetExerciseProgress
- GetPersonalRecords

#### **BLoCs** (`@injectable`)
- RoutineBloc
- WorkoutBloc
- ExerciseBloc

---

## Principios de Diseño

### **1. Clean Architecture**
```
UI Layer (Widgets)
    ↓ dispatches events
Presentation Layer (BLoC)
    ↓ calls
Domain Layer (Use Cases)
    ↓ calls
Data Layer (Repositories)
    ↓ calls
Data Sources (DAOs)
```

### **2. Separation of Concerns**
- **BLoCs**: Solo gestionan estado, no contienen lógica de negocio
- **Use Cases**: Contienen toda la lógica de negocio y validaciones
- **Repositories**: Solo traducen entre modelos y entidades

### **3. Dependency Inversion**
- BLoCs dependen de abstracciones (interfaces de use cases)
- Use Cases dependen de abstracciones (interfaces de repositories)
- Injectable + GetIt resuelven todas las dependencias automáticamente

### **4. Naming Conventions**
- Eventos de BLoC: Sufijo `Event` (ej: `CreateRoutineEvent`)
- Use Cases: Sin sufijo (ej: `CreateRoutine`)
- Import alias: `import 'use_cases.dart' as uc;`

---

## Flujo de Datos

### **Ejemplo: Crear una Rutina**

```dart
// 1. UI dispatch event
routineBloc.add(CreateRoutineEvent(routine));

// 2. BLoC handler
_onCreateRoutine(event, emit) {
  emit(RoutineLoading());
  await _createRoutineUseCase(event.routine); // Llama al use case
  emit(RoutineOperationSuccess('Rutina creada'));
  add(LoadRoutines()); // Auto-reload
}

// 3. Use Case (validaciones de negocio)
CreateRoutine.call(routine) {
  if (routine.exercises.isEmpty) throw Exception('...');
  return _repository.createRoutine(routine); // Llama al repositorio
}

// 4. Repository (conversión entity → model)
RoutineRepositoryImpl.createRoutine(routine) {
  final model = RoutineModel.fromEntity(routine);
  await _routineDao.insertRoutine(model); // Llama al DAO
  // ... insert exercises
}

// 5. DAO (Floor/SQLite)
@insert
Future<void> insertRoutine(RoutineModel routine);
```

---

## Verificación

### **Compilación**
```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

✅ **Resultado**: 125 outputs generados, sin errores

### **Archivos Generados**
- `lib/injection/injection.config.dart`: Configuración de DI con todos los registros
- `lib/data/datasources/local/app_database.g.dart`: Database de Floor

### **Dependencias Registradas**
- 1 Database (AppDatabase)
- 6 DAOs
- 3 Repositories
- 31 Use Cases
- 3 BLoCs

**Total**: 44 dependencias registradas automáticamente

---

## Notas y TODOs

### ✅ Completado
- [x] Routine BLoC (10 eventos, 7 estados)
- [x] Workout BLoC (12 eventos, 8 estados)
- [x] Exercise BLoC (5 eventos, 7 estados)
- [x] Database Module con todos los DAOs
- [x] Anotaciones @injectable en repositorios, use cases y BLoCs
- [x] Integración de DI en bootstrap
- [x] Generación de código con build_runner

### 📋 Pendiente
- [ ] Crear páginas UI (RoutinesListPage, CreateRoutinePage, WorkoutPage)
- [ ] Conectar BLoCs a widgets con BlocProvider
- [ ] Implementar navegación con Go Router
- [ ] Agregar manejo de errores en UI (SnackBars, Dialogs)
- [ ] Tests de BLoCs (bloc_test)

### ⚠️ Advertencias
- **GetFavoriteExercises**: Use case inyectado pero no usado en Exercise BLoC (preparado para feature futura)
- **Analyzer version**: Warning sobre versión de analyzer (no crítico, funciona correctamente)

---

## Siguiente Paso

**Crear primera página UI** para validar el stack completo:
1. `RoutinesListPage` con `BlocProvider<RoutineBloc>`
2. `BlocBuilder` para renderizar lista de rutinas
3. FloatingActionButton para crear nueva rutina
4. Verificar flujo completo: UI → BLoC → Use Case → Repository → DAO → Database

---

## Archivos Relacionados

### Data Layer
- `lib/data/repositories/exercise_repository_impl.dart`
- `lib/data/repositories/routine_repository_impl.dart`
- `lib/data/repositories/workout_repository_impl.dart`
- `lib/data/datasources/local/app_database.dart`

### Domain Layer
- `lib/domain/usecases/exercise_usecases.dart`
- `lib/domain/usecases/routine_usecases.dart`
- `lib/domain/usecases/workout_usecases.dart`

### Presentation Layer
- `lib/presentation/bloc/routine/` (4 archivos)
- `lib/presentation/bloc/workout/` (4 archivos)
- `lib/presentation/bloc/exercise/` (4 archivos)

### Dependency Injection
- `lib/injection/injection.dart`
- `lib/injection/database_module.dart`
- `lib/injection/injection.config.dart` (generado)
- `lib/bootstrap.dart`
