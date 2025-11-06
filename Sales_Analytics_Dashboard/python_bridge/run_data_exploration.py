"""Run data_exploration.R via rpy2 and return processed RDS path."""
from . import r_env

SCRIPT = "scripts/data_exploration.R"

def main():
    r_env.run_script(SCRIPT)
    print("data_exploration.R executed. Processed file: data/sales_data_processed.rds")

if __name__ == "__main__":  # pragma: no cover
    main()
