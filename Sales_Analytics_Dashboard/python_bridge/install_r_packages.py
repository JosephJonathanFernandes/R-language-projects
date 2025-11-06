"""Install required R packages via Rscript fallback."""
from . import r_env

SCRIPT = "scripts/install_r_packages.R"

def main():
    r_env.run_script(SCRIPT)
    print("R packages installation script executed.")

if __name__ == "__main__":  # pragma: no cover
    main()
