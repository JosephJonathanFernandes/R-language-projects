# Main Project Setup and Execution Script
# Run this script to set up the entire project

cat("
================================================================================
        SALES ANALYTICS DASHBOARD - PROJECT SETUP
================================================================================\n")

# Check and install required packages
packages <- c("shiny", "shinydashboard", "ggplot2", "dplyr", "plotly", "lubridate")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]

if(length(new_packages) > 0) {
  cat("\n📦 Installing required packages...\n")
  install.packages(new_packages)
}

cat("✓ All packages loaded successfully!\n")

# Create dataset
cat("\n📊 Creating synthetic dataset...\n")
source("scripts/create_dataset.R")

# Process and explore data
cat("\n🔍 Processing and exploring data...\n")
source("scripts/data_exploration.R")

# Generate visualizations
cat("\n📈 Generating visualizations...\n")
source("visualizations/generate_visualizations.R")

# Generate report
cat("\n📄 Generating report...\n")
source("scripts/generate_report.R")

cat("\n
================================================================================
        SETUP COMPLETE! 🎉
================================================================================

PROJECT STRUCTURE:
  data/                 - Contains sales dataset
  scripts/              - Data processing and analysis scripts
  visualizations/       - Static visualizations (PNG files)
  dashboard/            - Interactive Shiny dashboard
  reports/              - Generated reports

NEXT STEPS:
1. To run the interactive dashboard:
   setwd('~')  # Set to project directory
   source('dashboard/app.R')
   shiny::runApp('dashboard/app.R')

2. To view generated visualizations:
   - Check visualizations/ folder for PNG files

3. To view the report:
   - Open reports/Sales_Analytics_Report.txt

4. To explore the data:
   - Open and run individual scripts in scripts/ folder

================================================================================
")
