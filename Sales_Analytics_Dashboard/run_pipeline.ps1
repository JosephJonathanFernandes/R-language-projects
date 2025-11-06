# PowerShell helper script to run the full Sales Analytics pipeline and launch Shiny
param(
    [switch]$SkipEDA = $false,
    [switch]$LaunchShiny = $false,
    [string]$RscriptPath = "C:\\Program Files\\R\\R-4.4.1\\bin\\x64\\Rscript.exe"
)

function Invoke-Rscript([string]$script, [string[]]$args) {
    if (-not (Test-Path $RscriptPath)) {
        Write-Error "Rscript not found at $RscriptPath. Provide -RscriptPath or add to PATH."
        exit 1
    }
    & $RscriptPath $script @args
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Rscript failed for $script (exit $LASTEXITCODE)"
        exit $LASTEXITCODE
    }
}

# Ensure we run from this script's folder
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "[1/2] Running end-to-end R pipeline..." -ForegroundColor Cyan
Invoke-Rscript "scripts/run_all.R"

if (-not $SkipEDA) {
    Write-Host "EDA HTML (if rmarkdown is available) should be at reports/EDA.html" -ForegroundColor Green
}

if ($LaunchShiny) {
    Write-Host "[2/2] Launching Shiny dashboard..." -ForegroundColor Cyan
    # Use Python bridge for reliable Rscript discovery & logging
    if (Test-Path ".venv\Scripts\Activate.ps1") { . .venv\Scripts\Activate.ps1 }
    python -m python_bridge.launch_shiny
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Python bridge failed to start Shiny (exit $LASTEXITCODE). Falling back to Rscript..."
        if (-not (Test-Path $RscriptPath)) {
            Write-Error "Rscript not found at $RscriptPath. Provide -RscriptPath or add to PATH."
            exit 1
        }
        & $RscriptPath -e "shiny::runApp('dashboard/app.R', port=8000)"
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to launch Shiny via Rscript (exit $LASTEXITCODE)."
            exit $LASTEXITCODE
        }
    }
    Write-Host "Shiny running at http://localhost:8000 (fixed port)." -ForegroundColor Green
}

Write-Host "Pipeline completed. Outputs under reports/ and visualizations/." -ForegroundColor Green
if (-not $SkipEDA) {
    $edaPath = Join-Path $scriptDir 'reports/EDA.html'
    if (Test-Path $edaPath) {
        Write-Host "Open EDA report with: Start-Process '$edaPath'" -ForegroundColor Yellow
    }
}
