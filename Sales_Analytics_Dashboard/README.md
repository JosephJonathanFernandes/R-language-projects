# Sales Analytics Dashboard

## Project Overview
This project analyzes **E-commerce Sales Data** to identify trends, patterns, and opportunities for business growth. The dashboard provides interactive visualizations and key performance indicators (KPIs) to support data-driven decision-making.

## Problem Statement
E-commerce businesses need to understand their sales performance across different product categories, regions, and time periods to optimize inventory management, marketing strategies, and customer targeting. This project creates a comprehensive analytics dashboard that reveals:
- Sales trends over time
- Performance by product category
- Regional sales distribution
- Customer demographics and purchasing patterns
- Revenue and profit analysis

## Project Structure
```
Sales_Analytics_Dashboard/
├── data/                    # Sample dataset
├── scripts/                 # Data processing and analysis scripts
├── visualizations/          # Individual visualization scripts
├── dashboard/               # Interactive Shiny dashboard
├── reports/                 # Generated reports & EDA
├── tests/                   # testthat unit tests
├── python_bridge/           # Optional Python runners (R embedded)
├── requirements.txt         # Python deps for bridge
└── README.md                # Project documentation
```

## Dataset
**Synthetic E-commerce Sales Dataset** with 1000+ records containing:
- Order ID, Date, Product Category
- Customer demographics (Region, Age Group)
- Sales amount, Quantity, Profit
- Payment method, Shipping method

## Key Features
1. **Interactive Dashboard** (Shiny) with filters and drill-down capabilities
2. **Automated Pipeline** (`scripts/run_all.R`) for dataset → processing → data quality → visuals → forecasting → report → EDA HTML
3. **Advanced Analytics**: monthly sales forecasting (Prophet / ARIMA / linear fallback) and category segmentation (k-means)
4. **Data Quality** checks report (missing, outliers, duplicates, distributions)
5. **Reproducible Research** with EDA RMarkdown (`reports/EDA.Rmd`) and unit tests (`tests/testthat`)

## Required R Packages
- `shiny` - Interactive web dashboard
- `ggplot2` - Advanced visualizations
- `dplyr` - Data manipulation
- `plotly` - Interactive graphics
- `shinydashboard` - Dashboard framework
- `lubridate` - Date handling
 - `rmarkdown` (optional) - Render EDA report
 - `forecast` (optional) or `prophet` (optional) - Forecasting backends

## How to Run

### 1. Install Dependencies
```R
install.packages(c("shiny", "ggplot2", "dplyr", "plotly", "shinydashboard", "lubridate"))
```

### 2. Run the Dashboard
```R
setwd("~/Sales_Analytics_Dashboard")
shiny::runApp("dashboard/app.R")
```
### 2b. Launch Shiny from Python (Embedding R)
Requires Python 3.10+ and R installed.
```powershell
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python -m python_bridge.launch_shiny
```
If R isn't detected set `R_HOME`:
```powershell
$env:R_HOME = "C:\\Program Files\\R\\R-4.4.1"
python -m python_bridge.launch_shiny
```

### 3. Generate Visualizations
```R
source("visualizations/generate_visualizations.R")
```
### 3b. Generate Visualizations from Python
```powershell
python -m python_bridge.run_generate_visualizations
```

### 4. Full Data Workflow from Python
```powershell
python -m python_bridge.run_create_dataset
python -m python_bridge.run_data_exploration
python -m python_bridge.run_generate_report
```
Artifacts:
- data/sales_data.csv (raw synthetic)
- data/sales_data_processed.rds (processed)
- reports/Sales_Analytics_Report.txt (text report)
- visualizations/*.png (plots)

### 5. End-to-End R Pipeline (Recommended)
```powershell
# From Sales_Analytics_Dashboard folder
& "C:\Program Files\R\R-4.4.1\bin\x64\Rscript.exe" scripts\run_all.R
```
Outputs:
- `reports/Data_Quality_Summary.txt`
- `reports/sales_forecast.csv`, `visualizations/07_sales_forecast.png`
- `reports/category_clusters.csv`, `visualizations/08_category_clusters.png`
- `reports/EDA.html`

Quick open EDA (Windows PowerShell):

```powershell
Start-Process .\reports\EDA.html
```

### Windows Notes
- Ensure R installed; add `R_HOME` if detection fails.
- If `rpy2` import errors occur, verify Python and R are both 64-bit.
- Corporate proxy? Set `$env:HTTPS_PROXY` before `pip install`.

### Troubleshooting
| Issue | Resolution |
|-------|-----------|
| ImportError: rpy2 | Activate venv & run `pip install -r requirements.txt` |
| Could not locate R executable | Set `$env:R_HOME` and ensure `%R_HOME%\bin` on PATH |
| Shiny not opening | Manually visit http://localhost:8000 (fixed port) or check console |

## Reproducibility (R-first)
- Initialize `renv` to snapshot package versions:
```R
install.packages("renv")
renv::init()
renv::snapshot()
```
- Use `scripts/install_r_packages.R` to install required R packages quickly.

## Testing
Run tests (requires testthat and devtools):
```R
install.packages(c("testthat","devtools"))
devtools::test()
```

## Architecture (high-level)
```
create_dataset.R → data_exploration.R → data_quality_checks.R
	↓                         ↓
visualizations/*.R         advanced_forecasting.R
	↓                         ↓
     generate_report.R   +   reports/EDA.Rmd (render)
```

## Contact & Support
For questions or improvements, please refer to the project documentation.
