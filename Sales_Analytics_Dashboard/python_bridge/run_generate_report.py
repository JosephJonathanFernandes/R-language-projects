"""Run generate_report.R via rpy2."""
from . import r_env

SCRIPT = "scripts/generate_report.R"

def main():
    r_env.run_script(SCRIPT)
    print("generate_report.R executed. Report at reports/Sales_Analytics_Report.txt")

if __name__ == "__main__":  # pragma: no cover
    main()
