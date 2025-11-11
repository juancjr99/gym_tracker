# 🎨 Sistema de Color - Elite Minimalist

## Filosofía de Diseño

**Oscuro, Premium, Sobrio** con acentos elegantes que no sean agresivos.

---

## 🖤 Paleta Base (Negro/Gris)

| Color               | HEX       | Uso                                    |
| ------------------- | --------- | -------------------------------------- |
| **Background**      | `#0A0A0A` | Fondo principal de la app              |
| **Surface**         | `#1C1C1E` | Cards, tarjetas, contenedores          |
| **Surface Variant** | `#2C2C2E` | Hover states, elementos interactivos   |
| **Border**          | `#2C2C2E` | Bordes sutiles, divisores              |

---

## ⚪ Textos (Blanco/Gris)

| Color                  | HEX       | Uso                              |
| ---------------------- | --------- | -------------------------------- |
| **On Background**      | `#ECEFF1` | Textos principales, iconos       |
| **On Surface**         | `#B0B3B8` | Textos secundarios               |
| **On Surface Variant** | `#8E918F` | Textos terciarios, placeholders  |

---

## 🍷 Acentos Rojos (Muted, Terrosos, Elegantes)

### Color Principal de Acento

| Color             | HEX       | Uso                                           |
| ----------------- | --------- | --------------------------------------------- |
| **Muted Garnet**  | `#9D2933` | **PRINCIPAL** - Botones, FAB, CTAs, errores   |
| **Red Mahogany**  | `#6B1F25` | Hover/pressed states, gradientes              |
| **Crimson Taupe** | `#6E3B3B` | Detalles sutiles, highlights                  |
| **Copper Rose**   | `#9E4B4B` | Features premium (complementa el dorado)      |

### Por qué Muted Garnet?

- ✅ Cálido y elegante
- ✅ Armoniza con negro y dorado
- ✅ **No es agresivo** - sobrio y premium
- ✅ Suficientemente visible pero sutil
- ✅ Transmite exclusividad sin gritar

---

## 🏆 Dorado (SOLO Casos Especiales)

| Color                | HEX       | Uso                                      |
| -------------------- | --------- | ---------------------------------------- |
| **Gold Champagne**   | `#C5A572` | **RESERVADO** - Logros, achievements     |
| **Gold Muted**       | `#8B7355` | Degradados dorados, sombras              |

### ⚠️ Regla de Oro

El dorado **NO SE USA** en:
- ❌ Navegación
- ❌ Botones normales
- ❌ UI general
- ❌ Textos comunes

**SOLO** para:
- ✅ Logros y achievements
- ✅ Personal Records (PRs)
- ✅ Features premium exclusivas
- ✅ Celebraciones de progreso

---

## 🎨 Gradientes

### IntenseGradient - Red Elegant
```dart
LinearGradient(
  colors: [
    Color(0xFF9D2933), // Muted Garnet (primary accent)
    Color(0xFF6B1F25), // Red Mahogany (dark variant)
  ],
)
```
**Uso:** CTAs principales, botones importantes (no agresivo)

### CopperGradient - Premium Subtle
```dart
LinearGradient(
  colors: [
    Color(0xFF9E4B4B), // Copper Rose
    Color(0xFF6E3B3B), // Crimson Taupe
  ],
)
```
**Uso:** Features premium que complementan el dorado

### GoldGradient - Celebration
```dart
LinearGradient(
  colors: [
    Color(0xFFC5A572), // Gold Champagne (slightly brighter)
    Color(0xFF8B7355), // Gold Muted
  ],
)
```
**Uso:** SOLO logros, PRs, achievements

---

## 🎯 Aplicación en UI

### Botones

| Tipo              | Color de Fondo      | Color de Texto | Uso                       |
| ----------------- | ------------------- | -------------- | ------------------------- |
| **ElevatedButton**| Muted Garnet        | Blanco         | CTAs principales          |
| **FilledButton**  | Muted Garnet        | Blanco         | Acciones importantes      |
| **OutlinedButton**| Transparente        | Blanco         | Acciones secundarias      |
| **TextButton**    | Transparente        | Blanco         | Acciones terciarias       |
| **FAB**           | Muted Garnet        | Blanco         | Acción flotante principal |
| **GoldButton**    | Gold Gradient       | Negro          | **SOLO** logros/PRs       |
| **IntenseButton** | Intense Gradient    | Blanco         | CTAs destacados           |
| **CopperButton**  | Copper Gradient     | Blanco         | Premium features          |

### Navegación

| Elemento            | Color Activo      | Color Inactivo         |
| ------------------- | ----------------- | ---------------------- |
| **Indicator Line**  | Blanco (#ECEFF1)  | Transparente           |
| **Icon**            | Blanco (#ECEFF1)  | Gris (#8E918F)         |
| **Label**           | Blanco (#ECEFF1)  | Gris (#8E918F)         |

### Inputs

| Estado    | Border Color                |
| --------- | --------------------------- |
| Default   | Gris sutil (30% opacity)    |
| Focused   | Blanco (50% opacity)        |
| Error     | Muted Garnet                |

---

## 🧪 Paleta Completa en Código

```dart
// Base
darkBackground: #0A0A0A
darkSurface: #1C1C1E
darkSurfaceVariant: #2C2C2E

// Textos
darkOnBackground: #ECEFF1
darkOnSurface: #B0B3B8
darkOnSurfaceVariant: #8E918F

// Acentos Rojos (PRINCIPAL)
darkRedPrimary: #9D2933    // Muted Garnet (primary accent)
darkRedSecondary: #6B1F25  // Red Mahogany (dark variant)
darkRedTertiary: #6E3B3B   // Crimson Taupe
darkRedCopper: #9E4B4B     // Copper Rose

// Dorado (RESERVADO)
darkPrimary: #C5A572       // Gold Champagne (slightly brighter)
darkPrimaryVariant: #8B7355 // Gold Muted

// Semánticos
darkError: #8B4141    // Muted Garnet
darkSuccess: #00A86B  // Jade Green
darkWarning: #A67C52  // Bronze/Copper
darkInfo: #7A8A99     // Steel Blue
```

---

## 📊 Resultado Visual

### Antes (Inconsistente)
- ❌ Botón blanco en Workout
- ❌ FAB rojo brillante
- ❌ Gradiente dorado en Create
- ❌ Sin coherencia visual

### Ahora (Coherente)
- ✅ **Todos los botones principales:** Muted Garnet (#8B4141)
- ✅ **FAB:** Mismo Muted Garnet
- ✅ **Navegación:** Blanco sutil
- ✅ **Dorado:** SOLO en logros/achievements
- ✅ **Coherencia visual total**

---

## 💡 Guía de Uso Rápida

| Necesito...                          | Usar...                    |
| ------------------------------------ | -------------------------- |
| Botón normal (Create, Save, etc.)    | `ElevatedButton` (rojo)    |
| Botón secundario (Cancel, Back)      | `OutlinedButton` (blanco)  |
| Botón terciario (Skip, Later)        | `TextButton` (blanco)      |
| FAB principal                        | Default FAB (rojo)         |
| Botón de logro/achievement           | `GoldButton` (dorado)      |
| Botón premium feature                | `CopperButton` (cobre)     |
| Botón CTA destacado                  | `IntenseButton` (gradiente)|
| Texto destacado                      | Blanco (#ECEFF1)           |
| Icono activo                         | Blanco (#ECEFF1)           |
| Icono inactivo                       | Gris (#8E918F)             |

---

**Última actualización:** 11 Nov 2025  
**Tema actual:** Elite Minimalist (Oscuro, Premium, Sobrio)
