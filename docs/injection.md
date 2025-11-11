## Inyección de Dependencias (GetIt + Injectable)

### ¿Qué es la inyección de dependencias (DI)?
La inyección de dependencias (Dependency Injection) es un patrón que separa la creación de dependencias de su uso. En lugar de construir objetos (repositorios, use cases, BLoCs) dentro de las clases que los usan, se "inyectan" desde un contenedor central. Esto mejora la testabilidad, la mantenibilidad y facilita reemplazar implementaciones (por ejemplo, repositorio de prueba).

### ¿Por qué usamos GetIt + Injectable?
- GetIt es un contenedor de servicios (service locator) sencillo y ampliamente usado en Flutter.
- Injectable es una capa encima de GetIt que permite usar anotaciones (`@injectable`, `@lazySingleton`, `@module`) y genera el código para registrar las dependencias automáticamente.

Esto evita registrar manualmente decenas de servicios y mantiene el wiring del proyecto consistente.

---

## Archivos clave que añadimos/edité
- `lib/injection/injection.dart` — punto de entrada de la configuración DI. Contiene `getIt` y la función `configureDependencies()` que llama al código generado.
- `lib/injection/database_module.dart` — módulo con `@module` que expone la creación del `AppDatabase` y los DAOs (con `@preResolve` para inicializar la DB asíncronamente).
- `lib/injection/injection.config.dart` — archivo generado por `injectable`/`build_runner`. NO editar a mano.
- `lib/bootstrap.dart` — modifiqué para llamar `await configureDependencies()` antes de `runApp()`.
- Anotaciones `@injectable` / `@LazySingleton` añadidas en:
  - `lib/domain/usecases/*.dart`
  - `lib/data/repositories/*_repository_impl.dart`
  - `lib/presentation/bloc/*/*_bloc.dart` (para que GetIt pueda proveerlos)

También se generó:
- `lib/injection/injection.config.dart` (resultado del build_runner)
- Archivos generados de Floor: `lib/data/datasources/local/app_database.g.dart`

---

## ¿Cómo funciona (alto nivel)?
1. Anotas tus clases con `@injectable`, `@LazySingleton(as: Interface)` o defines un `@module` para factories complejas.
2. Ejecutas `build_runner` (el generador) que crea `injection.config.dart` con todas las llamadas necesarias para registrar servicios en GetIt.
3. Llamas `configureDependencies()` al iniciar la app (ej.: en `bootstrap.dart`) para que GetIt instancie y registre todo (incluido `AppDatabase` asíncrono).
4. Usas `getIt<T>()` o inyectas dependencias automáticamente (por ejemplo, al resolver un BLoC desde GetIt) en tu UI o tests.

---

## Cómo inicializar DI
En `lib/injection/injection.dart` hay una función generada `configureDependencies()`:

```dart
// lib/injection/injection.dart
final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => await getIt.init();
```

Y en `lib/bootstrap.dart` se llama antes de `runApp()`:

```dart
await configureDependencies();
runApp(await builder());
```

Eso garantiza que todas las dependencias (DB, DAOs, repositorios, use cases y BLoCs) estén disponibles cuando la UI inicie.

---

## Cómo obtener una dependencia en tiempo de ejecución
Puedes solicitar cualquier dependencia registrada con `getIt<T>()`:

```dart
import 'package:gym_tracker/injection/injection.dart';

final routineBloc = getIt<RoutineBloc>();
```

En widgets es preferible usar `BlocProvider.value(value: getIt<RoutineBloc>())` o proveer la instancia desde un `MultiBlocProvider`.

---

## Añadir una nueva clase para inyectar
1. Añade la anotación adecuada:
   - `@injectable` para factories
   - `@LazySingleton(as: SomeInterface)` para singletons que implementan una interfaz
   - `@module` + métodos `@singleton` o `@preResolve` para factories con lógica (ej. DB async)

2. Ejecuta el generador:

En este proyecto recomendamos usar `fvm` para asegurar la versión correcta de Flutter. Ejecuta (desde la raíz del proyecto):

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Si `fvm` no está disponible en tu PATH, puedes usar directamente:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

El flag `--delete-conflicting-outputs` ayuda a evitar problemas con archivos generados previamente.

---

## Uso correcto de `fvm` y notas sobre el entorno
- Si tu flujo de trabajo usa `fvm`, siempre corre los comandos de Flutter con `fvm flutter ...` para usar la versión lockeada en el proyecto.
- Si tu terminal devuelve `zsh: command not found: fvm`, instala FVM globalmente (`dart pub global activate fvm`) o ejecuta el comando sin `fvm` si tu entorno local ya tiene la versión correcta de Flutter.

---

## Errores comunes y cómo resolverlos
- `Target of URI doesn't exist: 'injection.config.dart'` → significa que no ejecutaste `build_runner` o falló. Ejecuta el comando de build_runner (ver más arriba).
- `The method 'init' isn't defined for the type 'GetIt'` → ocurrió cuando `injection.config.dart` no estaba presente y `configureDependencies()` llamaba a `getIt.init()` erróneamente. Solución: re-ejecutar `build_runner` y usar la firma `Future<void> configureDependencies() async => await getIt.init();` (tal como está en el repo).
- Warning del analyzer al ejecutar `build_runner` (ej.: versión del analyzer) → normalmente no bloquea la generación, pero si necesitas eliminar advertencias, añade/actualiza `dev_dependencies: analyzer: ^9.0.0` en `pubspec.yaml` y corre `flutter pub upgrade`.

---

## Ejemplos prácticos
- Registrar un repositorio como singleton (ya hecho en el repo):

```dart
@LazySingleton(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  ExerciseRepositoryImpl(this._exerciseDao);
}
```

- Registrar una clase simple:

```dart
@injectable
class MyService {
  MyService(this._repo);
  final SomeRepository _repo;
}
```

Luego ejecutas `build_runner` y `MyService` quedará disponible via `getIt<MyService>()`.

---

## Ubicaciones importantes en el repositorio
- `lib/injection/injection.dart` — inicialización y `getIt`
- `lib/injection/injection.config.dart` — generado
- `lib/injection/database_module.dart` — módulo DB + DAOs
- `lib/bootstrap.dart` — donde llamamos `await configureDependencies()` antes de `runApp()`
- `lib/presentation/bloc` — BLoCs anotados para inyección
- `lib/domain/usecases` — use cases anotados para inyección
- `lib/data/repositories` — repositorios anotados con `@LazySingleton`

---

## Resumen rápido
- GetIt es el contenedor, Injectable automatiza el registro.
- Anota con `@injectable`/`@LazySingleton`/`@module`, ejecuta `build_runner`.
- Inicializa en `bootstrap.dart` con `await configureDependencies()`.
- Usa `getIt<T>()` desde UI o tests.

Si quieres, puedo ahora:
- A) Añadir un pequeño ejemplo en `lib/example/` que muestre `getIt` en acción, o
- B) Empezar a crear la primera pantalla `RoutinesListPage` usando `RoutineBloc` desde `getIt`.

Dime cuál prefieres y continúo.