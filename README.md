# 🏋️ Gym Tracker

Una aplicación Flutter moderna para llevar el registro de entrenamientos en el gimnasio, construida siguiendo las mejores prácticas de desarrollo y Material Design 3.

## 📱 Características

### 🎯 Gestión de Rutinas
- **Rutinas Tradicionales**: Crea rutinas con series x repeticiones específicas
- **Rutinas de Circuito**: Diseña entrenamientos en formato de circuito
- **Organización de Ejercicios**: Ordena los ejercicios según tu preferencia
- **Duplicación de Rutinas**: Copia rutinas existentes como base para nuevas

### 📊 Registro de Entrenamientos
- **Registro Detallado**: Peso, repeticiones, series y tiempo
- **Ejercicios por Tiempo**: Soporte para ejercicios como plank, cardio, etc.
- **Cronómetro de Descanso**: Control automático de tiempos de descanso
- **Guardado Automático**: No pierdas tu progreso nunca más

### 📈 Análisis y Progreso
- **Historial Completo**: Visualiza todos tus entrenamientos anteriores
- **Comparación de Progreso**: Compara con entrenamientos previos
- **Gráficos de Rendimiento**: Visualiza tu evolución a lo largo del tiempo
- **Récords Personales**: Seguimiento automático de tus máximos

### 🎨 Diseño y Experiencia
- **Material Design 3**: Interfaz moderna y accesible
- **Modo Claro/Oscuro**: Automático según configuración del sistema
- **Responsive Design**: Optimizado para teléfonos y tablets
- **Animaciones Fluidas**: Transiciones suaves y naturales

## 🏗️ Arquitectura

### 🧩 Patrón de Arquitectura
- **Clean Architecture**: Separación clara de responsabilidades
- **BLoC Pattern**: Gestión de estado reactiva y predecible
- **Repository Pattern**: Abstracción de fuentes de datos

### 📁 Estructura del Proyecto
```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── app/
│   └── routes/              # Configuración de rutas
├── core/
│   ├── constants/           # Constantes de la aplicación
│   ├── theme/              # Configuración de temas
│   └── utils/              # Utilidades generales
├── data/
│   ├── models/             # Modelos de datos
│   ├── repositories/       # Implementaciones de repositorios
│   └── datasources/        # Fuentes de datos (local/remoto)
├── domain/
│   ├── entities/           # Entidades de negocio
│   ├── repositories/       # Interfaces de repositorios
│   └── usecases/          # Casos de uso de la aplicación
└── presentation/
    ├── bloc/              # BLoCs para gestión de estado
    ├── pages/             # Páginas principales
    └── widgets/           # Widgets reutilizables
```

### 🛠️ Tecnologías y Dependencias

#### 🎯 Gestión de Estado
- `flutter_bloc`: Implementación del patrón BLoC
- `equatable`: Comparación de objetos de forma eficiente

#### 🧭 Navegación
- `go_router`: Navegación declarativa y type-safe

#### 💾 Persistencia
- `floor`: ORM para SQLite con generación de código
- `shared_preferences`: Almacenamiento de preferencias

#### 📊 Visualización
- `fl_chart`: Gráficos interactivos y hermosos

#### 🎨 UI/UX
- `phosphor_flutter`: Íconos modernos y consistentes
- `table_calendar`: Calendario interactivo

#### 🔧 Utilidades
- `intl`: Internacionalización y formateo de fechas
- `uuid`: Generación de identificadores únicos
- `formz`: Validación de formularios

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK (versión 3.7.2 o superior)
- Dart SDK
- Android Studio / VS Code
- Git

### 🔧 Configuración del Proyecto

1. **Clonar el repositorio**
```bash
git clone <url-del-repositorio>
cd gym
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Generar código (Base de datos, modelos)**
```bash
flutter packages pub run build_runner build
```

4. **Ejecutar la aplicación**
```bash
flutter run
```

## 📋 Buenas Prácticas Implementadas

### ✅ Código
- **Sin StatefulWidgets**: Uso exclusivo de StatelessWidget + BLoC
- **Material Design 3**: Implementación completa del nuevo sistema de diseño
- **Clean Code**: Código limpio, legible y mantenible
- **Type Safety**: Uso de tipos fuertes en toda la aplicación

### 🏛️ Arquitectura
- **Separación de Responsabilidades**: Cada capa tiene una función específica
- **Inversión de Dependencias**: Interfaces definen contratos
- **Testabilidad**: Código fácil de testear con mocks

### 🎨 UI/UX
- **Consistencia Visual**: Componentes reutilizables
- **Accesibilidad**: Soporte completo para lectores de pantalla
- **Responsive**: Adaptación a diferentes tamaños de pantalla

## 🧪 Testing

### Tipos de Tests
- **Unit Tests**: Lógica de negocio y BLoCs
- **Widget Tests**: Componentes de UI
- **Integration Tests**: Flujos completos de usuario

### Ejecutar Tests
```bash
# Todos los tests
flutter test

# Tests específicos
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/
```

## 📈 Roadmap

### 🎯 Versión 1.0
- [x] Gestión básica de rutinas
- [x] Interfaz con Material Design 3
- [x] Arquitectura BLoC implementada
- [ ] Base de datos local con Floor
- [ ] Registro completo de entrenamientos
- [ ] Gráficos de progreso básicos

### 🚀 Versión 1.1
- [ ] Exportación/Importación de datos
- [ ] Cronómetro integrado
- [ ] Notificaciones de entrenamiento
- [ ] Base de datos de ejercicios pre-cargada

### 🌟 Versión 2.0
- [ ] Sincronización en la nube
- [ ] Compartir rutinas entre usuarios
- [ ] Planes de entrenamiento automáticos
- [ ] Integración con wearables

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -m 'Añade nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

## 💡 Comandos Útiles

```bash
# Análisis de código
flutter analyze

# Formatear código
dart format lib/

# Verificar dependencias obsoletas
flutter pub outdated

# Limpiar proyecto
flutter clean

# Generar código (Floor, etc.)
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

**¡Mantente fuerte! 💪**
