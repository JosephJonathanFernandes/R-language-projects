# Create synthetic e-commerce dataset
set.seed(42)

# Generate sample data
n_records <- 1000

sales_data <- data.frame(
  order_id = 1:n_records,
  order_date = sample(seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by="day"), n_records, replace=TRUE),
  product_category = sample(c("Electronics", "Clothing", "Home & Kitchen", "Sports", "Books"), n_records, replace=TRUE),
  quantity = sample(1:10, n_records, replace=TRUE),
  unit_price = sample(c(50, 100, 150, 200, 300, 500), n_records, replace=TRUE),
  region = sample(c("North", "South", "East", "West"), n_records, replace=TRUE),
  customer_age_group = sample(c("18-25", "26-35", "36-45", "46-55", "55+"), n_records, replace=TRUE),
  payment_method = sample(c("Credit Card", "Debit Card", "PayPal", "UPI"), n_records, replace=TRUE),
  shipping_method = sample(c("Standard", "Express", "Overnight"), n_records, replace=TRUE)
)

# Calculate sales and profit
sales_data$sales_amount <- sales_data$quantity * sales_data$unit_price
sales_data$profit <- sales_data$sales_amount * runif(n_records, 0.15, 0.35)  # 15-35% profit margin

# Order by date
sales_data <- sales_data[order(sales_data$order_date), ]

# Save to CSV
write.csv(sales_data, "data/sales_data.csv", row.names=FALSE)

print("Dataset created successfully!")
print(head(sales_data))
print(paste("Total records:", nrow(sales_data)))
