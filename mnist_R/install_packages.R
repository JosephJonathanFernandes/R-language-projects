###############################################################
# INSTALL ALL REQUIRED PACKAGES FOR MNIST SHINY APP
###############################################################

cat("Installing required R packages...\n\n")

# List of CRAN packages
cran_packages <- c(
  "shiny",
  "ggplot2",
  "umap",
  "Rtsne",
  "class",
  "randomForest",
  "shinyCanvas",
  "e1071"
)

# Install CRAN packages
cat("Installing CRAN packages:\n")
for (pkg in cran_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(paste("  - Installing", pkg, "...\n"))
    install.packages(pkg, dependencies = TRUE)
  } else {
    cat(paste("  ✓", pkg, "already installed\n"))
  }
}

# Install Keras
cat("\nInstalling Keras...\n")
if (!require("keras", quietly = TRUE)) {
  install.packages("keras")
}

cat("\nLoading keras library and installing TensorFlow backend...\n")
library(keras)

# Check if Keras backend is already installed
tryCatch({
  keras::backend()
  cat("  ✓ Keras backend already configured\n")
}, error = function(e) {
  cat("  - Installing Keras/TensorFlow backend (this may take several minutes)...\n")
  install_keras()
  cat("  ✓ Keras installation complete\n")
})

cat("\n")
cat("========================================\n")
cat("✓ ALL PACKAGES INSTALLED SUCCESSFULLY!\n")
cat("========================================\n")
cat("\nYou can now run the Shiny app with:\n")
cat("  shiny::runApp('app.R')\n\n")
