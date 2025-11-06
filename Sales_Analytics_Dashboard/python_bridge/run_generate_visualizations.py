"""Run visualization generation R script."""
from . import r_env

SCRIPT = "visualizations/generate_visualizations.R"

def main():
    r_env.run_script(SCRIPT)
    print("Visualization script executed. See visualizations/*.png")

if __name__ == "__main__":  # pragma: no cover
    main()
