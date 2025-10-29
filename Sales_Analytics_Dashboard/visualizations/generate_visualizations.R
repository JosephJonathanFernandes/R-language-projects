# Generate static visualizations
library(ggplot2)
library(dplyr)
library(lubridate)

# Load processed data
sales_data <- readRDS("data/sales_data_processed.rds")

# Ensure month column exists
sales_data$month <- floor_date(sales_data$order_date, "month")

# 1. Sales Trend Over Time
p1 <- sales_data %>%
  group_by(month) %>%
  summarise(Total_Sales = sum(sales_amount), .groups = "drop") %>%
  ggplot(aes(x = month, y = Total_Sales)) +
  geom_line(color = "#2E86AB", size = 1) +
  geom_point(color = "#2E86AB", size = 3) +
  theme_minimal() +
  labs(
    title = "Sales Trend Over Time (2023)",
    x = "Month",
    y = "Total Sales ($)",
    subtitle = "Monthly sales performance"
  ) +
  theme(plot.title = element_text(face = "bold", size = 14),
        plot.subtitle = element_text(size = 10, color = "gray50"))

ggsave("visualizations/01_sales_trend.png", p1, width = 10, height = 6, dpi = 300)
cat("✓ Saved: 01_sales_trend.png\n")

# 2. Sales by Category
p2 <- sales_data %>%
  group_by(product_category) %>%
  summarise(Total_Sales = sum(sales_amount), .groups = "drop") %>%
  arrange(desc(Total_Sales)) %>%
  ggplot(aes(x = reorder(product_category, Total_Sales), y = Total_Sales, fill = product_category)) +
  geom_col() +
  coord_flip() +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Total Sales by Product Category",
    x = "Category",
    y = "Total Sales ($)"
  ) +
  theme(plot.title = element_text(face = "bold", size = 14),
        legend.position = "none")

ggsave("visualizations/02_sales_by_category.png", p2, width = 10, height = 6, dpi = 300)
cat("✓ Saved: 02_sales_by_category.png\n")

# 3. Regional Distribution
p3 <- sales_data %>%
  group_by(region) %>%
  summarise(Total_Sales = sum(sales_amount), .groups = "drop") %>%
  ggplot(aes(x = region, y = Total_Sales, fill = region)) +
  geom_col() +
  theme_minimal() +
  scale_fill_brewer(palette = "Pastel1") +
  labs(
    title = "Sales Distribution by Region",
    x = "Region",
    y = "Total Sales ($)"
  ) +
  theme(plot.title = element_text(face = "bold", size = 14),
        legend.position = "none") +
  geom_text(aes(label = paste0("$", round(Total_Sales/1000, 1), "K")), vjust = -0.5)

ggsave("visualizations/03_regional_distribution.png", p3, width = 10, height = 6, dpi = 300)
cat("✓ Saved: 03_regional_distribution.png\n")

# 4. Profit vs Sales Scatter
p4 <- sales_data %>%
  group_by(product_category) %>%
  summarise(Total_Sales = sum(sales_amount), 
            Total_Profit = sum(profit),
            Order_Count = n(),
            .groups = "drop") %>%
  ggplot(aes(x = Total_Sales, y = Total_Profit, size = Order_Count, color = product_category)) +
  geom_point(alpha = 0.6) +
  theme_minimal() +
  scale_color_brewer(palette = "Dark2") +
  labs(
    title = "Profit vs Sales by Category",
    x = "Total Sales ($)",
    y = "Total Profit ($)",
    size = "Order Count",
    color = "Category"
  ) +
  theme(plot.title = element_text(face = "bold", size = 14))

ggsave("visualizations/04_profit_vs_sales.png", p4, width = 10, height = 6, dpi = 300)
cat("✓ Saved: 04_profit_vs_sales.png\n")

# 5. Customer Demographics - Age Group Distribution
p5 <- sales_data %>%
  group_by(customer_age_group) %>%
  summarise(Total_Sales = sum(sales_amount), .groups = "drop") %>%
  ggplot(aes(x = factor(customer_age_group, levels = c("18-25", "26-35", "36-45", "46-55", "55+")), 
             y = Total_Sales, fill = customer_age_group)) +
  geom_col() +
  theme_minimal() +
  scale_fill_brewer(palette = "Spectral") +
  labs(
    title = "Sales by Customer Age Group",
    x = "Age Group",
    y = "Total Sales ($)"
  ) +
  theme(plot.title = element_text(face = "bold", size = 14),
        legend.position = "none")

ggsave("visualizations/05_age_group_distribution.png", p5, width = 10, height = 6, dpi = 300)
cat("✓ Saved: 05_age_group_distribution.png\n")

# 6. Payment Method Preference
p6 <- sales_data %>%
  group_by(payment_method) %>%
  summarise(Count = n(), Total_Sales = sum(sales_amount), .groups = "drop") %>%
  ggplot(aes(x = "", y = Count, fill = payment_method)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3") +
  labs(
    title = "Payment Method Distribution",
    fill = "Payment Method"
  ) +
  theme(plot.title = element_text(face = "bold", size = 14),
        axis.text = element_blank(),
        axis.title = element_blank())

ggsave("visualizations/06_payment_method.png", p6, width = 8, height = 8, dpi = 300)
cat("✓ Saved: 06_payment_method.png\n")

cat("\n✓ All visualizations generated successfully!\n")
