# Generate Automated Report
library(dplyr)
library(lubridate)

# Load data
sales_data <- readRDS("data/sales_data_processed.rds")
sales_data$month <- floor_date(sales_data$order_date, "month")

# Generate report
report <- paste0("
================================================================================
                    SALES ANALYTICS REPORT - 2023
================================================================================
Generated on: ", Sys.Date(), "

EXECUTIVE SUMMARY
================================================================================
Total Sales:          $", format(round(sum(sales_data$sales_amount), 2), big.mark=","), "
Total Profit:         $", format(round(sum(sales_data$profit), 2), big.mark=","), "
Total Orders:         ", nrow(sales_data), "
Average Order Value:  $", format(round(mean(sales_data$sales_amount), 2), big.mark=","), "
Profit Margin:        ", format(round(sum(sales_data$profit)/sum(sales_data$sales_amount)*100, 1), trim=TRUE), "%

KEY PERFORMANCE INDICATORS
================================================================================
Top Performing Category:    ", 
  sales_data %>% group_by(product_category) %>% summarise(Total_Sales = sum(sales_amount), .groups = "drop") %>% arrange(desc(Total_Sales)) %>% slice(1) %>% pull(product_category), "
Top Performing Region:      ", 
  sales_data %>% group_by(region) %>% summarise(Total_Sales = sum(sales_amount), .groups = "drop") %>% arrange(desc(Total_Sales)) %>% slice(1) %>% pull(region), "
Best Age Group:             ", 
  sales_data %>% group_by(customer_age_group) %>% summarise(Total_Sales = sum(sales_amount), .groups = "drop") %>% arrange(desc(Total_Sales)) %>% slice(1) %>% pull(customer_age_group), "
Most Popular Payment:       ", 
  sales_data %>% group_by(payment_method) %>% summarise(Count = n(), .groups = "drop") %>% arrange(desc(Count)) %>% slice(1) %>% pull(payment_method), "

SALES BY CATEGORY
================================================================================
")

# Category breakdown
cat_stats <- sales_data %>%
  group_by(product_category) %>%
  summarise(
    Total_Sales = sum(sales_amount),
    Total_Profit = sum(profit),
    Order_Count = n(),
    Avg_Order = mean(sales_amount),
    .groups = "drop"
  ) %>%
  arrange(desc(Total_Sales))

for (i in 1:nrow(cat_stats)) {
  row <- cat_stats[i, ]
  report <- paste0(report, "\n", row$product_category, ":")
  report <- paste0(report, "\n  Sales:        $", format(round(row$Total_Sales, 2), big.mark=","))
  report <- paste0(report, "\n  Profit:       $", format(round(row$Total_Profit, 2), big.mark=","))
  report <- paste0(report, "\n  Orders:       ", row$Order_Count)
  report <- paste0(report, "\n  Avg Order:    $", format(round(row$Avg_Order, 2), big.mark=","))
}

report <- paste0(report, "\n\nSALES BY REGION\n================================================================================\n")

# Regional breakdown
reg_stats <- sales_data %>%
  group_by(region) %>%
  summarise(
    Total_Sales = sum(sales_amount),
    Total_Profit = sum(profit),
    Order_Count = n(),
    Avg_Order = mean(sales_amount),
    .groups = "drop"
  ) %>%
  arrange(desc(Total_Sales))

for (i in 1:nrow(reg_stats)) {
  row <- reg_stats[i, ]
  report <- paste0(report, "\n", row$region, " Region:")
  report <- paste0(report, "\n  Sales:        $", format(round(row$Total_Sales, 2), big.mark=","))
  report <- paste0(report, "\n  Profit:       $", format(round(row$Total_Profit, 2), big.mark=","))
  report <- paste0(report, "\n  Orders:       ", row$Order_Count)
  report <- paste0(report, "\n  Avg Order:    $", format(round(row$Avg_Order, 2), big.mark=","))
}

report <- paste0(report, "\n\nMONTHLY TRENDS\n================================================================================\n")
report <- paste0(report, "Month          Sales              Profit            Orders\n")
report <- paste0(report, "--------       --------           --------          --------\n")

# Monthly breakdown
month_stats <- sales_data %>%
  group_by(month) %>%
  summarise(
    Total_Sales = sum(sales_amount),
    Total_Profit = sum(profit),
    Order_Count = n(),
    .groups = "drop"
  )

for (i in 1:nrow(month_stats)) {
  row <- month_stats[i, ]
  report <- paste0(report, format(row$month, "%B"), 
                   "      $", format(round(row$Total_Sales, 0), width=6, justify="right"),
                   "     $", format(round(row$Total_Profit, 0), width=6, justify="right"),
                   "     ", format(row$Order_Count, width=3, justify="right"), "\n")
}

report <- paste0(report, "\n\nRECOMMENDATIONS\n================================================================================\n")
report <- paste0(report, "
1. CATEGORY FOCUS
   - Focus marketing efforts on ", 
   cat_stats %>% slice(1) %>% pull(product_category), 
   " which is the top performer
   - Develop strategies to boost underperforming categories

2. REGIONAL EXPANSION
   - Strengthen presence in ", 
   reg_stats %>% slice(1) %>% pull(region), 
   " region (highest sales)
   - Analyze factors contributing to regional performance gaps

3. SEASONAL TRENDS
   - Identify peak sales periods and plan inventory accordingly
   - Plan promotional campaigns during low seasons

4. CUSTOMER ENGAGEMENT
   - Target high-value age groups with premium offerings
   - Optimize payment and shipping methods based on customer preference

================================================================================
End of Report
================================================================================
")

# Print and save report
cat(report)
writeLines(report, "reports/Sales_Analytics_Report.txt")
cat("\n✓ Report saved to: reports/Sales_Analytics_Report.txt\n")
