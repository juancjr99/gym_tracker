# Flujo Completo - Creación y Ejecución de Rutinas

**Fecha:** 11 Nov 2025  
**Objetivo:** Documentar el flujo completo para crear rutinas de ejercicios y ejecutarlas con registro de datos reales.

---

## 1. Resumen del Feature

El usuario podrá:
1. **Crear una rutina** con múltiples ejercicios
2. **Configurar cada ejercicio** según su tipo (peso, peso corporal, tiempo, circuito)
3. **Ejecutar la rutina** en tiempo real
4. **Registrar lo que realmente hizo** (sets, reps, peso, tiempo)
5. **Comparar** lo planificado vs lo realizado
6. **Ver historial** de entrenamientos y progreso

---

## 2. Tipos de Ejercicios y Configuración

### 2.1 Tipos de Ejercicio (`ExerciseType`)

| Tipo | Descripción | Campos Configurables |
|------|-------------|---------------------|
| **weight** | Ejercicios con peso externo (pesas, máquinas) | Sets, Reps, Peso (kg), Descanso |
| **bodyweight** | Ejercicios con peso corporal (flexiones, dominadas) | Sets, Reps, Descanso |
| **time** | Ejercicios por tiempo (plank, cardio) | Duración (segundos), Descanso |
| **combined** | Combinación de peso + tiempo | Sets, Reps o Duración, Peso opcional, Descanso |

### 2.2 Configuración por Ejercicio en la Rutina

```dart
RoutineExercise {
  exerciseId: String,          // Referencia al ejercicio
  order: int,                  // Orden en la rutina
  sets: int?,                  // Número de series (null para ejercicios por tiempo)
  reps: int?,                  // Repeticiones objetivo
  weight: double?,             // Peso objetivo en kg
  duration: int?,              // Duración en segundos (para ejercicios por tiempo)
  restTime: int,               // Descanso entre series (default: 60s)
  notes: String?,              // Notas específicas del ejercicio
  isSuperset: bool,            // Si forma parte de un superset
  supersetGroup: String?,      // ID del grupo de superset
}
```

### 2.3 Tipos de Rutina (`RoutineType`)

| Tipo | Descripción | Características |
|------|-------------|----------------|
| **traditional** | Rutina tradicional | Series y repeticiones estándar, descansos entre series |
| **circuit** | Circuito | Ejercicios consecutivos, descanso al final del circuito |
| **mixed** | Personalizada mixta | Combina traditional y circuit |

---

## 3. Flujo de Creación de Rutina

### 3.1 Pantalla: CreateRoutinePage

**Inputs:**
- Nombre de la rutina (obligatorio)
- Descripción (opcional)
- Tipo de rutina (traditional/circuit/mixed)
- Dificultad (beginner/intermediate/advanced/expert)
- Tags (lista de strings para categorizar)
- Color personalizado (opcional)
- Ícono personalizado (opcional)

**Acciones:**
1. Usuario llena formulario básico
2. Presiona "Añadir Ejercicio"
3. Se abre selector de ejercicios (modal/bottom sheet)

### 3.2 Modal: Exercise Selector

**Funcionalidad:**
- Lista de ejercicios disponibles (predefinidos + personalizados)
- Filtros por:
  - Tipo de ejercicio (weight/bodyweight/time/combined)
  - Grupo muscular (chest/back/shoulders/arms/legs/glutes/core/cardio/fullBody)
  - Dificultad (beginner/intermediate/advanced/expert)
- Búsqueda por nombre
- Vista previa con imagen/video (si está disponible)

**Acción:**
- Usuario selecciona ejercicio → Se abre ExerciseConfigSheet

### 3.3 Modal: ExerciseConfigSheet

**Configuración dinámica según tipo:**

#### Para `weight`:
```
Sets: [número] (default: 3)
Reps: [número] (default: 10)
Peso: [número] kg (opcional, para referencia)
Descanso: [número] segundos (default: 60)
Notas: [texto libre]
```

#### Para `bodyweight`:
```
Sets: [número] (default: 3)
Reps: [número] (default: 10)
Descanso: [número] segundos (default: 60)
Notas: [texto libre]
```

#### Para `time`:
```
Duración: [número] segundos (obligatorio)
Descanso: [número] segundos (default: 30)
Notas: [texto libre]
```

#### Para `combined`:
```
Sets: [número] (default: 3)
Reps o Duración: [selección dinámica]
Peso: [número] kg (opcional)
Descanso: [número] segundos (default: 60)
Notas: [texto libre]
```

**Superset (opcional):**
- Toggle "Es parte de superset"
- Si activo: asignar grupo de superset (A, B, C...)

**Acción:**
- Usuario confirma → Ejercicio se añade a la rutina

### 3.4 Lista de Ejercicios de la Rutina

**Componente: RoutineExerciseList** (ReorderableListView)

**Características:**
- Drag & drop para reordenar
- Cada item muestra:
  - Nombre del ejercicio
  - Configuración (ej: "3x10 @ 20kg" o "30s")
  - Grupo muscular (chips/tags)
  - Icono de superset (si aplica)
  - Botones: Editar, Eliminar
- Indicador visual de supersets (agrupación visual)

**Acciones:**
- Reordenar: drag & drop actualiza el campo `order`
- Editar: abre ExerciseConfigSheet con datos prellenados
- Eliminar: confirmación + eliminación

### 3.5 Validaciones antes de Guardar

```dart
Validations:
  - Nombre no vacío
  - Al menos 1 ejercicio en la rutina
  - Para cada ejercicio:
    - Si type == weight || bodyweight: sets > 0 && reps > 0
    - Si type == time: duration > 0
    - Si type == combined: (sets > 0 && (reps > 0 || duration > 0))
    - restTime >= 0
    - weight >= 0 (si está presente)
```

**Mensajes de error:**
- "El nombre de la rutina es obligatorio"
- "Debes añadir al menos un ejercicio"
- "Configura correctamente el ejercicio [nombre]"

### 3.6 Guardar Rutina

**Flujo:**
1. Usuario presiona "Guardar Rutina"
2. Se validan los datos
3. Se crea entidad `Routine` con timestamp actual
4. Se dispara evento `CreateRoutineEvent` en RoutineBloc
5. UseCase `CreateRoutine` guarda en BD
6. Navegación: regresa a lista de rutinas
7. Feedback: SnackBar "Rutina creada exitosamente"

---

## 4. Flujo de Ejecución de Rutina

### 4.1 Inicio del Entrenamiento

**Pantalla de inicio:**
- Usuario selecciona rutina desde lista
- Presiona "Iniciar Entrenamiento"
- Se crea `WorkoutRecord`:
  ```dart
  WorkoutRecord {
    id: UUID,
    routineId: [id de la rutina],
    date: DateTime.now(),
    startTime: DateTime.now(),
    status: WorkoutStatus.inProgress,
    exerciseRecords: [],
  }
  ```
- Navegación a `WorkoutSessionPage`

### 4.2 Pantalla: WorkoutSessionPage

**Layout:**

```
┌─────────────────────────────────────┐
│  [Back]  Pecho y Espalda  [Menu]    │
│  Ejercicio 2/5 • 00:12:34           │
├─────────────────────────────────────┤
│                                     │
│    [Imagen del Ejercicio]           │
│                                     │
│    Press de Banca                   │
│    Pecho • Peso                     │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ PLANIFICADO: 3x10 @ 60kg      │  │
│  └───────────────────────────────┘  │
│                                     │
│  Serie 1:                           │
│  ├ Reps: [10] ✓                     │
│  ├ Peso: [60] kg ✓                  │
│  └ Descanso: 01:00 ⏱                │
│                                     │
│  Serie 2:                           │
│  ├ Reps: [__]                       │
│  ├ Peso: [__] kg                    │
│  └ Descanso: 01:00                  │
│                                     │
│  Serie 3:                           │
│  ├ Reps: [__]                       │
│  ├ Peso: [__] kg                    │
│  └ Descanso: --                     │
│                                     │
│  [+ Añadir Serie Extra]             │
│                                     │
│  Notas: [___________________]       │
│                                     │
│  [Anterior]    [Completar]          │
│                                     │
└─────────────────────────────────────┘
```

**Componentes:**

1. **Header:**
   - Nombre de la rutina
   - Progreso: "Ejercicio X/Y"
   - Cronómetro total del entrenamiento

2. **Ejercicio Actual:**
   - Imagen/Video del ejercicio
   - Nombre y grupo muscular
   - Tipo de ejercicio (chip/badge)

3. **Info Planificada:**
   - Resumen compacto de lo planificado
   - Ej: "3x10 @ 60kg" o "3x12" o "45s"

4. **Registro de Series:**
   - Input para cada serie
   - Campos dinámicos según tipo de ejercicio:
     - **weight**: Reps + Peso
     - **bodyweight**: Reps
     - **time**: Duración
     - **combined**: Reps + Peso o Duración
   - Checkbox/toggle para marcar serie completada
   - Timer de descanso (cuenta regresiva automática)
   - Visual feedback: serie completada vs pendiente

5. **Series Extra:**
   - Botón para añadir series adicionales (no planificadas)

6. **Notas:**
   - Campo de texto libre para notas del ejercicio

7. **Navegación:**
   - Botón "Anterior" (volver al ejercicio previo)
   - Botón "Completar" (pasar al siguiente ejercicio)

### 4.3 Registro de Datos en Tiempo Real

**Estructura de datos en memoria:**

```dart
ExerciseRecord {
  exerciseId: String,
  sets: [
    SetRecord {
      setNumber: 1,
      reps: 10,
      weight: 60.0,
      completed: true,
      duration: null,
      restTime: 60,
      notes: null,
    },
    SetRecord {
      setNumber: 2,
      reps: 8,        // Usuario hizo menos reps
      weight: 60.0,
      completed: true,
      duration: null,
      restTime: 60,
      notes: "Costó más",
    },
    // ...
  ],
  totalTime: null,
  notes: "Buen ejercicio, sentí el músculo",
  completed: true,
}
```

**Flujo de registro:**

1. Usuario completa serie 1:
   - Ingresa reps: 10
   - Ingresa peso: 60kg
   - Presiona ✓ (checkmark)
   - Se marca `completed: true`
   - Inicia timer de descanso automáticamente

2. Timer de descanso:
   - Cuenta regresiva: 01:00 → 00:59 → ... → 00:00
   - Notificación/sonido al finalizar
   - Usuario puede saltar o pausar

3. Usuario completa serie 2:
   - Ingresa reps: 8 (hizo menos de lo planificado)
   - Ingresa peso: 60kg
   - Añade nota: "Costó más"
   - Presiona ✓

4. Usuario completa todas las series:
   - Presiona "Completar"
   - Se guarda `ExerciseRecord` en `WorkoutRecord.exerciseRecords`
   - Navega al siguiente ejercicio

### 4.4 Comparación Planificado vs Realizado

**Visual feedback durante entrenamiento:**

```
┌─────────────────────────────────┐
│ Serie 1                         │
│ ┌─────────────┬───────────────┐ │
│ │ Planificado │ Realizado     │ │
│ ├─────────────┼───────────────┤ │
│ │ 10 reps     │ 10 reps  ✓    │ │
│ │ 60 kg       │ 60 kg    ✓    │ │
│ └─────────────┴───────────────┘ │
└─────────────────────────────────┘
```

**Indicadores visuales:**
- ✓ Verde: cumplió o superó
- ↓ Amarillo: hizo menos (pero completó)
- ↑ Azul: superó lo planificado
- ✗ Rojo: no completó la serie

### 4.5 Tipos de Ejercicio en Ejecución

#### **Weight:**
```
Serie [N]:
  Reps: [número input]
  Peso: [número input] kg
  [✓ Completar]
```

#### **Bodyweight:**
```
Serie [N]:
  Reps: [número input]
  [✓ Completar]
```

#### **Time:**
```
Duración: [cronómetro] o [input manual]
[⏱ Iniciar Timer] / [⏸ Pausar] / [✓ Completar]
```

#### **Combined:**
```
Serie [N]:
  Reps: [número input] (o Duración si aplica)
  Peso: [número input] kg (opcional)
  [✓ Completar]
```

### 4.6 Finalizar Entrenamiento

**Pantalla de resumen:**

```
┌─────────────────────────────────┐
│  ¡Entrenamiento Completado! 🎉  │
│                                 │
│  Duración Total: 00:45:23       │
│  Ejercicios: 5/5 ✓              │
│  Series Totales: 18             │
│                                 │
│  ¿Cómo te sentiste?             │
│  ⭐ ⭐ ⭐ ⭐ ⭐                     │
│                                 │
│  Notas Generales:               │
│  [_____________________]        │
│                                 │
│  [Ver Detalles] [Finalizar]    │
└─────────────────────────────────┘
```

**Datos guardados:**

```dart
WorkoutRecord {
  id: UUID,
  routineId: [id],
  date: DateTime.now(),
  startTime: [timestamp inicio],
  endTime: DateTime.now(),
  totalDuration: Duration(minutes: 45, seconds: 23),
  status: WorkoutStatus.completed,
  exerciseRecords: [
    // todos los ejercicios registrados
  ],
  notes: "Buen entrenamiento, progreso notable",
  rating: 5,
}
```

**Acción:**
1. Usuario añade rating y notas
2. Presiona "Finalizar"
3. Se dispara `CompleteWorkoutEvent` en WorkoutBloc
4. UseCase `CompleteWorkout` guarda en BD
5. Navegación: regresa a home o historial
6. Feedback: "¡Entrenamiento guardado!"

---

## 5. Registro de Progreso y Comparación

### 5.1 Historial de Entrenamientos

**Pantalla: WorkoutHistoryPage**

Lista de entrenamientos ordenados por fecha:

```
┌────────────────────────────────────┐
│  Pecho y Espalda              ⭐⭐⭐⭐⭐ │
│  11 Nov 2025 • 45 min              │
│  5 ejercicios • 18 series          │
└────────────────────────────────────┘

┌────────────────────────────────────┐
│  Piernas                      ⭐⭐⭐⭐  │
│  9 Nov 2025 • 52 min               │
│  6 ejercicios • 20 series          │
└────────────────────────────────────┘
```

### 5.2 Detalle de Entrenamiento

**Pantalla: WorkoutDetailPage**

```
Pecho y Espalda
11 Nov 2025 • 45:23

┌─────────────────────────────────────┐
│ Press de Banca                      │
│ ┌───────┬──────┬──────┬──────────┐  │
│ │ Serie │ Reps │ Peso │ Estado   │  │
│ ├───────┼──────┼──────┼──────────┤  │
│ │   1   │  10  │ 60kg │ ✓ OK     │  │
│ │   2   │   8  │ 60kg │ ↓ Menos  │  │
│ │   3   │  12  │ 60kg │ ↑ Más    │  │
│ └───────┴──────┴──────┴──────────┘  │
│ Notas: Buen ejercicio              │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ Remo con Barra                      │
│ ...                                 │
└─────────────────────────────────────┘
```

### 5.3 Comparación de Progreso (Futuro)

**Feature: Análisis de Progreso**

- Gráficas de evolución de peso/reps por ejercicio
- Personal Records (PRs)
- Sugerencias automáticas basadas en historial
- Detección de estancamiento
- Recomendaciones de progresión

---

## 6. Estructura de Datos (Resumen)

### 6.1 Rutina (Planificación)

```dart
Routine {
  id: String,
  name: String,
  description: String?,
  type: RoutineType, // traditional/circuit/mixed
  difficulty: RoutineDifficulty,
  exercises: List<RoutineExercise>, // Ejercicios planificados
  tags: List<String>,
  estimatedDuration: int?,
  isTemplate: bool,
  isActive: bool,
  color: String?,
  icon: String?,
  createdAt: DateTime,
  updatedAt: DateTime,
}

RoutineExercise {
  exerciseId: String,
  order: int,
  sets: int?,
  reps: int?,
  weight: double?,
  duration: int?,
  restTime: int,
  notes: String?,
  isSuperset: bool,
  supersetGroup: String?,
}
```

### 6.2 Entrenamiento (Ejecución)

```dart
WorkoutRecord {
  id: String,
  routineId: String,
  date: DateTime,
  startTime: DateTime?,
  endTime: DateTime?,
  totalDuration: Duration?,
  status: WorkoutStatus, // planned/inProgress/completed/cancelled
  exerciseRecords: List<ExerciseRecord>, // Registros reales
  notes: String?,
  rating: int?,
}

ExerciseRecord {
  exerciseId: String,
  sets: List<SetRecord>, // Series reales
  totalTime: int?,
  notes: String?,
  completed: bool,
}

SetRecord {
  setNumber: int,
  reps: int?,
  weight: double?,
  duration: int?,
  restTime: int?,
  completed: bool,
  notes: String?,
}
```

---

## 7. Casos de Uso Principales

### 7.1 Crear Rutina

```dart
CreateRoutine(Routine routine) {
  // Validaciones
  if (routine.name.isEmpty) throw ValidationException(...);
  if (routine.exercises.isEmpty) throw ValidationException(...);
  
  // Validar cada ejercicio
  for (exercise in routine.exercises) {
    validateExerciseConfig(exercise);
  }
  
  // Guardar
  return routineRepository.createRoutine(routine);
}
```

### 7.2 Iniciar Entrenamiento

```dart
StartWorkout(String routineId) {
  // Obtener rutina
  routine = await routineRepository.getRoutineById(routineId);
  
  // Crear WorkoutRecord
  workout = WorkoutRecord(
    id: UUID(),
    routineId: routineId,
    date: DateTime.now(),
    startTime: DateTime.now(),
    status: WorkoutStatus.inProgress,
    exerciseRecords: [],
  );
  
  // Guardar
  return workoutRepository.createWorkout(workout);
}
```

### 7.3 Registrar Set

```dart
RecordSet(workoutId, exerciseId, setRecord) {
  // Obtener workout actual
  workout = await workoutRepository.getWorkoutById(workoutId);
  
  // Buscar o crear ExerciseRecord
  exerciseRecord = workout.exerciseRecords.firstWhere(
    (er) => er.exerciseId == exerciseId,
    orElse: () => ExerciseRecord(exerciseId: exerciseId, sets: []),
  );
  
  // Añadir o actualizar SetRecord
  exerciseRecord.sets.add(setRecord);
  
  // Actualizar workout
  return workoutRepository.updateWorkout(workout);
}
```

### 7.4 Completar Entrenamiento

```dart
CompleteWorkout(String workoutId) {
  // Obtener workout
  workout = await workoutRepository.getWorkoutById(workoutId);
  
  // Actualizar estado
  workout = workout.copyWith(
    endTime: DateTime.now(),
    totalDuration: DateTime.now().difference(workout.startTime!),
    status: WorkoutStatus.completed,
  );
  
  // Guardar
  return workoutRepository.updateWorkout(workout);
}
```

---

## 8. Validaciones de Negocio

### 8.1 Validaciones de Rutina

```dart
// Nombre
if (routine.name.trim().isEmpty) {
  throw ValidationException('El nombre es obligatorio');
}

// Al menos un ejercicio
if (routine.exercises.isEmpty) {
  throw ValidationException('Añade al menos un ejercicio');
}

// Validar cada ejercicio
for (exercise in routine.exercises) {
  final exerciseEntity = await exerciseRepo.getExerciseById(exercise.exerciseId);
  
  switch (exerciseEntity.type) {
    case ExerciseType.weight:
      if (exercise.sets == null || exercise.sets! <= 0) {
        throw ValidationException('Sets inválidos para ${exerciseEntity.name}');
      }
      if (exercise.reps == null || exercise.reps! <= 0) {
        throw ValidationException('Reps inválidas para ${exerciseEntity.name}');
      }
      break;
      
    case ExerciseType.bodyweight:
      if (exercise.sets == null || exercise.sets! <= 0) {
        throw ValidationException('Sets inválidos para ${exerciseEntity.name}');
      }
      if (exercise.reps == null || exercise.reps! <= 0) {
        throw ValidationException('Reps inválidas para ${exerciseEntity.name}');
      }
      break;
      
    case ExerciseType.time:
      if (exercise.duration == null || exercise.duration! <= 0) {
        throw ValidationException('Duración inválida para ${exerciseEntity.name}');
      }
      break;
      
    case ExerciseType.combined:
      if (exercise.sets == null || exercise.sets! <= 0) {
        throw ValidationException('Sets inválidos para ${exerciseEntity.name}');
      }
      if ((exercise.reps == null || exercise.reps! <= 0) && 
          (exercise.duration == null || exercise.duration! <= 0)) {
        throw ValidationException('Define reps o duración para ${exerciseEntity.name}');
      }
      break;
  }
  
  if (exercise.restTime < 0) {
    throw ValidationException('Descanso no puede ser negativo');
  }
}
```

### 8.2 Validaciones de Entrenamiento

```dart
// No permitir iniciar si ya hay un workout en progreso
activeWorkouts = await workoutRepo.getActiveWorkouts();
if (activeWorkouts.isNotEmpty) {
  throw ValidationException('Ya tienes un entrenamiento en progreso');
}

// Validar que la rutina existe
routine = await routineRepo.getRoutineById(routineId);
if (routine == null) {
  throw ValidationException('Rutina no encontrada');
}
```

---

## 9. Mejoras Futuras (Post-MVP)

### 9.1 Análisis y Sugerencias

- **Detección de progreso:**
  - Comparar últimos entrenamientos
  - Detectar si aumentó peso/reps
  - Alertas de estancamiento

- **Sugerencias automáticas:**
  - "Aumenta 2.5kg en Press de Banca"
  - "Intenta 12 reps en lugar de 10"
  - "Reduce descanso a 45s para más intensidad"

### 9.2 Plantillas y Templates

- Rutinas predefinidas (ej: "5x5 Strength", "PPL", "Full Body")
- Importar/Exportar rutinas (JSON)
- Compartir rutinas con otros usuarios

### 9.3 Superseries y Técnicas Avanzadas

- Visualización mejorada de supersets
- Drop sets, rest-pause, etc.
- Circuitos HIIT con cronómetro integrado

### 9.4 Métricas y Analytics

- Volumen total por sesión
- PRs (Personal Records) automáticos
- Gráficas de progreso por ejercicio
- Heatmap de grupos musculares trabajados
- Estimación de calorías quemadas

### 9.5 Social y Gamificación

- Logros y badges
- Streaks (días consecutivos)
- Comparación con amigos
- Challenges

---

## 10. Resumen de Implementación

### Orden de desarrollo recomendado:

1. ✅ **Base de datos y modelos** (ya implementado)
2. ✅ **Use Cases y BLoCs** (ya implementado)
3. 🔄 **UI de creación de rutina:**
   - CreateRoutinePage
   - ExerciseSelectorSheet
   - ExerciseConfigSheet
   - RoutineExerciseList
4. 🔜 **UI de ejecución:**
   - WorkoutSessionPage
   - SetRecordWidget
   - ExerciseProgressIndicator
   - RestTimerWidget
5. 🔜 **Historial y detalles:**
   - WorkoutHistoryPage
   - WorkoutDetailPage
6. 🔜 **Validaciones y feedback:**
   - Form validators
   - Error handling
   - Success/Error messages
7. 🔜 **Testing:**
   - Unit tests de validaciones
   - Widget tests de formularios
   - Integration tests del flujo completo
8. 🔜 **Pulido:**
   - Animaciones
   - Accesibilidad
   - i18n completo
   - Responsive design

---

**Próximo paso:** Implementar `CreateRoutinePage` y sus componentes.
