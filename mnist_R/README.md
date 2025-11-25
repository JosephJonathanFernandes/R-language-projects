# 🎯 MNIST Shiny Super-App

[![R Version](https://img.shields.io/badge/R-%E2%89%A5%204.0-blue.svg)](https://www.r-project.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shiny](https://img.shields.io/badge/Shiny-1.7+-brightgreen.svg)](https://shiny.rstudio.com/)
[![Keras](https://img.shields.io/badge/Keras-TensorFlow-red.svg)](https://keras.io/)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success.svg)](https://github.com/yourusername/mnist_R)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

> **A comprehensive R Shiny application for exploring and experimenting with the MNIST handwritten digit dataset featuring multiple ML models, interactive visualizations, and deep learning explainability.**

![MNIST Demo](https://via.placeholder.com/800x400?text=MNIST+Shiny+Super-App+Demo)

---

## 📋 Table of Contents

- [Features](#-features)
- [Demo](#-demo)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Usage Guide](#-usage-guide)
- [Architecture](#-architecture)
- [Configuration](#-configuration)
- [Contributing](#-contributing)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)

---

## ✨ Features

### 📊 **MNIST Viewer**
- Browse through all 60,000 training images
- Interactive slider to select any image
- Display true labels

### 🤖 **Train Multiple Models**
- **CNN (Convolutional Neural Network)** - Deep learning with Keras
- **kNN (k-Nearest Neighbors)** - Classic machine learning
- **SVM (Support Vector Machine)** - Powerful classifier
- **Random Forest** - Ensemble learning method
- Live training visualization for CNN

### 🔍 **Dimensionality Reduction Visualization**
- **PCA** (Principal Component Analysis)
- **UMAP** (Uniform Manifold Approximation and Projection)
- **t-SNE** (t-Distributed Stochastic Neighbor Embedding)
- Interactive plots colored by digit labels

### ✏️ **Interactive Prediction**
- Predict any MNIST image with trained CNN
- **Draw your own digit** on canvas and get predictions
- Real-time preview of drawn digits
- Full probability distribution display

### 📊 **Model Comparison & Evaluation**
- Compare accuracy across all 4 models
- Adjustable test sample size (100-2000)
- Visual bar chart comparison
- **Confusion matrix** for CNN predictions

### 🔬 **CNN Deep Dive**
- **Visualize CNN filters** (32 convolutional filters)
- **Activation heatmaps** - see what the CNN "sees"
- Layer-by-layer analysis
- Interactive filter exploration

---

## 🚀 Installation

### Step 1: Install R Packages

Run the installation script to automatically install all required packages:

```r
source("install_packages.R")
```

Or install manually:

```r
# Install CRAN packages
install.packages(c(
  "shiny",
  "ggplot2",
  "umap",
  "Rtsne",
  "class",
  "randomForest",
  "shinyCanvas",
  "e1071"
))

# Install Keras
install.packages("keras")
library(keras)
install_keras()
```

### Step 2: Run the App

```r
shiny::runApp("app.R")
```

Or from RStudio: Open `app.R` and click **Run App**.

---

## 📦 Required Packages

| Package | Purpose |
|---------|---------|
| `shiny` | Web application framework |
| `shinyCanvas` | Interactive drawing canvas |
| `keras` | Deep learning (CNN) |
| `ggplot2` | Data visualization |
| `umap` | UMAP dimensionality reduction |
| `Rtsne` | t-SNE dimensionality reduction |
| `class` | k-Nearest Neighbors |
| `randomForest` | Random Forest classifier |
| `e1071` | Support Vector Machine |

---

## 🎮 How to Use

### 1️⃣ **MNIST Viewer Tab**
- Use the slider to browse through training images
- See the true label for each image

### 2️⃣ **Train Models Tab**
- Click any "Train" button to train a model
- CNN training shows live accuracy/loss plots
- Status messages display training progress
- **Note:** SVM and Random Forest may take 20-60 seconds

### 3️⃣ **Visualization Tab**
- Select PCA, UMAP, or t-SNE
- Click "Generate Visualization"
- Wait for the algorithm to process 2,000 sample images
- View the 2D projection colored by digit class

### 4️⃣ **Prediction Tab**

**Predict MNIST Images:**
- Use the slider from the Viewer tab to select an image
- Click "Predict Selected Image"
- See CNN prediction with **confidence scores**
- View full probability distribution for all 10 digits

**Draw Your Own Digit:**
- Draw a digit on the canvas (use mouse/touch)
- Click "Clear" to erase
- Click "Predict Drawn Digit" to classify
- See your drawing preview and prediction with probabilities

### 5️⃣ **Model Comparison Tab**
- Adjust test sample size (100-2000 images)
- Click "Evaluate All Models" to test accuracy
- View **accuracy comparison bar chart**
- Examine **CNN confusion matrix** to see misclassifications
- Identify which digits are confused with each other

### 6️⃣ **CNN Insights Tab**

**Filter Visualization:**
- Select filter number (1-32)
- Click "Show Filter" to visualize learned patterns
- See what features each filter detects

**Activation Heatmap:**
- Click "Generate Activation Map"
- See how the CNN activates for the selected image
- Understand which regions the network focuses on

---

## 📁 Project Structure

```
mnist_R/
├── app.R                   # Main Shiny application
├── config.R                # Configuration and settings
├── install_packages.R      # Dependency installer
├── README.md               # This file
├── CONTRIBUTING.md         # Contribution guidelines
├── CHANGELOG.md            # Version history
├── STRUCTURE.md            # Detailed architecture docs
├── LICENSE                 # MIT License
└── .gitignore              # Git ignore rules
```

For detailed architecture documentation, see [STRUCTURE.md](STRUCTURE.md).

---

## ⚙️ Technical Details

### Model Architectures

**CNN:**
- Conv2D (32 filters, 3×3) → ReLU
- MaxPooling (2×2)
- Flatten
- Dense (128) → ReLU
- Dense (10) → Softmax

**kNN:** k=3 (default), Euclidean distance

**SVM:** Radial basis kernel (default from `e1071`)

**Random Forest:** 100 trees

### Data Preprocessing
- Images normalized to [0, 1]
- CNN uses 28×28×1 format
- Other models use flattened 784-dimensional vectors
- Drawn digits resized from 300×300 to 28×28

### Performance Notes
- CNN trains in ~30 seconds (1 epoch, validation split 10%)
- SVM trains on 10,000 samples (~20 seconds)
- Random Forest trains on 10,000 samples (~30-60 seconds)
- Visualization uses 2,000 samples for speed

---

## 🌟 Future Enhancements

Want even more features? The app now includes most advanced features, but you could still add:

- 🎯 **Real-time training with progress bars** (epoch-by-epoch)
- 📈 **ROC curves and AUC scores** for each model
- 🌙 **Dark theme** with `bslib` for modern UI
- ☁️ **Deploy to shinyapps.io** for web access
- 🚀 **GPU acceleration** for faster training
- 🎨 **Grad-CAM visualization** for advanced interpretability
- 💾 **Save/load trained models** to disk
- 📊 **Model ensembling** - combine predictions from multiple models

---

## 🐛 Troubleshooting

**Issue:** Keras/TensorFlow installation fails

**Solution:** 
```r
# Try installing specific TensorFlow version
keras::install_keras(method = "conda", tensorflow = "2.11")
```

**Issue:** shinyCanvas not working

**Solution:**
```r
# Install from GitHub if CRAN version has issues
remotes::install_github("nz-stefan/shinyCanvas")
```

**Issue:** Canvas drawing doesn't work

**Solution:** The canvas requires the `shinyCanvas` package. Drawing may not work on all browsers - Chrome/Edge recommended.

**Issue:** Out of memory errors

**Solution:** Reduce sample sizes in the code:
- Visualization: Change `small <- x_train_flat[1:2000,]` to `[1:1000,]`
- SVM/RF training: Change `[1:10000,]` to `[1:5000,]`

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **MNIST Dataset:** Yann LeCun, Corinna Cortes, Christopher J.C. Burges
- **R Shiny:** RStudio Team
- **Keras/TensorFlow:** Google Brain Team
- **R Package Developers:** All contributors to the R ecosystem
- **Community:** Thank you to all contributors and users!

---

## 📞 Contact & Support

- **Issues:** [GitHub Issues](https://github.com/yourusername/mnist_R/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/mnist_R/discussions)
- **Email:** your.email@example.com

---

## 📊 Project Status

- **Version:** 1.0.0 (Stable)
- **Status:** Production Ready ✅
- **Last Updated:** November 26, 2025
- **Maintainer:** Joseph

---

## 🌟 Star History

If you find this project helpful, please consider giving it a star ⭐

---

**Built with ❤️ using R and Shiny**
