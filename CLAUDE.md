# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Industrial quality control mobile app built with Flutter. Connects to a Node.js/Express + MySQL backend. Designed for factory floor use with full offline support.

## Reglas de trabajo (modo seguro)

El propietario de este repo trabaja en **modo seguro**. Respeta estas reglas en todo momento:

1. **No modifiques archivos sin aprobación explícita.**
2. Antes de cambiar algo, **analiza el problema**.
3. Entrega primero un **plan** con: archivos que cambiarías, motivo del cambio, riesgo y cómo probarlo.
4. **Espera la aprobación** antes de implementar.
5. Implementa **solo un paso a la vez**.
6. Después de cada cambio, **resume exactamente qué modificaste**.
7. **No agregues dependencias nuevas** sin aprobación.
8. **No hagas refactor general.**
9. **No renombres archivos ni carpetas** salvo que se apruebe.
10. **Mantén el estilo actual del proyecto.**

# Comunicación

- Responder siempre en español.
- Ser breve y directo.
- No hacer cambios sin aprobación.
- Explicar el plan antes de implementar.
- Implementar un paso a la vez.
- Mantener la arquitectura existente.
- No introducir sobreingeniería.

## Flujo de desarrollo (Web-first)

El entorno principal de desarrollo y pruebas es **Flutter Web** (`flutter run -d chrome`),
no un teléfono o emulador Android. Android queda como validación secundaria, solo antes de
llevar algo a producción (build de APK).

Ciclo obligatorio para cada etapa:
1. Implementar la funcionalidad.
2. `flutter analyze`.
3. `flutter run -d chrome` (o el dispositivo web disponible) y validar visualmente el flujo.
4. Corregir lo que falle.
5. `flutter analyze` de nuevo.
6. Recién ahí entregar el resumen de lo hecho.

**No hacer deploy ni build de producción bajo ninguna circunstancia** — eso lo hace el
propietario del repo manualmente cuando decide.

## Commands

```bash
# Run the app in Chrome (entorno principal de desarrollo/pruebas)
flutter run -d chrome

# Run the app (debug, dispositivo por defecto)
flutter run

# Build for Android release (solo validación secundaria antes de producción)
flutter build apk --release

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Generate launcher icons (after changing pubspec.yaml flutter_launcher_icons config)
dart run flutter_launcher_icons

# Analyze code
flutter analyze
```

## Architecture

**State management:** Plain `StatefulWidget` + `setState()`. No Provider, Riverpod, or BLoC.

**Navigation:** Imperative `Navigator.push/pop`. No named routes. Entry point is now
`EmpresaSelectorPage` (elige INNPACK o FARET). INNPACK linear flow (unchanged):
`EmpresaSelectorPage → WelcomePage → HomePage → QrScannerPage → ControlFormPage → ControlMeasurementsPage`
FARET flow (ver sección "Multiempresa" abajo):
`EmpresaSelectorPage → FaretLoginPage → FaretHomePage → FaretControlFormPage`

**Layer structure under `lib/`:**
- `app/` — root `MaterialApp` widget
- `core/api/` — HTTP clients: `ApiClient`/`CatalogosApi`/`ControlApi` (INNPACK), `FaretApiClient`/`FaretAuthApi`/`FaretCatalogosApi`/`FaretControlApi` (FARET, totalmente separados)
- `core/local/` — `SharedPreferences` stores for offline data (INNPACK)
- `core/network/` — `NetworkModeService` (WiFi = online; mobile data or none = offline)
- `core/empresa/` — `EmpresaSession`, estado en memoria de la empresa activa y la sesión FARET
- `features/` — pages organized by feature (`welcome/`, `home/`, `control_form/`, `empresa_selector/`, `faret_login/`, `faret_home/`)

**Offline-first data flow (solo INNPACK):**
1. `NetworkModeService` determines mode on startup and on demand: no connectivity → offline; otherwise it does a `GET {ApiClient.baseUrl}/health` (10s timeout) and treats any failure/non-2xx as offline. Wi-Fi and mobile data are both treated as online as long as the backend health check succeeds.
2. `OfflineCatalogStore` stores the full catalog (QR contexts, parameters, wave types, lab tests, materials) fetched from the API; falls back to a seed JSON asset (`assets/catalog_seed.json`) if never synced.
3. `PendingRecordsStore` queues control records when offline; the Home page has a manual sync button that flushes the queue when connectivity is restored.
4. `CachedUsersStore` keeps the operator list available offline.

FARET no tiene (todavía) soporte offline — depende de conexión directa a la API.

**API base URL** (INNPACK) es una constante de compilación en `core/api/api_client.dart` con
default `http://localhost:3000/api`. FARET usa su propia constante en
`core/api/faret_api_client.dart` (`https://api.faret.cl/qualitycontrol`). No hay `.env` files.

## Multiempresa (INNPACK / FARET)

La app soporta dos empresas, elegidas en `EmpresaSelectorPage` (primera pantalla,
`lib/app/quality_control_app.dart` → `home: const EmpresaSelectorPage()`):

- **INNPACK**: sin cambios — mismo flujo, mismo `ApiClient` contra el backend Node.js/MySQL.
- **FARET**: login real (`FaretLoginPage`, identificador + password) contra la misma API REST
  que ya usa el Desktop FARET (`https://api.faret.cl/qualitycontrol`, `POST api/Auth/login`).
  **Mismos usuarios que el Desktop** (BD `qualitycontrolfaret`) — no hay usuarios ni tablas
  nuevas, no hay acceso directo a MySQL desde la app. Tras login exitoso aterriza en
  `FaretHomePage`, que carga catálogos reales (`cat_areas`, `cat_maquinas`, `cat_operadores`,
  `cat_defectos`, `cat_inspectores` — vía `FaretCatalogosApi`) y navega a
  `FaretControlFormPage`, que arma el payload y guarda contra `POST /api/registros-control`
  (+ evidencia opcional vía `POST /api/registros-control/{id}/evidencias`).

  **`Proceso` (`cat_procesos`) queda deliberadamente fuera de esta UI por ahora** — el backend
  ya soporta `procesoId` como campo opcional en `RegistroControlRequest` (columna nullable
  `registros_control.proceso_id`), pero no se pide en `FaretHomePage`/`FaretControlFormPage`.
  Se retomará en una actualización futura cuando el negocio defina qué procesos cargar
  (no hay una columna clara en el Excel histórico de PNC que represente ese concepto).

  **Backend FARET (fuente real, fuera de este repo):**
  `C:\Users\dcarrasco\Desktop\Proyectos\apiqualitycontrolfaret` — ASP.NET Core 8 Web API,
  MySqlConnector (sin EF), arquitectura Controller → Service → Repository, tiene su propio
  `CLAUDE.md` con reglas de modo seguro. Publica a `https://api.faret.cl/qualitycontrol` vía
  IIS (`dotnet publish ... -o ./publish`, deploy manual). El Desktop FARET
  (`qualitycontrol_desktop_faret`, hermano, no tocar salvo que se apruebe) consume la misma API.

  **Scripts SQL generados** (revisar antes de ejecutar, no corridos automáticamente):
  `docs/sql/01_alter_registros_control_proceso_id.sql` (columna `proceso_id` + FK) y
  `docs/sql/02_seed_catalogos_faret_desde_pnc.sql` (seed de catálogos maestros derivado del
  Excel histórico `docs/REG-SGI-PNC 2026 - Gestion de Calidad.xlsx`, con filas ambiguas
  comentadas como "REQUIERE REVISION").

**Separación de clientes HTTP** (misma filosofía que el Desktop, donde `DbService` e
`FaretApiClient` son rutas 100% independientes): `ApiClient` (INNPACK) y `FaretApiClient`
(FARET) son clases separadas, sin código compartido. `FaretApiClient` arma el header
`Authorization: Bearer` leyendo el token desde `EmpresaSession`.

**`EmpresaSession`** (`core/empresa/empresa_session.dart`): holder estático en memoria
(`empresa`, `faretToken`, `faretNombreUsuario`, `faretRol`). Sin persistencia a propósito —
INNPACK tampoco conserva sesión entre aperturas de la app, así que FARET replica el mismo
comportamiento (no hay "recordar usuario" todavía).

**Sin clases de modelo nuevas**: `FaretAuthApi.login()` devuelve `Map<String, dynamic>`
(`token`, `nombre`, `rol`), igual que el resto de la app no tiene clases `Usuario`/`Model`
tipadas — se mantuvo la convención existente en vez de introducir un patrón nuevo.

## Key Domain Concepts

- **Areas:** `CALIDAD` (quality lab) and `PRODUCCION` (production line) — control the form flow. PRODUCCION saves directly; CALIDAD proceeds to a measurements page.
- **ControlContext** (`features/control_form/domain/control_context.dart`) — the data object passed between pages for an active inspection session (operator, machine, product, QR data).
- **QR scanning:** Machines have QR codes that resolve to a context (parameters, materials, tests, wave types) via the API or offline catalog.

## UI Conventions

- Dark theme: background `#17212B`/`#1F2A33`, accent lime green `#8BC34A`.
- `useMaterial3: false` — Material Design 2.
- Card-based layouts with rounded corners (14–28 px radius) and glassmorphic styling.
- Failure severity colors: red `#E53935` (critical), orange `#FFB300` (major), blue `#64B5F6` (minor).

## Backend

Separate Node.js/Express + MySQL backend (not in this repo). Never commit `backend/src/config/database.js` or `.env` backend files.
