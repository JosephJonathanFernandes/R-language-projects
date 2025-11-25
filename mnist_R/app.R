###############################################################
# MNIST SUPER SHINY APP
# 
# @title MNIST Digit Recognition - Interactive Machine Learning App
# @description A comprehensive Shiny application for exploring MNIST dataset
#              with multiple ML models, visualizations, and interactive features
# @version 1.0.0
# @author Joseph
# @license MIT
# @date 2025-11-26
#
# Features:
#   - MNIST dataset viewer (60,000 images)
#   - 4 ML models: CNN, kNN, SVM, Random Forest
#   - Dimensionality reduction: PCA, UMAP, t-SNE
#   - Interactive drawing canvas
#   - Model comparison and evaluation
#   - CNN filter and activation visualization
#
# Repository: https://github.com/yourusername/mnist_R
###############################################################

# Load required libraries
library(shiny)         # Web application framework
library(shinyCanvas)   # Interactive drawing canvas
library(keras)         # Deep learning (CNN)
library(ggplot2)       # Data visualization
library(umap)          # UMAP dimensionality reduction
library(Rtsne)         # t-SNE dimensionality reduction
library(class)         # k-Nearest Neighbors
library(randomForest)  # Random Forest classifier
library(e1071)         # Support Vector Machine

# Load configuration (optional - uncomment if using config.R)
# source("config.R")

###############################################################
# DATA LOADING AND PREPROCESSING
###############################################################

#' Load MNIST Dataset
#' 
#' Loads the MNIST handwritten digit dataset from Keras
#' Dataset contains 60,000 training images and 10,000 test images
#' Each image is 28x28 pixels in grayscale
mnist <- dataset_mnist()

# Normalize pixel values to [0, 1] range
x_train <- mnist$train$x / 255
y_train_raw <- mnist$train$y
x_test  <- mnist$test$x / 255
y_test_raw <- mnist$test$y

# Flatten images for traditional ML models (kNN, SVM, RF)
# Converts 28x28 matrices to 784-dimensional vectors
x_train_flat <- matrix(x_train, nrow = 60000, ncol = 28*28)
x_test_flat  <- matrix(x_test,  nrow = 10000, ncol = 28*28)

# One-hot encode labels for neural network
# Converts integer labels (0-9) to binary class matrices
y_train <- to_categorical(y_train_raw, 10)
y_test  <- to_categorical(y_test_raw, 10)

# Reshape for CNN (add channel dimension)
# CNN requires 4D array: (samples, height, width, channels)
x_train_cnn <- array_reshape(x_train, c(60000, 28, 28, 1))
x_test_cnn  <- array_reshape(x_test,  c(10000, 28, 28, 1))

###############################################################
# USER INTERFACE
###############################################################

#' Shiny UI Definition
#' 
#' Creates a multi-tab navigation interface with:
#' - MNIST Viewer: Browse training images
#' - Train Models: Train CNN, kNN, SVM, Random Forest
#' - Visualization: PCA, UMAP, t-SNE dimensionality reduction
#' - Prediction: Predict MNIST images and drawn digits
#' - Model Comparison: Evaluate and compare model accuracies
#' - CNN Insights: Visualize filters and activations
ui <- navbarPage("MNIST SUPER APP",

  ########## TAB 1 — VIEW IMAGES ##########
  tabPanel("MNIST Viewer",
    sidebarLayout(
      sidebarPanel(
        sliderInput("idx", "Choose MNIST Image", 1, 60000, 1)
      ),
      mainPanel(
        plotOutput("mnist_plot", height = "300px"),
        verbatimTextOutput("true_label")
      )
    )
  ),

  ########## TAB 2 — MODELS ##########
  tabPanel("Train Models",
    sidebarLayout(
      sidebarPanel(
        actionButton("train_cnn", "Train CNN", class="btn btn-primary"),
        actionButton("train_knn", "Train kNN", class="btn btn-secondary"),
        actionButton("train_svm", "Train SVM", class="btn btn-info"),
        actionButton("train_rf",  "Train Random Forest", class="btn btn-success"),
        br(), br(),
        verbatimTextOutput("model_status")
      ),
      mainPanel(
        plotOutput("cnn_training_plot")
      )
    )
  ),

  ########## TAB 3 — EMBEDDING VISUALIZATION ##########
  tabPanel("Visualization (PCA / UMAP / t-SNE)",
    sidebarLayout(
      sidebarPanel(
        selectInput("viz_method", "Choose Method",
          c("PCA", "UMAP", "t-SNE")
        ),
        actionButton("run_viz", "Generate Visualization")
      ),
      mainPanel(
        plotOutput("viz_plot", height="500px")
      )
    )
  ),

  ########## TAB 4 — PREDICTION ##########
  tabPanel("Prediction",
    sidebarLayout(
      sidebarPanel(
        h3("Predict MNIST Image"),
        actionButton("predict_mnist", "Predict Selected Image"),
        verbatimTextOutput("pred_mnist"),

        hr(),
        h3("Draw Your Own Digit"),
        canvasOutput("draw", width = 300, height = 300),
        actionButton("clear_canvas", "Clear"),
        actionButton("predict_drawn", "Predict Drawn Digit"),
        verbatimTextOutput("pred_drawn")
      ),
      mainPanel(
        plotOutput("draw_preview", height = "300px")
      )
    )
  ),

  ########## TAB 5 — MODEL COMPARISON ##########
  tabPanel("Model Comparison",
    sidebarLayout(
      sidebarPanel(
        h3("Evaluate All Models"),
        sliderInput("test_samples", "Test Samples", 100, 2000, 500, step=100),
        actionButton("evaluate_all", "Evaluate All Models", class="btn btn-warning"),
        br(), br(),
        verbatimTextOutput("eval_status")
      ),
      mainPanel(
        plotOutput("accuracy_comparison", height = "300px"),
        br(),
        h4("Confusion Matrix (CNN)"),
        plotOutput("confusion_matrix", height = "400px")
      )
    )
  ),

  ########## TAB 6 — CNN INSIGHTS ##########
  tabPanel("CNN Insights",
    sidebarLayout(
      sidebarPanel(
        h3("CNN Filter Visualization"),
        sliderInput("filter_num", "Filter Number", 1, 32, 1),
        actionButton("show_filter", "Show Filter"),
        hr(),
        h3("Activation Heatmap"),
        actionButton("show_activation", "Generate Activation Map")
      ),
      mainPanel(
        h4("Convolutional Filter"),
        plotOutput("filter_viz", height = "300px"),
        hr(),
        h4("Layer Activation"),
        plotOutput("activation_map", height = "300px")
      )
    )
  )
)
###############################################################
# SERVER
###############################################################
server <- function(input, output, session) {

  ########## VIEWER ##########
  output$mnist_plot <- renderPlot({
    img <- mnist$train$x[input$idx,,]
    image(1:28, 1:28, img[28:1,], col=gray.colors(255), axes=FALSE)
  })
  output$true_label <- renderText({
    paste("Label:", y_train_raw[input$idx])
  })

  ###############################################################
  # TRAINING MODELS
  ###############################################################
  cnn_model <- reactiveVal(NULL)
  knn_model <- reactiveVal(NULL)
  svm_model <- reactiveVal(NULL)
  rf_model  <- reactiveVal(NULL)
  cnn_history <- reactiveVal(NULL)

  #### CNN ####
  observeEvent(input$train_cnn, {
    output$model_status <- renderText("Training CNN...")
    m <- keras_model_sequential() %>%
      layer_conv_2d(filters=32, kernel_size=3, activation="relu", input_shape=c(28,28,1)) %>%
      layer_max_pooling_2d(pool_size=2) %>%
      layer_flatten() %>%
      layer_dense(128, activation="relu") %>%
      layer_dense(10, activation="softmax")

    m %>% compile(
      loss="categorical_crossentropy",
      optimizer=optimizer_adam(),
      metrics="accuracy"
    )

    h <- m %>% fit(
      x_train_cnn, y_train, epochs=1, batch_size=128,
      validation_split=0.1
    )

    cnn_model(m)
    cnn_history(h)
    output$model_status <- renderText("CNN Training Completed!")
  })

  output$cnn_training_plot <- renderPlot({
    h <- cnn_history()
    if (!is.null(h))
      plot(h)
  })

  #### kNN ####
  observeEvent(input$train_knn, {
    output$model_status <- renderText("kNN ready (no training needed).")
    knn_model(TRUE)
  })

  #### SVM ####
  observeEvent(input$train_svm, {
    output$model_status <- renderText("Training SVM (takes ~20s)...")
    svm_m <- svm(x_train_flat[1:10000,], y_train_raw[1:10000])
    svm_model(svm_m)
    output$model_status <- renderText("SVM trained!")
  })

  #### Random Forest ####
  observeEvent(input$train_rf, {
    output$model_status <- renderText("Training Random Forest (slow)...")
    rf_m <- randomForest(x_train_flat[1:10000,], as.factor(y_train_raw[1:10000]), ntree=100)
    rf_model(rf_m)
    output$model_status <- renderText("Random Forest trained!")
  })

  ###############################################################
  # VISUALIZATION
  ###############################################################
  observeEvent(input$run_viz, {
    method <- input$viz_method
    small <- x_train_flat[1:2000,]
    labels <- y_train_raw[1:2000]

    if (method == "PCA") {
      p <- prcomp(small)
      df <- data.frame(x=p$x[,1], y=p$x[,2], label=labels)
    }

    if (method == "UMAP") {
      u <- umap(small)
      df <- data.frame(x=u$layout[,1], y=u$layout[,2], label=labels)
    }

    if (method == "t-SNE") {
      t <- Rtsne(small)
      df <- data.frame(x=t$Y[,1], y=t$Y[,2], label=labels)
    }

    output$viz_plot <- renderPlot({
      ggplot(df, aes(x, y, color=factor(label))) +
        geom_point(alpha=0.6, size=1) +
        theme_minimal()
    })
  })

  ###############################################################
  # PREDICTION
  ###############################################################

  #### Predict MNIST image ####
  observeEvent(input$predict_mnist, {
    img <- x_train_cnn[input$idx,,,drop=FALSE]

    if (!is.null(cnn_model())) {
      pred <- cnn_model() %>% predict(img)
      result <- which.max(pred) - 1
      probs <- round(pred[1,] * 100, 2)
      output$pred_mnist <- renderText(paste0(
        "CNN Prediction: ", result, "\n",
        "Confidence: ", probs[result+1], "%\n\n",
        "All probabilities:\n",
        paste(0:9, ":", probs, "%", collapse="\n")
      ))
    } else {
      output$pred_mnist <- renderText("Train CNN first.")
    }
  })

  #### Draw your own digit ####
  observeEvent(input$clear_canvas, {
    shinyCanvas::reset("draw")
  })

  output$draw_preview <- renderPlot({
    req(input$draw)
    mat <- as.matrix(input$draw)
    image(t(apply(mat, 2, rev)), col=gray.colors(255), axes=FALSE)
  })

  observeEvent(input$predict_drawn, {
    req(input$draw)
    mat <- as.matrix(input$draw)

    # Resize to 28x28
    m <- matrix(as.numeric(mat), 300, 300)
    small <- as.matrix(as.raster(as.im(m), W=28, H=28))

    # Convert to CNN format
    img <- array(small, dim=c(1,28,28,1))

    if (!is.null(cnn_model())) {
      pred <- cnn_model() %>% predict(img)
      result <- which.max(pred) - 1
      probs <- round(pred[1,] * 100, 2)
      output$pred_drawn <- renderText(paste0(
        "Predicted Drawn Digit: ", result, "\n",
        "Confidence: ", probs[result+1], "%\n\n",
        "All probabilities:\n",
        paste(0:9, ":", probs, "%", collapse="\n")
      ))
    } else {
      output$pred_drawn <- renderText("Train CNN first.")
    }
  })

  ###############################################################
  # MODEL COMPARISON
  ###############################################################
  
  eval_results <- reactiveVal(NULL)
  
  observeEvent(input$evaluate_all, {
    n <- input$test_samples
    output$eval_status <- renderText("Evaluating models...")
    
    test_x <- x_test_flat[1:n,]
    test_x_cnn <- x_test_cnn[1:n,,,drop=FALSE]
    test_y <- y_test_raw[1:n]
    
    results <- list()
    
    # CNN
    if (!is.null(cnn_model())) {
      preds <- cnn_model() %>% predict(test_x_cnn)
      pred_labels <- apply(preds, 1, which.max) - 1
      results$CNN <- mean(pred_labels == test_y) * 100
    } else {
      results$CNN <- NA
    }
    
    # kNN
    if (!is.null(knn_model())) {
      pred_labels <- knn(x_train_flat[1:5000,], test_x, y_train_raw[1:5000], k=3)
      results$kNN <- mean(as.numeric(as.character(pred_labels)) == test_y) * 100
    } else {
      results$kNN <- NA
    }
    
    # SVM
    if (!is.null(svm_model())) {
      pred_labels <- predict(svm_model(), test_x)
      results$SVM <- mean(pred_labels == test_y) * 100
    } else {
      results$SVM <- NA
    }
    
    # RF
    if (!is.null(rf_model())) {
      pred_labels <- predict(rf_model(), test_x)
      results$RF <- mean(as.numeric(as.character(pred_labels)) == test_y) * 100
    } else {
      results$RF <- NA
    }
    
    eval_results(results)
    output$eval_status <- renderText(paste(
      "Evaluation Complete!\n",
      "Tested on", n, "samples"
    ))
  })
  
  output$accuracy_comparison <- renderPlot({
    req(eval_results())
    df <- data.frame(
      Model = names(eval_results()),
      Accuracy = unlist(eval_results())
    )
    df <- df[!is.na(df$Accuracy),]
    
    ggplot(df, aes(x=Model, y=Accuracy, fill=Model)) +
      geom_bar(stat="identity") +
      geom_text(aes(label=paste0(round(Accuracy,2), "%")), vjust=-0.5) +
      ylim(0, 100) +
      theme_minimal() +
      labs(title="Model Accuracy Comparison", y="Accuracy (%)")
  })
  
  output$confusion_matrix <- renderPlot({
    req(eval_results())
    if (is.null(cnn_model())) return(NULL)
    
    n <- input$test_samples
    test_x_cnn <- x_test_cnn[1:n,,,drop=FALSE]
    test_y <- y_test_raw[1:n]
    
    preds <- cnn_model() %>% predict(test_x_cnn)
    pred_labels <- apply(preds, 1, which.max) - 1
    
    cm <- table(True=test_y, Predicted=pred_labels)
    cm_df <- as.data.frame(cm)
    
    ggplot(cm_df, aes(x=Predicted, y=True, fill=Freq)) +
      geom_tile() +
      geom_text(aes(label=Freq), color="white") +
      scale_fill_gradient(low="blue", high="red") +
      theme_minimal() +
      labs(title="CNN Confusion Matrix")
  })

  ###############################################################
  # CNN INSIGHTS
  ###############################################################
  
  observeEvent(input$show_filter, {
    req(cnn_model())
    
    output$filter_viz <- renderPlot({
      filters <- get_weights(cnn_model()$layers[[1]])[[1]]
      f <- filters[,,1,input$filter_num]
      image(t(f[3:1,]), col=gray.colors(255), axes=FALSE,
            main=paste("Filter", input$filter_num))
    })
  })
  
  observeEvent(input$show_activation, {
    req(cnn_model())
    
    output$activation_map <- renderPlot({
      # Create intermediate model
      layer_output <- get_layer(cnn_model(), index=1)$output
      intermediate_model <- keras_model(
        inputs = cnn_model()$input,
        outputs = layer_output
      )
      
      # Get activation
      img <- x_train_cnn[input$idx,,,drop=FALSE]
      activation <- predict(intermediate_model, img)
      
      # Show first filter activation
      act <- activation[1,,,1]
      image(t(act[nrow(act):1,]), col=heat.colors(255), axes=FALSE,
            main="First Layer Activation")
    })
  })
}

shinyApp(ui, server)
