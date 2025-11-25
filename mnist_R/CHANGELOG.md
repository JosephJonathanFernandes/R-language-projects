# Changelog

All notable changes to the MNIST Shiny Super-App will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-26

### 🎉 Initial Release

#### Added

**Core Features:**
- MNIST dataset viewer with 60,000 training images
- Interactive slider to browse through dataset
- True label display for each image

**Machine Learning Models:**
- Convolutional Neural Network (CNN) with Keras/TensorFlow
- k-Nearest Neighbors (kNN) classifier
- Support Vector Machine (SVM) with RBF kernel
- Random Forest ensemble classifier
- Live training visualization for CNN (loss/accuracy plots)

**Dimensionality Reduction:**
- PCA (Principal Component Analysis) visualization
- UMAP (Uniform Manifold Approximation and Projection) visualization
- t-SNE (t-Distributed Stochastic Neighbor Embedding) visualization
- Interactive 2D scatter plots colored by digit class
- Support for 2,000 sample visualization

**Interactive Prediction:**
- Predict selected MNIST images with trained CNN
- Draw-your-own digit canvas (300×300 pixels)
- Real-time drawing preview
- Canvas clearing functionality
- Automatic image resizing (300×300 → 28×28)
- Full probability distribution display
- Confidence scores for all predictions

**Model Comparison:**
- Side-by-side accuracy comparison for all models
- Adjustable test sample size (100-2000 images)
- Visual bar chart comparison
- Confusion matrix for CNN predictions
- Heatmap visualization of misclassifications
- Real-time evaluation status updates

**CNN Insights:**
- Visualize all 32 convolutional filters
- Interactive filter selection (1-32)
- Activation heatmap generation
- Layer-by-layer neural network analysis
- Filter pattern visualization

**User Interface:**
- Clean tabbed navigation (6 tabs)
- Responsive Shiny layout
- Professional Bootstrap styling
- Status messages and progress indicators
- Organized sidebar/main panel structure

**Documentation:**
- Comprehensive README with setup instructions
- Feature documentation
- Usage guide for each tab
- Technical architecture details
- Troubleshooting section
- Installation script for dependencies
- Code comments and structure

**Infrastructure:**
- Automated package installation script
- Configuration management (config.R)
- Professional repository structure
- MIT License
- Contributing guidelines
- Gitignore for R/Shiny projects

#### Technical Details

**Dependencies:**
- shiny (web application framework)
- shinyCanvas (drawing canvas)
- keras (deep learning)
- ggplot2 (visualization)
- umap (UMAP algorithm)
- Rtsne (t-SNE algorithm)
- class (kNN implementation)
- randomForest (Random Forest)
- e1071 (SVM implementation)

**Model Architectures:**
- CNN: Conv2D(32,3×3) → MaxPool(2×2) → Flatten → Dense(128) → Dense(10)
- kNN: k=3, Euclidean distance
- SVM: Radial basis kernel (default)
- RF: 100 trees

**Performance Optimizations:**
- Training subsets for SVM/RF (10,000 samples)
- Efficient data preprocessing
- Normalized pixel values [0,1]
- Vectorized operations

**Code Quality:**
- Modular code structure
- Roxygen-style documentation
- Configuration separation
- Professional commenting
- Error handling

### 🔧 Configuration

**Configurable Parameters:**
- Model hyperparameters (epochs, batch size, etc.)
- Visualization sample sizes
- UI dimensions and styling
- Training subset sizes
- Performance settings

### 📚 Documentation

**Included Files:**
- README.md - Comprehensive user guide
- CONTRIBUTING.md - Contribution guidelines
- LICENSE - MIT License
- CHANGELOG.md - Version history
- config.R - Configuration management
- install_packages.R - Dependency installer
- .gitignore - Git ignore rules

### 🎯 Future Roadmap

**Planned Features:**
- [ ] GPU acceleration support
- [ ] Model save/load functionality
- [ ] Export predictions to CSV
- [ ] ROC curves and AUC metrics
- [ ] Dark theme with bslib
- [ ] Deployment to shinyapps.io
- [ ] Grad-CAM visualization
- [ ] Model ensembling
- [ ] Real-time training progress bars
- [ ] Unit tests
- [ ] Docker containerization
- [ ] REST API endpoint
- [ ] Batch prediction upload

### 🐛 Known Issues

- Canvas drawing may not work in all browsers (Chrome/Edge recommended)
- Large evaluation sample sizes (>2000) may cause memory issues
- SVM/RF training can be slow on older hardware
- t-SNE visualization may take 30-60 seconds

### 📊 Statistics

- **Total Lines of Code:** ~500+ lines in app.R
- **Number of Features:** 25+ major features
- **ML Models:** 4 (CNN, kNN, SVM, RF)
- **Visualization Methods:** 3 (PCA, UMAP, t-SNE)
- **Tabs/Sections:** 6 main tabs
- **Dataset Size:** 70,000 images (60k train + 10k test)

---

## Version History

### Version Numbering

- **Major version** (X.0.0): Incompatible API changes or major feature overhauls
- **Minor version** (0.X.0): New features, backward compatible
- **Patch version** (0.0.X): Bug fixes, backward compatible

### Release Types

- **Stable**: Production-ready releases
- **Beta**: Feature-complete but may have bugs
- **Alpha**: Early development, experimental features

---

**Current Version:** 1.0.0 (Stable)
**Release Date:** November 26, 2025
**Status:** Production Ready ✅

---

## How to Update

To update to the latest version:

```bash
git pull origin main
```

Then reinstall dependencies if needed:

```r
source("install_packages.R")
```

---

## Contributors

- **Joseph** - Initial development and release

---

## Links

- **Repository:** [GitHub](https://github.com/yourusername/mnist_R)
- **Issues:** [GitHub Issues](https://github.com/yourusername/mnist_R/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/mnist_R/discussions)

---

*For detailed contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md)*
