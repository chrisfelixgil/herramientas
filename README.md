<div align="center">

<img width="100%" alt="Caja de Herramientas — portada" src="assets/images/toolbox.png" />

<h1>Caja de Herramientas</h1>

<p><strong>Aplicación móvil con utilidades que consumen APIs públicas.</strong></p>

<p>
<img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter 3.x">
<img src="https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white" alt="Dart 3.12">
<img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT">
<img src="https://img.shields.io/badge/platform-Android%20%7C%20Web%20%7C%20Windows-lightgrey" alt="Platform">
</p>

<p>
<a href="https://skillicons.dev"><img src="https://skillicons.dev/icons?i=flutter,dart,windows,vscode,git,github&theme=dark&perline=8" alt="Stack principal" /></a>
</p>

</div>

Aplicación desarrollada con **Flutter** como proyecto académico de la materia **Introducción al Desarrollo de Aplicaciones Móviles**. Reúne varios módulos independientes que consultan servicios web públicos desde una interfaz moderna y sencilla.

---

## Información académica

| Campo | Detalle |
|-------|--------|
| **Materia** | Introducción al Desarrollo de Aplicaciones Móviles |
| **Profesor** | Amadis Suárez Genao |
| **Alumno** | Christian Gil |
| **Matrícula** | 2012-1036 |

---

## Descripción del proyecto

**Caja de Herramientas** es una app multiplataforma que centraliza utilidades basadas en APIs REST. Desde la pantalla principal se accede a cada módulo mediante tarjetas de navegación.

Referencia de ejemplo del curso: [adamix.net/tareas/itla2](https://adamix.net/tareas/itla2/)

### Inicio

Pantalla principal con imagen de portada, mensaje de bienvenida y cuadrícula de módulos. El diseño es **responsive** y adapta el número de columnas según el ancho disponible.

### Predicción de género

Consulta el género probable de un nombre usando [Genderize.io](https://genderize.io/). Muestra nombre, resultado, probabilidad y cantidad de registros analizados.

### Predicción de edad

Estima la edad a partir de un nombre con [Agify.io](https://agify.io/). Clasifica al participante como **joven** (0–25), **adulto** (26–59) o **anciano** (60+) e ilustra el resultado con imágenes locales (`young.png`, `adult.webp`, `elder.png`).

### Universidades por país

Busca universidades escribiendo el país **en inglés** (por ejemplo: `Dominican Republic`, `Mexico`, `Spain`). Consume la API de [Universities Hipolabs](http://universities.hipolabs.com/) y muestra nombre, país, dominio y enlace web.

### Clima en RD

Muestra el clima actual de Santo Domingo usando [Open-Meteo](https://open-meteo.com/). Incluye temperatura, sensación térmica, descripción del clima y mensaje orientativo al usuario.

### Pokémon

Permite buscar un Pokémon por nombre en [PokéAPI](https://pokeapi.co/). Muestra imagen, tipos, peso, altura y reproduce su cry con `audioplayers`.

### Noticias (Remolacha.net)

Obtiene las últimas publicaciones de [Remolacha.net](https://remolacha.net/) mediante la **WordPress REST API** (`/wp-json/wp/v2/posts`). Presenta título, extracto y enlace para abrir cada noticia en el navegador.

### Acerca de

Perfil del desarrollador con foto, matrícula y enlaces de contacto (correo, GitHub y LinkedIn) mediante `url_launcher`.

---

## Funcionalidades principales

- Navegación por rutas nombradas desde `MaterialApp`.
- Consumo centralizado de APIs en `ApiService` con manejo de errores, timeout y mensajes amigables.
- Interfaz con **Material 3** y widgets reutilizables (`FeatureCard`, `ResultCard`).
- Soporte para **Android**, **Web** y **Windows**.
- Ícono de la aplicación generado desde `assets/images/perfil.jpg`.
- Prueba de widget básica en `test/widget_test.dart`.

---

## Estructura del proyecto

```text
lib/
├── main.dart                 # Punto de entrada e inicialización de locale
├── theme/
│   └── app_theme.dart        # Tema Material 3
├── models/                   # Modelos de datos (Age, Gender, Weather, etc.)
├── services/
│   └── api_service.dart      # Cliente HTTP para todas las APIs
├── screens/                  # Pantallas de cada módulo
│   ├── home_screen.dart
│   ├── gender_screen.dart
│   ├── age_screen.dart
│   ├── universities_screen.dart
│   ├── weather_screen.dart
│   ├── pokemon_screen.dart
│   ├── wordpress_news_screen.dart
│   └── about_screen.dart
└── widgets/
    ├── feature_card.dart
    └── result_card.dart

assets/images/                # Imágenes locales (portada, perfil, edades, noticias)
test/
└── widget_test.dart
```

---

## APIs utilizadas

| Módulo | Servicio | Endpoint principal |
|--------|----------|-------------------|
| Género | Genderize.io | `https://api.genderize.io/` |
| Edad | Agify.io | `https://api.agify.io/` |
| Universidades | Universities Hipolabs | `http://universities.hipolabs.com/search` |
| Clima RD | Open-Meteo | `https://api.open-meteo.com/v1/forecast` |
| Pokémon | PokéAPI | `https://pokeapi.co/api/v2/pokemon/{nombre}` |
| Noticias | Remolacha.net (WordPress) | `https://remolacha.net/wp-json/wp/v2/posts` |

---

## Requisitos previos

<p align="center">
  <a href="https://flutter.dev" title="Flutter"><img src="https://skillicons.dev/icons?i=flutter" alt="Flutter" /></a>
  <a href="https://dart.dev" title="Dart"><img src="https://skillicons.dev/icons?i=dart" alt="Dart" /></a>
  <a href="https://git-scm.com" title="Git"><img src="https://skillicons.dev/icons?i=git" alt="Git" /></a>
</p>

| Requisito | Descripción |
|-----------|-------------|
| **Flutter SDK** | Versión 3.x — [Instalación](https://docs.flutter.dev/get-started/install) |
| **Dart** | 3.12+ con null safety |
| **Plataforma** | Emulador/dispositivo Android, navegador Chrome/Edge o escritorio Windows |
| **Red** | Conexión a internet para consumir las APIs externas |

> **Nota sobre Web:** algunas APIs pueden fallar en el navegador por restricciones **CORS** o límites de uso. Para una experiencia completa se recomienda ejecutar con `flutter run -d windows` o en un dispositivo Android.

---

## Instrucciones de uso

### 1. Instalar dependencias

```bash
flutter pub get
```

### 2. Generar íconos de la app (opcional)

```bash
dart run flutter_launcher_icons
```

### 3. Ejecutar la aplicación

```bash
# Seleccionar dispositivo disponible
flutter run

# Windows (recomendado para APIs)
flutter run -d windows

# Web
flutter run -d chrome

# Android
flutter run -d android
```

### 4. Ejecutar pruebas y análisis

```bash
flutter analyze
flutter test
```

---

## Tecnologías utilizadas

<p align="center">
  <a href="https://skillicons.dev"><img src="https://skillicons.dev/icons?i=flutter,dart,windows,vscode,git,github&theme=dark&perline=8" alt="Tecnologías del proyecto" /></a>
</p>

| Tecnología | Uso |
|-----------|-----|
| **Flutter / Dart** | Framework y lenguaje de la aplicación |
| **Material 3** | Interfaz de usuario |
| **http** | Consumo de APIs REST |
| **url_launcher** | Abrir enlaces web y correo |
| **audioplayers** | Reproducir el cry del Pokémon |
| **intl** | Formato de fechas en español (módulo de clima) |
| **flutter_launcher_icons** | Generación del ícono desde `perfil.jpg` |

> Iconos generados con [Skill Icons](https://skillicons.dev/).

---

## Autor

- **Nombre:** Christian Gil
- **Matrícula:** 2012-1036
- **Correo:** 20121036@itla.edu.do
- **GitHub:** [chrisfelixgil](https://github.com/chrisfelixgil)
- **LinkedIn:** [christianfgilc](https://www.linkedin.com/in/christianfgilc/)

---

## Créditos

Proyecto desarrollado como parte de la materia **Introducción al Desarrollo de Aplicaciones Móviles**, impartida por el profesor **Amadis Suárez Genao** en el **ITLA**.

---

## Licencia

El código fuente de este repositorio se distribuye bajo la [licencia MIT](LICENSE).
