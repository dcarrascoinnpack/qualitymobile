# Quality Control

Aplicación móvil industrial desarrollada en Flutter + Node.js/MySQL para control de calidad operacional en planta productiva.

La aplicación permite trabajar en:

- Red empresa
- Datos móviles
- Offline total

con sincronización posterior de registros pendientes.

---

# Arquitectura

## Frontend

- Flutter
- SharedPreferences
- connectivity_plus
- http
- mobile_scanner

## Backend

- Node.js
- Express
- MySQL

## Comunicación

La app cliente NO consulta la base de datos directamente.

Toda la comunicación se realiza mediante API REST:

```text
API_BASE_URL
Funcionalidades principales
Operación QR por máquina
Escaneo QR industrial
Obtención de contexto operacional
Identificación automática de:
máquina
proceso
formulario
parámetros visuales
Formularios dinámicos

La app genera formularios según:

proceso
máquina
tipo de control

Incluye:

parámetros visuales
ensayos laboratorio
materiales
tipos de onda (corrugado)
Soporte ONLINE/OFFLINE

La aplicación funciona en:

Estado	Comportamiento
Red empresa	Online
Datos móviles	Offline
Sin internet	Offline
Catálogo Offline

La app descarga y almacena:

usuarios
QR contexts
parámetros visuales
materiales
tipos de onda
ensayos laboratorio

Todo queda persistido en:

SharedPreferences
Registros pendientes

Cuando no existe conectividad al backend:

los controles se guardan localmente
quedan pendientes de sincronización
se envían posteriormente al backend
Estructura del proyecto
Frontend Flutter
lib/
├── app/
├── core/
│   ├── api/
│   ├── local/
│   └── network/
├── features/
│   ├── home/
│   ├── welcome/
│   └── control_form/
Backend Node.js
backend/
├── src/
│   ├── config/
│   ├── controllers/
│   └── routes/
├── package.json
└── server.js
Endpoints principales
Catálogos
GET /api/catalogos/usuarios
GET /api/catalogos/offline
Control
GET /api/control/contexto/:codigoQr
POST /api/control/registros
Flujo operacional
Selección de área
Selección de operador
Escaneo QR
Obtención de contexto
Carga dinámica formulario
Registro control
Sincronización posterior si aplica
Procesos soportados
Corrugado
Producción
Calidad
Características técnicas
Offline-first

La app prioriza continuidad operacional incluso sin conectividad.

Persistencia local

Uso de:

SharedPreferences

para:

catálogo offline
usuarios cacheados
registros pendientes
QR Industrial

Escaneo mediante:

mobile_scanner
Seguridad
Importante

NO subir al repositorio:

backend/src/config/database.js
.env

Utilizar:

database.example.js

como referencia.

Instalación
Frontend Flutter
flutter pub get
flutter run
Backend
cd backend
npm install
node server.js
Variables importantes
Backend

Crear:

backend/.env

o configurar:

database.js

con:

host
usuario
password
base de datos
Requisitos
Flutter
Flutter SDK
Android SDK
Xcode (iOS opcional)
Backend
Node.js
MySQL Server
Estado actual
Implementado
QR máquina
Offline catálogo
Sync pendientes
Formularios dinámicos
Ensayos laboratorio
Tipos de onda
Materiales
Control visual
Persistencia offline
Pendiente/Futuro
Mejoras UX/UI
Logs sincronización
Versionado catálogo offline
Validaciones avanzadas
Dashboard administrativo
Distribución iOS
# qualitycontrol_flutter
