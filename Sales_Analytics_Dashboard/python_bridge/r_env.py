"""r_env.py
Utilities to embed R inside Python via rpy2 for the Sales Analytics Dashboard.

Prerequisites:
  - R installed and on PATH (or set R_HOME env var)
  - Python package rpy2 installed

Functions:
  init() -> None: Validates R and rpy2 availability.
  source_r(path: str) -> None: Sources an R script.
  call(expr: str): Evaluate arbitrary R expression and return result converted.
  run_script(path: str): Convenience to source then return TRUE.
  start_shiny(app_path: str, port: int = 8000): Launch Shiny app non-blocking.

Edge cases handled:
  - Missing R executable
  - rpy2 import errors
  - Windows path normalization
"""

from __future__ import annotations

import os
import shutil
import subprocess
import sys
import threading
import time
from pathlib import Path
from typing import Any

_initialized = False
_use_rpy2 = False

def init() -> None:
    global _initialized
    if _initialized:
        return
    global _use_rpy2
    try:
        import rpy2  # noqa: F401
        from rpy2 import robjects  # noqa: F401
        _use_rpy2 = True
    except Exception:
        # Fallback to Rscript-only mode (no rpy2). Still useful for running scripts & Shiny.
        _use_rpy2 = False

    # Verify R is available
    r_exe = _find_r_executable()
    if not r_exe:
        raise RuntimeError(
            "Could not locate R executable. Ensure R is installed and R_HOME/PATH is set."
        )
    _initialized = True

def _find_r_executable() -> str | None:
    # On Windows, R executable often is R.exe inside R_HOME/bin/x64 or bin
    candidates = []
    r_home = os.environ.get("R_HOME")
    if r_home:
        candidates.extend([
            os.path.join(r_home, "bin", "R.exe"),
            os.path.join(r_home, "bin", "x64", "R.exe"),
        ])
    # Fallback to PATH search
    candidates.append("R")
    for c in candidates:
        if shutil.which(c) if c == "R" else Path(c).exists():
            return c if c == "R" else str(Path(c))
    return None

def source_r(path: str) -> None:
    init()
    # Ensure working directory to project root so relative paths in R scripts work
    project_root = Path(__file__).resolve().parent.parent
    os.chdir(project_root)
    r_path = Path(path)
    if not r_path.exists():
        raise FileNotFoundError(f"R script not found: {r_path}")

    if _use_rpy2:
        from rpy2.robjects.packages import importr
        base = importr("base")
        base.source(str(r_path))
    else:
        # Run via Rscript directly
        rscript = _resolve_rscript()
        proc = subprocess.run([rscript, str(r_path)], cwd=project_root, capture_output=True, text=True)
        if proc.returncode != 0:
            raise RuntimeError(f"Rscript failed (code {proc.returncode})\nSTDOUT:\n{proc.stdout}\nSTDERR:\n{proc.stderr}")
        else:
            sys.stdout.write(proc.stdout)
            sys.stderr.write(proc.stderr)

def call(expr: str) -> Any:
    init()
    if not _use_rpy2:
        raise RuntimeError("call() requires rpy2; not available in fallback mode.")
    from rpy2.robjects import r
    return r(expr)

def run_script(path: str) -> None:
    source_r(path)
    return None

def start_shiny(app_path: str, port: int = 8000) -> threading.Thread:
    """Start Shiny app from Python in a background thread.
    Returns the thread; prints URL once started.
    """
    init()
    app_full = Path(app_path).resolve()
    if not app_full.exists():
        raise FileNotFoundError(f"Shiny app.R not found: {app_full}")
    project_root = Path(__file__).resolve().parent.parent

    def _run():
        # Use Rscript to launch Shiny; rely on app.R calling shinyApp()
        cmd = [_resolve_rscript(), str(app_full)]
        proc = subprocess.Popen(
            cmd,
            cwd=str(app_full.parent),  # set wd to dashboard folder so ../data resolves
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )
        # Monitor output for port info
        while True:
            line = proc.stdout.readline()
            if not line:
                if proc.poll() is not None:
                    break
                time.sleep(0.2)
                continue
            sys.stdout.write("[shiny] " + line)
            sys.stdout.flush()
        rc = proc.wait()
        if rc != 0:
            print(f"Shiny app exited with code {rc}")

    t = threading.Thread(target=_run, daemon=True)
    t.start()
    print(f"Shiny launching (thread). Check console. If running, visit http://localhost:{port}")
    return t

def _resolve_rscript() -> str:
    # Prefer Rscript.exe from R_HOME if present; else fallback to PATH
    r_home = os.environ.get("R_HOME")
    candidates = []
    if r_home:
        candidates.append(str(Path(r_home) / "bin" / "x64" / "Rscript.exe"))
        candidates.append(str(Path(r_home) / "bin" / "Rscript.exe"))
    candidates.append("Rscript")
    for c in candidates:
        if c == "Rscript":
            p = shutil.which(c)
            if p:
                return p
        else:
            if Path(c).exists():
                return c
    raise RuntimeError("Could not locate Rscript. Ensure R is installed and R_HOME/PATH set.")
