# 🎯 MNIST Shiny Super-App

A comprehensive R Shiny application for exploring and experimenting with the MNIST handwritten digit dataset. This app includes visualization, multiple machine learning models, dimensionality reduction techniques, and an interactive drawing canvas.

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

## 📄 License

This project is for educational purposes. MNIST dataset is provided by Yann LeCun and Corinna Cortes.

---

## 🙏 Credits

- **MNIST Dataset:** Yann LeCun, Corinna Cortes, Christopher J.C. Burges
- **R Packages:** All the amazing R package developers
- **Keras/TensorFlow:** Google Brain Team

---

## 📧 Support

If you encounter issues:
1. Check that all packages are installed correctly
2. Verify Keras backend is configured: `keras::backend()`
3. Try restarting R session
4. Check R version (>= 4.0 recommended)

---

**Enjoy exploring the MNIST dataset! 🎉**
