"""
Python bridge to run the existing R workflow using rpy2.

Modules:
- r_env: Environment helpers and R utilities
- run_create_dataset: Executes scripts/create_dataset.R
- run_data_exploration: Executes scripts/data_exploration.R
- run_generate_report: Executes scripts/generate_report.R
- run_generate_visualizations: Executes visualizations/generate_visualizations.R
- launch_shiny: Launches the Shiny app in dashboard/app.R
"""

__all__ = [
    "r_env",
]
