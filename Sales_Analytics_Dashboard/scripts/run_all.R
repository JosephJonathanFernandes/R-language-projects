#!/usr/bin/env Rscript
# Orchestrator: end-to-end pipeline for Sales Analytics Dashboard

message("==== Sales Analytics Pipeline: START ====")

# Set working directory to project root (robust to how the script is launched)
args_all <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args_all, value = TRUE)
if (length(file_arg)) {
  this_file <- normalizePath(sub("^--file=", "", file_arg))
  project_root <- normalizePath(file.path(dirname(this_file), ".."))
} else {
  # Fallback: assume current working directory is the project root
  project_root <- normalizePath(getwd())
}
setwd(project_root)

message("Working directory: ", getwd())

# Ensure folders exist
dir.create("data", showWarnings = FALSE)
dir.create("reports", showWarnings = FALSE)
dir.create("visualizations", showWarnings = FALSE)

# Install required packages if missing
source("scripts/install_r_packages.R")

# 1) Create dataset
message("[1/7] Creating dataset…")
source("scripts/create_dataset.R")

# 2) Exploration & processing
message("[2/7] Exploring & processing…")
source("scripts/data_exploration.R")

# 3) Data quality checks
message("[3/7] Running data quality checks…")
source("scripts/data_quality_checks.R")

# 4) Visualizations
message("[4/7] Generating visualizations…")
source("visualizations/generate_visualizations.R")

# 5) Advanced analytics (forecasting & segmentation)
message("[5/7] Advanced analytics…")
source("scripts/advanced_forecasting.R")

# 6) Automated text report
message("[6/7] Generating report…")
source("scripts/generate_report.R")

# 7) Render EDA RMarkdown (if rmarkdown installed and pandoc available)
message("[7/7] Rendering EDA RMarkdown…")
if (requireNamespace("rmarkdown", quietly = TRUE)) {
  ensure_pandoc <- function() {
    if (rmarkdown::pandoc_available("1.12.3")) return(TRUE)
    user_p <- normalizePath(file.path(Sys.getenv("USERPROFILE"), "AppData/Local/Pandoc"), mustWork = FALSE)
    sys_p <- normalizePath("C:/Program Files/Pandoc", mustWork = FALSE)
    for (p in c(user_p, sys_p)) {
      if (file.exists(file.path(p, "pandoc.exe"))) {
        Sys.setenv(PATH = paste(p, Sys.getenv("PATH"), sep = .Platform$path.sep))
        break
      }
    }
    rmarkdown::pandoc_available("1.12.3")
  }

  if (ensure_pandoc()) {
    rmarkdown::render(
      input = "reports/EDA.Rmd",
      output_format = "html_document",
      output_file = "EDA.html",
      output_dir = "reports",
      knit_root_dir = project_root
    )
    message("✓ EDA report: reports/EDA.html")
  } else {
    message("(Skipped) Pandoc is not available. Install Pandoc or RStudio (which bundles Pandoc), then rerun.")
  }
} else {
  message("(Optional) Install 'rmarkdown' to render EDA: install.packages('rmarkdown')")
}

message("==== Sales Analytics Pipeline: DONE ====")
