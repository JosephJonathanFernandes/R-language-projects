# Data Quality Checks for Sales Dataset
library(dplyr)

input_csv <- "data/sales_data.csv"
if (!file.exists(input_csv)) {
  stop("Raw data file not found: ", input_csv)
}
sales_data <- read.csv(input_csv, stringsAsFactors = FALSE)

checks <- list()

# Missing values summary
checks$missing_values <- colSums(is.na(sales_data))

# Basic numeric stats
num_cols <- c("quantity", "unit_price", "sales_amount", "profit")
checks$numeric_summary <- summary(sales_data[num_cols])

# Outlier detection using IQR rule
outlier_counts <- sapply(num_cols, function(col) {
  x <- sales_data[[col]]
  Q1 <- quantile(x, 0.25)
  Q3 <- quantile(x, 0.75)
  IQRv <- Q3 - Q1
  sum(x < (Q1 - 1.5 * IQRv) | x > (Q3 + 1.5 * IQRv))
})
checks$outliers <- outlier_counts

# Duplicate check (order_id uniqueness)
checks$duplicate_order_ids <- nrow(sales_data) - length(unique(sales_data$order_id))

# Categorical levels
cat_cols <- c("product_category", "region", "customer_age_group", "payment_method", "shipping_method")
level_counts <- lapply(cat_cols, function(col) {
  as.data.frame(sort(table(sales_data[[col]]), decreasing = TRUE))
})
names(level_counts) <- cat_cols
checks$category_distribution <- level_counts

# Compile text summary
report_path <- "reports/Data_Quality_Summary.txt"
con <- file(report_path, open = "wt")
writeLines("DATA QUALITY SUMMARY\n=====================", con)
writeLines(paste("Generated:", Sys.time()), con)
writeLines("\nMissing Values:\n----------------", con)
writeLines(capture.output(print(checks$missing_values)), con)
writeLines("\nNumeric Summary:\n----------------", con)
writeLines(capture.output(print(checks$numeric_summary)), con)
writeLines("\nOutlier Counts (IQR rule):\n-------------------------", con)
writeLines(capture.output(print(checks$outliers)), con)
writeLines("\nDuplicate order_id count:\n-------------------------", con)
writeLines(capture.output(print(checks$duplicate_order_ids)), con)
writeLines("\nCategory Distributions:\n----------------------", con)
for (nm in names(checks$category_distribution)) {
  writeLines(paste0("\n-- ", nm, " --"), con)
  writeLines(capture.output(print(checks$category_distribution[[nm]])), con)
}
close(con)

saveRDS(checks, file = "data/data_quality_checks.rds")
cat("✓ Data quality summary written to ", report_path, "\n", sep="")
