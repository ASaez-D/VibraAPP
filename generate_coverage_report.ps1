# Script para generar reporte de coverage con porcentajes detallados
# Para VibraAPP - Flutter Project

Write-Host "[TEST] Ejecutando tests con coverage..." -ForegroundColor Cyan
flutter test --coverage

if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] Tests completados exitosamente" -ForegroundColor Green
    
    # Verificar si existe lcov
    $lcovInstalled = Get-Command genhtml -ErrorAction SilentlyContinue
    
    if ($lcovInstalled) {
        Write-Host "[REPORT] Generando reporte HTML de coverage..." -ForegroundColor Cyan
        genhtml coverage/lcov.info -o coverage/html
        
        Write-Host "[OK] Reporte HTML generado en coverage/html/" -ForegroundColor Green
        Write-Host "[WEB] Abriendo reporte en el navegador..." -ForegroundColor Cyan
        Start-Process "coverage/html/index.html"
    } else {
        Write-Host "[WARN] lcov no esta instalado." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Opciones para instalar lcov en Windows:" -ForegroundColor Yellow
        Write-Host "1. Con Chocolatey: choco install lcov" -ForegroundColor White
        Write-Host "2. Con Dart: dart pub global activate coverage" -ForegroundColor White
        Write-Host ""
        Write-Host "[INFO] Usando herramienta de Dart alternativa..." -ForegroundColor Cyan
        
        # Intentar usar la herramienta de Dart
        dart pub global activate coverage
        
        Write-Host "[REPORT] Generando archivo lcov.info..." -ForegroundColor Cyan
        dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
        
        Write-Host ""
        Write-Host "[OK] Archivo de coverage generado: coverage/lcov.info" -ForegroundColor Green
        Write-Host "[TIP] Para reporte HTML visual, instala lcov" -ForegroundColor Yellow
    }
} else {
    Write-Host "[ERROR] Los tests fallaron. Revisa los errores antes de generar el reporte." -ForegroundColor Red
}

Write-Host ""
Write-Host "[INFO] Archivos en directorio coverage:" -ForegroundColor Cyan
Get-ChildItem coverage -ErrorAction SilentlyContinue | Format-Table Name, Length, LastWriteTime
