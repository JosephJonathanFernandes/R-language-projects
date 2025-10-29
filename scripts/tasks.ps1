param(
  [Parameter(Position=0)] [ValidateSet("Init-Renv","Lint","Style","Run-Dashboard","Help")] [string] $Task = "Help",
  [string] $ProjectPath = "Sales_Analytics_Dashboard"
)

function Invoke-RScript {
  param([string]$Expr)
  $cmd = "Rscript -e \"$Expr\""
  Write-Host "Running: $cmd" -ForegroundColor Cyan
  & powershell -NoProfile -Command $cmd
  if ($LASTEXITCODE -ne 0) { throw "Rscript failed: $Expr" }
}

function Init-Renv {
  if (Test-Path -Path "renv.lock") {
    Write-Host "renv.lock found; restoring packages..." -ForegroundColor Green
    Invoke-RScript 'install.packages("renv", repos="https://cloud.r-project.org"); renv::restore()'
  } else {
    Write-Host "Initializing renv for the repo..." -ForegroundColor Green
    Invoke-RScript 'install.packages("renv", repos="https://cloud.r-project.org"); renv::init(bare=TRUE)'
  }
}

function Lint {
  Invoke-RScript 'if (!requireNamespace("lintr", quietly=TRUE)) install.packages("lintr"); res <- lintr::lint_dir("."); print(res); if (length(res) > 0) quit(status=1)'
}

function Style {
  Invoke-RScript 'if (!requireNamespace("styler", quietly=TRUE)) install.packages("styler"); styler::style_dir(".")'
}

function Run-Dashboard {
  $appPath = Join-Path $ProjectPath 'dashboard'
  if (!(Test-Path $appPath)) { throw "Dashboard folder not found at '$appPath'" }
  Invoke-RScript "shiny::runApp('$appPath', launch.browser=TRUE)"
}

switch ($Task) {
  "Init-Renv" { Init-Renv }
  "Lint" { Lint }
  "Style" { Style }
  "Run-Dashboard" { Run-Dashboard }
  default {
    Write-Host "Available tasks:" -ForegroundColor Yellow
    Write-Host "  Init-Renv        Initialize or restore renv packages"
    Write-Host "  Lint             Run lintr across the repository"
    Write-Host "  Style            Apply styler formatting"
    Write-Host "  Run-Dashboard    Launch the Shiny app in <ProjectPath>/dashboard"
    Write-Host "Usage: pwsh .\\scripts\\tasks.ps1 <Task> [-ProjectPath 'MyProject']"
  }
}
