# Advanced Forecasting and Segmentation
library(dplyr)
library(lubridate)

processed_path <- "data/sales_data_processed.rds"
if (!file.exists(processed_path)) stop("Processed data not found: ", processed_path)
sales_data <- readRDS(processed_path)
sales_data$month <- floor_date(as.Date(sales_data$order_date), "month")

# Aggregate monthly sales
monthly <- sales_data %>% group_by(month) %>% summarise(Total_Sales = sum(sales_amount), .groups = "drop")

# Forecast next 6 months using available method
forecast_df <- NULL
plot_path <- "visualizations/07_sales_forecast.png"
csv_path <- "reports/sales_forecast.csv"

do_plot <- function(df_hist, df_fcst, title) {
  # Base plot
  png(plot_path, width=1000, height=600)
  plot(df_hist$month, df_hist$Total_Sales, type='l', col="#2E86AB", lwd=2,
       main=title, xlab="Month", ylab="Total Sales ($)")
  points(df_hist$month, df_hist$Total_Sales, pch=16, col="#2E86AB")
  if (!is.null(df_fcst)) {
    lines(df_fcst$month, df_fcst$Total_Sales, col="#A23B72", lwd=2, lty=2)
    points(df_fcst$month, df_fcst$Total_Sales, pch=17, col="#A23B72")
    legend("topleft", legend=c("History", "Forecast"), col=c("#2E86AB", "#A23B72"), lty=c(1,2), lwd=2, pch=c(16,17))
  }
  dev.off()
}

fc_h <- 6
fc_title <- "Monthly Sales Forecast (6 months)"

if (requireNamespace("prophet", quietly = TRUE)) {
  # Prophet-based forecast
  df <- data.frame(ds = monthly$month, y = monthly$Total_Sales)
  m <- prophet::prophet(df)
  future <- prophet::make_future_dataframe(m, periods = fc_h, freq = "month")
  fc <- prophet::predict(m, future)
  fc_sub <- fc[(nrow(fc)-fc_h+1):nrow(fc), c("ds","yhat")]
  colnames(fc_sub) <- c("month","Total_Sales")
  forecast_df <- fc_sub
  write.csv(forecast_df, csv_path, row.names=FALSE)
  do_plot(monthly, forecast_df, paste0(fc_title, " - prophet"))
} else if (requireNamespace("forecast", quietly = TRUE)) {
  # ARIMA-based forecast
  ts_data <- ts(monthly$Total_Sales, frequency = 12)
  fit <- forecast::auto.arima(ts_data)
  fc <- forecast::forecast(fit, h = fc_h)
  fc_vals <- as.numeric(fc$mean)
  future_months <- seq(max(monthly$month) %m+% months(1), by = "month", length.out = fc_h)
  forecast_df <- data.frame(month = future_months, Total_Sales = fc_vals)
  write.csv(forecast_df, csv_path, row.names=FALSE)
  do_plot(monthly, forecast_df, paste0(fc_title, " - ARIMA"))
} else {
  # Simple linear model fallback
  df <- monthly %>% mutate(t = as.numeric(month - min(month)))
  fit <- lm(Total_Sales ~ t, data = df)
  future_t <- max(df$t) + seq_len(fc_h)
  future_months <- seq(max(df$month) %m+% months(1), by = "month", length.out = fc_h)
  preds <- predict(fit, newdata = data.frame(t = future_t))
  forecast_df <- data.frame(month = future_months, Total_Sales = as.numeric(preds))
  write.csv(forecast_df, csv_path, row.names=FALSE)
  do_plot(monthly, forecast_df, paste0(fc_title, " - Linear Model"))
}

cat("✓ Forecast saved to:", csv_path, "and", plot_path, "\n")

# Simple Segmentation: Cluster product categories by performance
seg_plot <- "visualizations/08_category_clusters.png"
seg_csv <- "reports/category_clusters.csv"

perf <- sales_data %>%
  group_by(product_category) %>%
  summarise(
    Total_Sales = sum(sales_amount),
    Total_Profit = sum(profit),
    Avg_Order = mean(sales_amount),
    Orders = n(),
    .groups = "drop"
  )

# Scale features and kmeans with k=3 (small dataset)
set.seed(42)
X <- scale(perf[, c("Total_Sales","Total_Profit","Avg_Order","Orders")])
km <- kmeans(X, centers = 3, nstart = 25)
perf$Cluster <- factor(km$cluster)
write.csv(perf, seg_csv, row.names = FALSE)

# 2D plot using two features
png(seg_plot, width=1000, height=600)
plot(perf$Total_Sales, perf$Total_Profit, col = perf$Cluster, pch=19,
     xlab="Total Sales", ylab="Total Profit", main="Category Clusters (k=3)")
text(perf$Total_Sales, perf$Total_Profit, labels = perf$product_category, pos=3, cex=0.9)
legend("topleft", legend = levels(perf$Cluster), col = 1:3, pch=19, title="Cluster")
dev.off()

cat("✓ Segmentation outputs saved to:", seg_csv, "and", seg_plot, "\n")
