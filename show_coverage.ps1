# Script Simple: Ver Resumen de Coverage
# Muestra el porcentaje de coverage por archivo

Write-Host "`n[COVERAGE REPORT] VibraAPP - Reporte de Cobertura de Tests`n" -ForegroundColor Green

if (Test-Path "coverage/lcov.info") {
    Write-Host "Analizando archivo coverage/lcov.info...`n" -ForegroundColor Cyan
    
    # Leer el archivo lcov.info
    $content = Get-Content "coverage/lcov.info" -Raw
    
    # Extraer métricas
    $files = ($content -split "SF:").Count - 1
    $linesFound = [regex]::Matches($content, "LF:(\d+)") | ForEach-Object { [int]$_.Groups[1].Value } | Measure-Object -Sum
    $linesHit = [regex]::Matches($content, "LH:(\d+)") | ForEach-Object { [int]$_.Groups[1].Value } | Measure-Object -Sum
    
    $totalLines = $linesFound.Sum
    $coveredLines = $linesHit.Sum
    $coveragePercent = if ($totalLines -gt 0) { [math]::Round(($coveredLines / $totalLines) * 100, 2) } else { 0 }
    
    # Mostrar resultados
    Write-Host "=" * 70 -ForegroundColor DarkGray
    Write-Host "  COVERAGE TOTAL" -ForegroundColor White
    Write-Host "=" * 70 -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Total de archivos analizados: $files" -ForegroundColor White
    Write-Host "  Total de lineas:               $totalLines" -ForegroundColor White
    Write-Host "  Lineas cubiertas:              $coveredLines" -ForegroundColor Green
    Write-Host "  Lineas NO cubiertas:           $($totalLines - $coveredLines)" -ForegroundColor Red
    Write-Host ""
    
    # Mostrar barra visual
    $barLength = 50
    $filledLength = [math]::Floor(($coveragePercent / 100) * $barLength)
    $bar = ("█" * $filledLength) + ("░" * ($barLength - $filledLength))
    
    $color = if ($coveragePercent -ge 80) { "Green" } elseif ($coveragePercent -ge 60) { "Yellow" } else { "Red" }
    Write-Host "  COVERAGE: " -NoNewline
    Write-Host "$coveragePercent%" -ForegroundColor $color -NoNewline
    Write-Host " [$bar]" -ForegroundColor $color
    Write-Host ""
    Write-Host "=" * 70 -ForegroundColor DarkGray
    Write-Host ""
    
    # Analizar por directorio
    Write-Host "COVERAGE POR DIRECTORIO:" -ForegroundColor Cyan
    Write-Host "-" * 70 -ForegroundColor DarkGray
    
    $sections = $content -split "end_of_record"
    $dirStats = @{}
    
    foreach ($section in $sections) {
        if ($section -match "SF:(.+?)[\r\n]") {
            $filePath = $matches[1].Trim()
            
            # Extract directory (models, services, widgets, etc)
            if ($filePath -match "lib[/\\](.+?)[/\\]") {
                $dir = $matches[1]
            } elseif ($filePath -match "lib[/\\](.+?)\.dart") {
                $dir = "lib (root)"
            } else {
                continue
            }
            
            $lf = if ($section -match "LF:(\d+)") { [int]$matches[1] } else { 0 }
            $lh = if ($section -match "LH:(\d+)") { [int]$matches[1] } else { 0 }
            
            if (-not $dirStats.ContainsKey($dir)) {
                $dirStats[$dir] = @{ LF = 0; LH = 0 }
            }
            $dirStats[$dir].LF += $lf
            $dirStats[$dir].LH += $lh
        }
    }
    
    # Mostrar estadísticas por directorio
    foreach ($dir in ($dirStats.Keys | Sort-Object)) {
        $lf = $dirStats[$dir].LF
        $lh = $dirStats[$dir].LH
        $percent = if ($lf -gt 0) { [math]::Round(($lh / $lf) * 100, 1) } else { 0 }
        
        $color = if ($percent -ge 80) { "Green" } elseif ($percent -ge 60) { "Yellow" } else { "Red" }
        
        $barLen = 30
        $filled = [math]::Floor(($percent / 100) * $barLen)
        $miniBar = ("█" * $filled) + ("░" * ($barLen - $filled))
        
        Write-Host ("  lib/{0,-20}" -f $dir) -NoNewline
        Write-Host " $percent%" -ForegroundColor $color -NoNewline
        Write-Host " [$miniBar]" -ForegroundColor $color -NoNewline
        Write-Host " ($lh/$lf lineas)" -ForegroundColor DarkGray
    }
    
    Write-Host "-" * 70 -ForegroundColor DarkGray
    Write-Host ""
    
    # Recomendaciones
    Write-Host "RECOMENDACIONES:" -ForegroundColor Yellow
    if ($coveragePercent -ge 80) {
        Write-Host "  [OK] Excelente coverage! Sigue asi." -ForegroundColor Green
    } elseif ($coveragePercent -ge 60) {
        Write-Host "  [WARN] Coverage aceptable, pero se puede mejorar." -ForegroundColor Yellow
        Write-Host "         Objetivo recomendado: 80%" -ForegroundColor Yellow
    } else {
        Write-Host "  [ALERT] Coverage bajo. Se recomienda agregar mas tests." -ForegroundColor Red
        Write-Host "          Objetivo minimo: 60%" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Para reporte HTML detallado, ejecuta:" -ForegroundColor Cyan
    Write-Host "  1. Instala lcov: choco install lcov" -ForegroundColor White
    Write-Host "  2. Genera HTML:  genhtml coverage/lcov.info -o coverage/html" -ForegroundColor White
    Write-Host "  3. Abrir:        start coverage/html/index.html" -ForegroundColor White
    Write-Host ""
    
} else {
    Write-Host "[ERROR] No se encuentra el archivo coverage/lcov.info" -ForegroundColor Red
    Write-Host "Ejecuta primero: flutter test --coverage" -ForegroundColor Yellow
}
