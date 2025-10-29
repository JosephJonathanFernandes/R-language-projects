# Initialize or restore renv for this repository
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos = "https://cloud.r-project.org")
}

if (file.exists("renv.lock")) {
  message("renv.lock detected; restoring packages...")
  renv::restore()
} else {
  message("No renv.lock found; initializing a minimal renv project...")
  renv::init(bare = TRUE)
}
