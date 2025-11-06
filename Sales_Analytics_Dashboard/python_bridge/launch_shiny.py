"""Launch the Shiny dashboard app (dashboard/app.R) from Python."""
from pathlib import Path
from . import r_env

APP = "dashboard/app.R"

def main():
    r_env.start_shiny(APP, port=8000)
    print("Shiny app launch initiated. Press Ctrl+C to exit.")
    # Keep main thread alive
    try:
        while True:
            pass
    except KeyboardInterrupt:  # pragma: no cover
        print("\nExiting.")

if __name__ == "__main__":  # pragma: no cover
    main()
