# 🚀 Quick Start Guide

Get up and running with the MNIST Shiny Super-App in under 5 minutes!

## ⚡ Installation (3 minutes)

### Step 1: Install R Packages

Open R or RStudio and run:

```r
source("install_packages.R")
```

This will automatically install:
- All CRAN packages (shiny, ggplot2, etc.)
- Keras and TensorFlow backend
- All dependencies

**Expected time:** 2-3 minutes

### Step 2: Verify Installation

Check that Keras is properly configured:

```r
library(keras)
keras::backend()  # Should return "tensorflow"
```

## 🎮 Running the App (30 seconds)

### Method 1: From R Console

```r
shiny::runApp("app.R")
```

### Method 2: From RStudio

1. Open `app.R` in RStudio
2. Click the **"Run App"** button at the top
3. App opens in browser or RStudio viewer

## 📖 First Steps (2 minutes)

### 1. Browse MNIST Images (Tab 1)
- Move the slider to see different handwritten digits
- Labels show below each image

### 2. Train Your First Model (Tab 2)
- Click **"Train CNN"** button
- Wait ~30 seconds
- See training progress graph

### 3. Make a Prediction (Tab 4)
- Select an image with the slider
- Click **"Predict Selected Image"**
- See prediction with confidence scores!

## 🎨 Try Drawing Your Own Digit

Still in Tab 4:

1. Draw a digit (0-9) in the canvas
2. Click **"Predict Drawn Digit"**
3. See what the CNN thinks you drew!

## 📊 Explore Visualizations (Tab 3)

1. Select **PCA**, **UMAP**, or **t-SNE**
2. Click **"Generate Visualization"**
3. Wait 10-30 seconds
4. See how digits cluster in 2D space!

## 🏆 Compare Models (Tab 5)

1. Train multiple models first (Tab 2)
2. Go to Tab 5
3. Click **"Evaluate All Models"**
4. See accuracy comparison and confusion matrix

## 🔬 Deep Dive into CNN (Tab 6)

1. After training CNN (Tab 2)
2. Go to Tab 6
3. Click **"Show Filter"** to see learned patterns
4. Click **"Generate Activation Map"** to see what CNN focuses on

## 🛠️ Common Issues & Quick Fixes

### Issue: Keras not found
```r
install.packages("keras")
library(keras)
install_keras()
```

### Issue: Canvas doesn't work
- Use Chrome or Edge browser
- Canvas requires `shinyCanvas` package

### Issue: App is slow
- Reduce sample sizes in config.R
- Close other R sessions
- Use fewer training epochs

### Issue: Models take too long to train
- This is normal! Expected times:
  - CNN: ~30 seconds
  - kNN: Instant (no training)
  - SVM: ~20 seconds
  - RF: ~30-60 seconds

## 📋 Cheat Sheet

### Key Shortcuts (in app)

| Action | Location | Time |
|--------|----------|------|
| Browse images | Tab 1, use slider | Instant |
| Train CNN | Tab 2, click "Train CNN" | 30s |
| Visualize PCA | Tab 3, select PCA, click button | 5s |
| Draw & predict | Tab 4, draw then click predict | 1s |
| Compare models | Tab 5, click "Evaluate" | 10-30s |
| View filters | Tab 6, click "Show Filter" | Instant |

### R Commands

```r
# Run app
shiny::runApp("app.R")

# Check installed packages
installed.packages()[c("shiny", "keras", "ggplot2"),]

# Update packages
update.packages()

# View configuration
source("config.R")
print_config()
```

## 🎯 Next Steps

After getting familiar with the basics:

1. **Experiment with different models**
   - Try all 4 models and compare
   
2. **Explore dimensionality reduction**
   - Compare PCA vs UMAP vs t-SNE
   - Which shows better digit separation?

3. **Test edge cases**
   - Draw messy digits
   - Try digits at edges of images
   - See where models make mistakes

4. **Customize settings**
   - Edit `config.R` to change:
     - Training epochs
     - Sample sizes
     - UI dimensions

5. **Contribute**
   - Found a bug? Open an issue
   - Have ideas? Start a discussion
   - Want to add features? Submit PR!

## 📚 Learning Resources

### Understanding the Models

- **CNN**: Convolutional layers detect patterns (edges, curves)
- **kNN**: Finds similar images in training set
- **SVM**: Finds optimal boundaries between digit classes
- **RF**: Combines many decision trees for robust predictions

### Key Concepts

- **One-hot encoding**: Convert labels (5) → vectors [0,0,0,0,0,1,0,0,0,0]
- **Normalization**: Scale pixels from 0-255 → 0-1
- **Validation split**: Hold out 10% of training data for validation
- **Confusion matrix**: Shows which digits get confused with each other

## 🎓 Tutorials

### Tutorial 1: Train and Evaluate CNN
```
1. Tab 2 → Train CNN (30s)
2. Tab 4 → Select image → Predict
3. Tab 5 → Evaluate (see accuracy)
4. Tab 5 → Check confusion matrix (see mistakes)
```

### Tutorial 2: Understand CNN Internals
```
1. Tab 6 → Try filter 1
2. Tab 6 → Try filter 10
3. Tab 6 → Try filter 32
4. Notice: Different filters detect different patterns!
5. Tab 6 → Generate activation map
6. Notice: CNN focuses on important regions
```

### Tutorial 3: Compare All Methods
```
1. Tab 2 → Train all 4 models (wait 1-2 min)
2. Tab 5 → Evaluate on 1000 samples
3. Compare: Which is most accurate?
4. Check confusion matrix: Where do models fail?
```

## 💡 Pro Tips

1. **Train CNN first** - Most features need it
2. **Start small** - Use fewer samples when testing
3. **Watch memory** - Close other apps if slow
4. **Save your work** - Export plots (right-click)
5. **Experiment freely** - Can't break anything!

## ❓ FAQ

**Q: How long does initial setup take?**
A: 3-5 minutes total (mostly installing packages)

**Q: Do I need a GPU?**
A: No! Works fine on CPU (just slightly slower)

**Q: Can I use my own images?**
A: Currently only MNIST, but this is a great feature to add!

**Q: How accurate are the models?**
A: CNN typically achieves ~98%, kNN ~95%, SVM ~95%, RF ~93%

**Q: Can I increase accuracy?**
A: Yes! In config.R, increase `CNN_EPOCHS` to 5 or 10

**Q: Where is data stored?**
A: Cached by Keras (usually in ~/.keras/)

## 🆘 Getting Help

1. **Check README.md** - Comprehensive documentation
2. **Check CONTRIBUTING.md** - Common issues
3. **Check CHANGELOG.md** - Known issues section
4. **Open an Issue** - Describe your problem
5. **Start Discussion** - Ask questions

## 🎉 You're Ready!

You now know how to:
- ✅ Install and run the app
- ✅ Train machine learning models
- ✅ Make predictions
- ✅ Visualize data
- ✅ Compare model performance
- ✅ Understand CNN internals

**Happy exploring! 🚀**

---

**Time to first prediction:** ~5 minutes
**Time to master all features:** ~30 minutes
**Time to start contributing:** Whenever you're ready!
