#!/usr/bin/env Rscript
# Quick Start Script - Run this from VS Code Terminal

cat("
╔══════════════════════════════════════════════════════════════════════════════╗
║         Sales Analytics Dashboard - VS Code Quick Start                      ║
╚══════════════════════════════════════════════════════════════════════════════╝
\n")

# Get current directory
wd <- getwd()
cat("📁 Working Directory:", wd, "\n\n")

# Menu
cat("What would you like to do?\n")
cat("1. Full Setup (Create data + visualizations + report)\n")
cat("2. Create Dataset Only\n")
cat("3. Data Exploration Only\n")
cat("4. Generate Visualizations Only\n")
cat("5. Generate Report Only\n")
cat("6. Run Dashboard\n")
cat("7. Install Packages\n")
cat("0. Exit\n\n")

choice <- readline("Enter your choice (0-7): ")

switch(choice,
  "1" = {
    cat("\n📊 Running Full Setup...\n")
    source("setup.R")
  },
  "2" = {
    cat("\n📊 Creating Dataset...\n")
    source("scripts/create_dataset.R")
    cat("✓ Done!\n")
  },
  "3" = {
    cat("\n🔍 Data Exploration...\n")
    source("scripts/data_exploration.R")
    cat("✓ Done!\n")
  },
  "4" = {
    cat("\n📈 Generating Visualizations...\n")
    source("visualizations/generate_visualizations.R")
    cat("✓ Done!\n")
  },
  "5" = {
    cat("\n📄 Generating Report...\n")
    source("scripts/generate_report.R")
    cat("✓ Done!\n")
  },
  "6" = {
    cat("\n🚀 Starting Dashboard...\n")
    cat("Dashboard will open in your default browser at http://127.0.0.1:XXXX\n\n")
    shiny::runApp("dashboard/app.R")
  },
  "7" = {
    cat("\n📦 Installing Required Packages...\n")
    packages <- c("shiny", "shinydashboard", "ggplot2", "dplyr", "plotly", "lubridate")
    install.packages(packages)
    cat("✓ All packages installed!\n")
  },
  "0" = {
    cat("Goodbye!\n")
  },
  {
    cat("Invalid choice!\n")
  }
)
