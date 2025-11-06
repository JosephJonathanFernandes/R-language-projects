required_packages <- c(
  "shiny",
  "shinydashboard",
  "ggplot2",
  "dplyr",
  "plotly",
  "lubridate",
  "DT",
  # Optional but recommended for reports/EDA and forecasting
  "rmarkdown",
  "forecast"
  # "prophet" # optional; often requires extra setup
)

installed <- rownames(installed.packages())
to_install <- setdiff(required_packages, installed)

if (length(to_install) > 0) {
  message("Installing missing R packages: ", paste(to_install, collapse=", "))
  install.packages(to_install, repos = "https://cloud.r-project.org")
} else {
  message("All required R packages already installed.")
}

message("✓ R package check complete.")
