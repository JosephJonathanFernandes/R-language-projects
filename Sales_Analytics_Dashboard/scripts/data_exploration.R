# Data Processing and Exploration Script
library(dplyr)
library(lubridate)

# Load data
sales_data <- read.csv("data/sales_data.csv", stringsAsFactors = FALSE)

# Convert date column
sales_data$order_date <- as.Date(sales_data$order_date)

# Data Summary
cat("\n=== DATA SUMMARY ===\n")
print(summary(sales_data))

# Check for missing values
cat("\n=== MISSING VALUES ===\n")
print(colSums(is.na(sales_data)))

# Top performing categories
cat("\n=== TOP CATEGORIES BY SALES ===\n")
top_categories <- sales_data %>%
  group_by(product_category) %>%
  summarise(
    Total_Sales = sum(sales_amount),
    Total_Profit = sum(profit),
    Avg_Order_Value = mean(sales_amount),
    Order_Count = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Total_Sales))
print(top_categories)

# Regional analysis
cat("\n=== REGIONAL ANALYSIS ===\n")
regional_data <- sales_data %>%
  group_by(region) %>%
  summarise(
    Total_Sales = sum(sales_amount),
    Total_Profit = sum(profit),
    Avg_Order_Value = mean(sales_amount),
    Order_Count = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Total_Sales))
print(regional_data)

# Monthly trends
cat("\n=== MONTHLY SALES TREND ===\n")
sales_data$month <- floor_date(sales_data$order_date, "month")
monthly_data <- sales_data %>%
  group_by(month) %>%
  summarise(
    Total_Sales = sum(sales_amount),
    Total_Profit = sum(profit),
    Order_Count = n(),
    .groups = "drop"
  ) %>%
  arrange(month)
print(head(monthly_data, 12))

# Save processed data
saveRDS(sales_data, "data/sales_data_processed.rds")
cat("\n✓ Processed data saved to data/sales_data_processed.rds\n")
