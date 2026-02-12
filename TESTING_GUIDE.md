# 🧪 Guía de Testing y Coverage - VibraAPP

Esta guía explica cómo ejecutar tests y ver reportes detallados de coverage con porcentajes.

---

## 📊 Ver Porcentaje de Coverage

### Opción 1: Reporte HTML Detallado (RECOMENDADO)

El reporte HTML te muestra:

- ✅ Porcentaje de coverage total
- ✅ Porcentaje por archivo
- ✅ Líneas cubiertas vs no cubiertas (con colores)
- ✅ Navegación interactiva por el código

#### Paso 1: Instalar lcov

**Windows (con Chocolatey):**

```powershell
# Si no tienes Chocolatey, instálalo primero:
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Luego instala lcov:
choco install lcov
```

**Alternativa (usando Dart):**

```powershell
dart pub global activate coverage
```

#### Paso 2: Generar el Reporte

**Forma Automática (usa el script):**

```powershell
.\generate_coverage_report.ps1
```

**Forma Manual:**

```powershell
# 1. Ejecutar tests con coverage
flutter test --coverage

# 2. Generar HTML
genhtml coverage/lcov.info -o coverage/html

# 3. Abrir en navegador
start coverage/html/index.html
```

---

### Opción 2: Resumen en Terminal

Para ver un resumen rápido en la terminal:

```powershell
# Ejecutar tests con coverage
flutter test --coverage

# Ver resumen con la herramienta de Dart
dart pub global activate coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib

# Ver estadísticas (Linux/Mac/WSL)
lcov --summary coverage/lcov.info
```

---

### Opción 3: Usar Extensión de VSCode

1. Instala la extensión **"Coverage Gutters"** en VSCode
2. Ejecuta: `flutter test --coverage`
3. En VSCode, presiona `Ctrl+Shift+P` y busca **"Coverage Gutters: Display Coverage"**
4. Verás líneas verdes (cubiertas) y rojas (no cubiertas) directamente en tu código

---

## 🎯 Comandos de Testing Más Usados

### Tests Básicos

```powershell
# Ejecutar todos los tests
flutter test

# Ejecutar con más detalles
flutter test --reporter=expanded

# Ejecutar un archivo específico
flutter test test/models/concert_test.dart

# Ejecutar tests que contengan cierto nombre
flutter test --name "Concert Model"
```

### Tests con Coverage

```powershell
# Generar coverage
flutter test --coverage

# Ver solo tests que pasaron
flutter test --coverage --reporter=compact

# Excluir archivos generados del coverage
flutter test --coverage --coverage-path=coverage/lcov.info
```

### Verificar Tests sin Ejecutar

```powershell
# Solo compilar sin ejecutar
flutter test --dry-run
```

---

## 📈 Interpretar el Reporte de Coverage

### En el Reporte HTML

Cuando abras `coverage/html/index.html` verás:

```
┌─────────────────────────────────────────────────┐
│  Directory/File        │ Line   │ Functions     │
├────────────────────────┼────────┼───────────────┤
│  lib/                  │ 72.3%  │ 68.5%         │
│  ├── models/           │ 95.2%  │ 92.1%         │
│  ├── services/         │ 61.4%  │ 58.9%         │
│  └── widgets/          │ 45.8%  │ 42.3%         │
└─────────────────────────────────────────────────┘
```

**Código de Colores:**

- 🟢 **Verde (>80%):** Bien cubierto
- 🟡 **Amarillo (50-80%):** Cobertura media
- 🔴 **Rojo (<50%):** Necesita más tests

### En el Archivo lcov.info

Puedes leer el archivo directamente:

```powershell
# Ver resumen rápido manualmente
Select-String -Path coverage/lcov.info -Pattern "^SF:" | Measure-Object
Select-String -Path coverage/lcov.info -Pattern "^LH:" | ForEach-Object { $_.Line }
```

---

## 🎨 Ejemplo de Salida del Reporte HTML

Cuando ejecutes `generate_coverage_report.ps1` y se abra el navegador, verás algo como:

```
LCOV - code coverage report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Current view: top level    Hit  Total  Coverage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Lines:                    1523  2118    71.9%
Functions:                 342   478    71.5%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Directory               Line Coverage      Bar
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
lib/models/              95.2% ████████████▌
lib/providers/           89.7% ███████████▊
lib/utils/               84.3% ██████████▊
lib/services/            61.2% ████████
lib/widgets/             45.8% ██████
```

Puedes hacer clic en cada directorio para ver qué líneas específicas están cubiertas.

---

## 🚀 Integración Continua (CI/CD)

Para automatizar en GitHub Actions:

```yaml
# .github/workflows/test.yml
name: Tests y Coverage

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.9.2"

      - name: Instalar dependencias
        run: flutter pub get

      - name: Ejecutar tests
        run: flutter test --coverage

      - name: Subir coverage a Codecov
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
          fail_ci_if_error: true
```

Esto te dará un badge en tu README:

```markdown
![Coverage](https://codecov.io/gh/tu-usuario/VibraAPP/branch/main/graph/badge.svg)
```

---

## 📊 Objetivos de Coverage Recomendados

| Categoría     | Objetivo Mínimo | Objetivo Ideal |
| ------------- | --------------- | -------------- |
| **Modelos**   | 80%             | 95%            |
| **Servicios** | 70%             | 85%            |
| **Providers** | 75%             | 90%            |
| **Utils**     | 80%             | 95%            |
| **Widgets**   | 60%             | 80%            |
| **TOTAL**     | 70%             | 85%            |

---

## 💡 Tips para Mejorar el Coverage

### 1. Identifica archivos sin tests

```powershell
# Listar archivos de lib/
Get-ChildItem -Path lib -Recurse -Filter *.dart | Select-Object Name

# Comparar con archivos de test/
Get-ChildItem -Path test -Recurse -Filter *_test.dart | Select-Object Name
```

### 2. Enfócate en código crítico primero

Prioridad alta:

- ✅ Lógica de negocio (models, services)
- ✅ Manejo de errores
- ✅ Transformaciones de datos

Prioridad media:

- ⚠️ Providers y estados
- ⚠️ Utils y helpers

Prioridad baja:

- 📱 Widgets simples (cosmética)
- 📱 Constantes y configuraciones

### 3. Usa el reporte HTML para encontrar gaps

1. Abre `coverage/html/index.html`
2. Haz clic en archivos con coverage bajo (<60%)
3. Verás las líneas rojas (no cubiertas)
4. Escribe tests para esas líneas

---

## 🐛 Troubleshooting

### Problema: "lcov not found"

**Solución:**

```powershell
choco install lcov
# O usa la alternativa de Dart
dart pub global activate coverage
```

### Problema: "Coverage folder is empty"

**Solución:**

```powershell
# Asegúrate de ejecutar con --coverage
flutter test --coverage

# Verifica que se creó el archivo
ls coverage/
```

### Problema: "Tests failing"

**Solución:**

```powershell
# Ejecuta tests con más detalles para ver errores
flutter test --reporter=expanded

# Ejecuta un test específico para debuggear
flutter test test/path/to/failing_test.dart -r expanded
```

---

## 📚 Recursos Adicionales

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [LCOV Documentation](http://ltp.sourceforge.net/coverage/lcov.php)
- [Coverage Package](https://pub.dev/packages/coverage)

---

**💡 Tip Final:** Ejecuta `.\generate_coverage_report.ps1` después de cada sesión de desarrollo para mantener el coverage alto y detectar problemas temprano.
