# 📁 Project Structure

This document describes the organization and architecture of the MNIST Shiny Super-App.

## 📂 Directory Layout

```
mnist_R/
├── app.R                   # Main Shiny application
├── config.R                # Configuration and settings
├── install_packages.R      # Dependency installation script
├── README.md               # Project documentation
├── CONTRIBUTING.md         # Contribution guidelines
├── CHANGELOG.md            # Version history
├── LICENSE                 # MIT License
├── .gitignore              # Git ignore rules
│
├── models/                 # (Generated) Saved trained models
├── plots/                  # (Generated) Exported plots
└── results/                # (Generated) Evaluation results
```

## 🏗️ Application Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────┐
│                     Shiny UI Layer                      │
│  (6 Tabs: Viewer, Models, Viz, Predict, Compare, CNN)  │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                  Shiny Server Logic                     │
│  - Event handlers                                       │
│  - Reactive values                                      │
│  - Data processing                                      │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
┌───────▼──────┐ ┌──▼─────┐ ┌───▼──────────┐
│ MNIST Data   │ │ Models │ │ Visualization│
│ - Train      │ │ - CNN  │ │ - PCA        │
│ - Test       │ │ - kNN  │ │ - UMAP       │
│ - Preproc    │ │ - SVM  │ │ - t-SNE      │
└──────────────┘ │ - RF   │ └──────────────┘
                 └────────┘
```

### Component Breakdown

#### 1. **Data Layer** (`app.R` lines 31-54)
- **MNIST Loading:** Downloads and caches dataset via Keras
- **Preprocessing:**
  - Normalization (0-255 → 0-1)
  - Flattening (28×28 → 784D for traditional ML)
  - Reshaping (add channel dimension for CNN)
  - One-hot encoding (labels → binary matrices)

#### 2. **UI Layer** (`app.R` lines 56-172)
- **Tab 1 - MNIST Viewer:**
  - Slider input for image selection
  - Plot output for image display
  - Text output for label
  
- **Tab 2 - Train Models:**
  - 4 action buttons (CNN, kNN, SVM, RF)
  - Status text output
  - Training plot for CNN
  
- **Tab 3 - Visualization:**
  - Method selector (PCA/UMAP/t-SNE)
  - Action button to generate
  - Large plot output
  
- **Tab 4 - Prediction:**
  - MNIST prediction section
  - Canvas for drawing
  - Clear/predict buttons
  - Probability displays
  
- **Tab 5 - Model Comparison:**
  - Sample size slider
  - Evaluate button
  - Accuracy bar chart
  - Confusion matrix
  
- **Tab 6 - CNN Insights:**
  - Filter number slider
  - Activation map button
  - Filter and activation plots

#### 3. **Server Layer** (`app.R` lines 174-end)

**Reactive Values:**
```
cnn_model       # Stores trained CNN
knn_model       # Flag for kNN availability
svm_model       # Stores trained SVM
rf_model        # Stores trained RF
cnn_history     # CNN training history
eval_results    # Evaluation metrics
```

**Render Functions:**
- `renderPlot()` - For all visualizations
- `renderText()` - For status/predictions
- `observeEvent()` - For button clicks

**Event Flow:**
```
User Action → observeEvent() → Processing → Update Reactive → renderX() → UI Update
```

#### 4. **Model Training Pipeline**

**CNN:**
1. Define architecture (Conv → Pool → Dense)
2. Compile with optimizer
3. Train with validation split
4. Store model + history

**kNN/SVM/RF:**
1. Use subset for faster training
2. Train on flattened features
3. Store model object

#### 5. **Prediction Pipeline**

**MNIST Image:**
```
Slider Input → Get Image → Reshape → CNN Predict → Display Probabilities
```

**Drawn Image:**
```
Canvas Data → Matrix Conversion → Resize (300→28) → 
Normalize → CNN Predict → Display Probabilities
```

## 🔧 Configuration System

### config.R Structure

```r
# Data Settings
├── TRAIN_SAMPLE_SIZE
├── TEST_SAMPLE_SIZE
└── Subset sizes for models

# Model Settings
├── CNN Architecture params
├── kNN parameters
└── RF/SVM settings

# UI Settings
├── Canvas dimensions
├── Plot heights
└── Slider ranges

# Performance Settings
├── GPU settings
├── Parallel cores
└── Memory management
```

## 📊 Data Flow Diagram

```
MNIST Dataset (Keras)
      │
      ├─→ Normalize (0-1)
      │
      ├─→ Flatten → x_train_flat → kNN/SVM/RF
      │
      ├─→ Reshape → x_train_cnn → CNN
      │
      └─→ One-hot → y_train → CNN training

User Interaction
      │
      ├─→ Browse Images → Display
      │
      ├─→ Train Model → Store in Reactive
      │
      ├─→ Visualize → PCA/UMAP/t-SNE → Plot
      │
      ├─→ Draw Digit → Resize → Predict → Display
      │
      └─→ Evaluate → Test on Models → Compare
```

## 🎨 UI Component Tree

```
navbarPage
│
├── tabPanel (MNIST Viewer)
│   ├── sidebarPanel
│   │   └── sliderInput
│   └── mainPanel
│       ├── plotOutput
│       └── verbatimTextOutput
│
├── tabPanel (Train Models)
│   ├── sidebarPanel
│   │   ├── actionButton (×4)
│   │   └── verbatimTextOutput
│   └── mainPanel
│       └── plotOutput
│
├── tabPanel (Visualization)
│   ├── sidebarPanel
│   │   ├── selectInput
│   │   └── actionButton
│   └── mainPanel
│       └── plotOutput
│
├── tabPanel (Prediction)
│   ├── sidebarPanel
│   │   ├── MNIST section
│   │   ├── Canvas section
│   │   └── Buttons
│   └── mainPanel
│       └── plotOutput
│
├── tabPanel (Model Comparison)
│   ├── sidebarPanel
│   │   ├── sliderInput
│   │   ├── actionButton
│   │   └── verbatimTextOutput
│   └── mainPanel
│       ├── plotOutput (bar chart)
│       └── plotOutput (confusion matrix)
│
└── tabPanel (CNN Insights)
    ├── sidebarPanel
    │   ├── sliderInput
    │   └── actionButton (×2)
    └── mainPanel
        ├── plotOutput (filter)
        └── plotOutput (activation)
```

## 🔄 State Management

### Reactive Values
- **Models:** Stored as reactive values to persist across tabs
- **History:** CNN training history for plotting
- **Evaluation:** Results stored for comparison display

### Session State
- **input$idx:** Current image index (shared across tabs)
- **input$draw:** Canvas drawing data
- **Trained flags:** Boolean reactive values for model availability

## 📦 Dependencies

### Core Dependencies
```
shiny          → UI framework
keras          → Deep learning
ggplot2        → Visualization
```

### ML Libraries
```
class          → kNN
e1071          → SVM
randomForest   → Random Forest
```

### Visualization
```
umap           → UMAP algorithm
Rtsne          → t-SNE algorithm
shinyCanvas    → Drawing canvas
```

## 🚀 Execution Flow

```
1. App Start
   ├─→ Load libraries
   ├─→ Load config (optional)
   ├─→ Load MNIST data
   └─→ Preprocess data

2. UI Rendering
   └─→ Display 6 tabs

3. User Interaction Loop
   ├─→ Click/Input
   ├─→ Trigger observeEvent
   ├─→ Process data
   ├─→ Update reactive
   └─→ Re-render output

4. App Close
   └─→ Clean up (optional)
```

## 🧩 Modularity Notes

### Easy to Extend
- **Add new model:** Create reactive value + training observer
- **Add new tab:** Add tabPanel + corresponding server logic
- **Add new visualization:** Implement in observeEvent
- **Customize UI:** Modify navbarPage structure

### Best Practices Applied
- Separation of concerns (UI/Server)
- Reactive programming
- Modular code structure
- Configuration management
- Comprehensive documentation

## 📝 Code Organization

### Section Headers
```r
###############################################################
# SECTION NAME
###############################################################
```

### Function Documentation
```r
#' Function Purpose
#' 
#' @param param Description
#' @return Return value description
```

### Comments
- **High-level:** What the code does
- **Inline:** Why specific choices were made
- **TODOs:** Future improvements

---

**Last Updated:** 2025-11-26  
**Version:** 1.0.0  
**Maintainer:** Joseph
