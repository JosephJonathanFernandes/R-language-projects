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
├── dashboard/              # Interactive Shiny dashboard
├── reports/                # Generated reports
└── README.md              # Project documentation
```

## Dataset
**Synthetic E-commerce Sales Dataset** with 1000+ records containing:
- Order ID, Date, Product Category
- Customer demographics (Region, Age Group)
- Sales amount, Quantity, Profit
- Payment method, Shipping method

## Key Features
1. **Interactive Dashboard** (Shiny) with filters and drill-down capabilities
2. **Multiple Visualizations** including sales trends, category analysis, and geographic distribution
3. **Data Processing** scripts for cleaning and transforming raw data
4. **Automated Reports** with key insights and recommendations

## Required R Packages
- `shiny` - Interactive web dashboard
- `ggplot2` - Advanced visualizations
- `dplyr` - Data manipulation
- `plotly` - Interactive graphics
- `shinydashboard` - Dashboard framework
- `lubridate` - Date handling

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

### 3. Generate Visualizations
```R
source("visualizations/generate_visualizations.R")
```

## Contact & Support
For questions or improvements, please refer to the project documentation.
