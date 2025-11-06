"""Run the R script create_dataset.R from Python.

Usage:
    python -m python_bridge.run_create_dataset
"""
from pathlib import Path
from . import r_env

SCRIPT = "scripts/create_dataset.R"

def main():
    r_env.run_script(SCRIPT)
    print("create_dataset.R executed.")

if __name__ == "__main__":  # pragma: no cover
    main()
