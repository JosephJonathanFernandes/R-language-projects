###############################################################
# CONFIGURATION FILE
# Application-wide settings and constants
###############################################################

#' Application Configuration
#' 
#' This file contains all configurable parameters for the MNIST Shiny app.
#' Modify these values to customize behavior without changing core code.

# ============================================================
# DATA SETTINGS
# ============================================================

# Training data settings
TRAIN_SAMPLE_SIZE <- 60000  # Full MNIST training set
TEST_SAMPLE_SIZE <- 10000   # Full MNIST test set

# Subset sizes for faster training (useful for testing)
SVM_TRAIN_SIZE <- 10000     # SVM trains on subset for speed
RF_TRAIN_SIZE <- 10000      # Random Forest trains on subset
KNN_TRAIN_SIZE <- 5000      # kNN reference set size

# Visualization settings
VIZ_SAMPLE_SIZE <- 2000     # Samples for PCA/UMAP/t-SNE
EVAL_DEFAULT_SIZE <- 500    # Default evaluation sample size
EVAL_MIN_SIZE <- 100        # Minimum evaluation samples
EVAL_MAX_SIZE <- 2000       # Maximum evaluation samples

# ============================================================
# MODEL SETTINGS
# ============================================================

# CNN Architecture
CNN_FILTERS <- 32           # Number of convolutional filters
CNN_KERNEL_SIZE <- 3        # Convolution kernel size
CNN_POOL_SIZE <- 2          # Max pooling size
CNN_DENSE_UNITS <- 128      # Dense layer units
CNN_EPOCHS <- 1             # Training epochs (increase for better accuracy)
CNN_BATCH_SIZE <- 128       # Batch size for training
CNN_VALIDATION_SPLIT <- 0.1 # Validation split ratio

# kNN Settings
KNN_K <- 3                  # Number of neighbors

# Random Forest Settings
RF_NTREE <- 100             # Number of trees

# SVM Settings (using e1071 defaults)
# SVM uses radial basis kernel by default

# ============================================================
# UI SETTINGS
# ============================================================

# Canvas settings
CANVAS_WIDTH <- 300         # Drawing canvas width
CANVAS_HEIGHT <- 300        # Drawing canvas height

# Image display
IMAGE_PLOT_HEIGHT <- "300px"
VIZ_PLOT_HEIGHT <- "500px"
FILTER_PLOT_HEIGHT <- "300px"

# Slider ranges
IMAGE_SLIDER_MIN <- 1
IMAGE_SLIDER_MAX <- 60000
IMAGE_SLIDER_DEFAULT <- 1

FILTER_SLIDER_MIN <- 1
FILTER_SLIDER_MAX <- 32
FILTER_SLIDER_DEFAULT <- 1

# ============================================================
# VISUALIZATION SETTINGS
# ============================================================

# Plot aesthetics
POINT_ALPHA <- 0.6          # Transparency for scatter plots
POINT_SIZE <- 1             # Size for scatter points

# Color schemes
HEATMAP_LOW_COLOR <- "blue"
HEATMAP_HIGH_COLOR <- "red"
GRAYSCALE_COLORS <- 255     # Number of gray levels

# ============================================================
# PERFORMANCE SETTINGS
# ============================================================

# Computation settings
ENABLE_GPU <- FALSE         # Enable GPU acceleration (if available)
PARALLEL_CORES <- 1         # Number of cores for parallel processing

# Memory management
CLEAR_MODELS_ON_EXIT <- FALSE  # Clear models when app closes

# ============================================================
# ADVANCED SETTINGS
# ============================================================

# Image preprocessing
IMAGE_RESIZE_METHOD <- "bilinear"  # Resize interpolation method
NORMALIZE_RANGE <- c(0, 1)         # Normalization range

# Model saving (future feature)
SAVE_MODELS <- FALSE               # Save trained models to disk
MODEL_SAVE_PATH <- "models/"       # Directory for saved models

# Logging
VERBOSE_LOGGING <- FALSE           # Enable verbose output
LOG_FILE <- "app.log"              # Log file path

# ============================================================
# APP METADATA
# ============================================================

APP_TITLE <- "MNIST SUPER APP"
APP_VERSION <- "1.0.0"
APP_AUTHOR <- "Joseph"
APP_LICENSE <- "MIT"

# ============================================================
# HELPER FUNCTIONS
# ============================================================

#' Get Configuration Value
#' 
#' @param key Configuration key name
#' @return Configuration value
#' @export
get_config <- function(key) {
  if (exists(key, envir = .GlobalEnv)) {
    return(get(key, envir = .GlobalEnv))
  } else {
    warning(paste("Configuration key", key, "not found"))
    return(NULL)
  }
}

#' Validate Configuration
#' 
#' Checks if all required configuration values are valid
#' @return TRUE if valid, FALSE otherwise
#' @export
validate_config <- function() {
  checks <- list(
    CNN_EPOCHS > 0,
    CNN_BATCH_SIZE > 0,
    KNN_K > 0,
    RF_NTREE > 0,
    VIZ_SAMPLE_SIZE > 0,
    CANVAS_WIDTH > 0,
    CANVAS_HEIGHT > 0
  )
  
  all(unlist(checks))
}

#' Print Configuration Summary
#' 
#' Displays current configuration settings
#' @export
print_config <- function() {
  cat("=== MNIST App Configuration ===\n\n")
  cat("App Version:", APP_VERSION, "\n")
  cat("CNN Epochs:", CNN_EPOCHS, "\n")
  cat("CNN Batch Size:", CNN_BATCH_SIZE, "\n")
  cat("kNN K:", KNN_K, "\n")
  cat("Random Forest Trees:", RF_NTREE, "\n")
  cat("Visualization Samples:", VIZ_SAMPLE_SIZE, "\n")
  cat("Canvas Size:", CANVAS_WIDTH, "x", CANVAS_HEIGHT, "\n\n")
  cat("Configuration Valid:", validate_config(), "\n")
}

# Validate configuration on load
if (!validate_config()) {
  warning("Invalid configuration detected. Please check config.R")
}
