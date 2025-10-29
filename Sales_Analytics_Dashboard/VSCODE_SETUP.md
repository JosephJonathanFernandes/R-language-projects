# Running R Project in VS Code

## Prerequisites
1. **R** - Download from https://www.r-project.org/
2. **VS Code** - Already installed ✓
3. **VS Code Extensions** - Install these:
   - `R` by REditorSupport
   - `R Debugger` by REditorSupport
   - `Python` by Microsoft (optional, for some extensions)

## How to Install VS Code Extensions

### Option 1: Quick Install (Recommended)
Open PowerShell and run:
```powershell
code --install-extension REditorSupport.r
code --install-extension REditorSupport.r-debugger
```

### Option 2: Manual Install
1. Open VS Code
2. Press `Ctrl + Shift + X` (Extensions)
3. Search for "R" by REditorSupport
4. Click Install

## Setup Steps

### 1. Open Project in VS Code
```powershell
cd "c:\Users\Joseph\Desktop\projects\R_projects\Sales_Analytics_Dashboard"
code .
```

### 2. Configure R Path in VS Code
1. Press `Ctrl + ,` (Settings)
2. Search for "R: R Path"
3. Set it to your R installation path (usually `C:\Program Files\R\R-x.x.x\bin\R.exe`)

### 3. Run R Files

**Method 1: Using Run Button (Easiest)**
- Open any `.R` file
- Click the "Run" button (play icon) in the top right
- Or press `Ctrl + Alt + X`

**Method 2: Using Terminal**
1. Open integrated terminal: `Ctrl + ~`
2. Run R script:
   ```powershell
   Rscript scripts/create_dataset.R
   Rscript scripts/data_exploration.R
   Rscript visualizations/generate_visualizations.R
   Rscript scripts/generate_report.R
   ```

**Method 3: Using R Interactive Console**
1. Open any `.R` file
2. Press `Ctrl + Shift + S` to start R session
3. Run line by line: `Ctrl + Enter`

## Running the Dashboard

### Method 1: From VS Code Terminal
```powershell
R
```

Then in R console:
```R
setwd("c:/Users/Joseph/Desktop/projects/R_projects/Sales_Analytics_Dashboard")
source("setup.R")
```

Or directly:
```R
shiny::runApp("dashboard/app.R")
```

### Method 2: Using Rscript
```powershell
# First run setup
Rscript setup.R

# Then run dashboard
R -e "shiny::runApp('dashboard/app.R')"
```

## Quick Reference Commands

| Action | Shortcut |
|--------|----------|
| Run current line | `Ctrl + Enter` |
| Run selected code | `Ctrl + Enter` |
| Run entire file | `Ctrl + Alt + X` |
| Start R session | `Ctrl + Shift + S` |
| Open R documentation | `Ctrl + F1` |
| Show function signature | `Ctrl + Shift + Space` |

## Troubleshooting

**Issue: R command not found**
- Solution: Add R to PATH or specify full path in VS Code settings

**Issue: Shiny dashboard not opening**
- Solution: Make sure all packages are installed (run `source("setup.R")`)

**Issue: Extensions not working**
- Solution: Reload VS Code (`Ctrl + R`)

## Next Steps
1. Install R extensions in VS Code
2. Configure R path
3. Open `setup.R` and run it
4. Open `dashboard/app.R` and run the dashboard!
