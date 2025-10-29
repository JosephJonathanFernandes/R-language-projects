# Shiny Dashboard Application
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)
library(lubridate)

# Load data
sales_data <- readRDS("../data/sales_data_processed.rds")
sales_data$month <- floor_date(sales_data$order_date, "month")

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Sales Analytics Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("chart-line")),
      menuItem("Sales Analysis", tabName = "sales", icon = icon("chart-bar")),
      menuItem("Regional Performance", tabName = "regional", icon = icon("map")),
      menuItem("Customer Insights", tabName = "customers", icon = icon("users")),
      menuItem("Raw Data", tabName = "data", icon = icon("table"))
    ),
    hr(),
    h4("Filters"),
    selectInput("category_filter", "Category:",
                choices = c("All", unique(sales_data$product_category)),
                selected = "All"),
    selectInput("region_filter", "Region:",
                choices = c("All", unique(sales_data$region)),
                selected = "All")
  ),
  dashboardBody(
    tabItems(
      # Tab 1: Overview
      tabItem(tabName = "overview",
              h2("Dashboard Overview"),
              fluidRow(
                valueBox(
                  value = paste0("$", format(round(sum(sales_data$sales_amount)/1000, 1), trim = TRUE), "K"),
                  subtitle = "Total Sales",
                  icon = icon("dollar-sign"),
                  color = "blue"
                ),
                valueBox(
                  value = paste0("$", format(round(sum(sales_data$profit)/1000, 1), trim = TRUE), "K"),
                  subtitle = "Total Profit",
                  icon = icon("coins"),
                  color = "green"
                ),
                valueBox(
                  value = nrow(sales_data),
                  subtitle = "Total Orders",
                  icon = icon("shopping-cart"),
                  color = "yellow"
                )
              ),
              fluidRow(
                box(
                  plotlyOutput("overview_trend"),
                  width = 12,
                  title = "Sales Trend"
                )
              ),
              fluidRow(
                box(
                  plotlyOutput("overview_category"),
                  width = 6,
                  title = "Top Categories"
                ),
                box(
                  plotlyOutput("overview_region"),
                  width = 6,
                  title = "Regional Sales"
                )
              )
      ),
      
      # Tab 2: Sales Analysis
      tabItem(tabName = "sales",
              h2("Sales Analysis"),
              fluidRow(
                box(
                  plotlyOutput("sales_category_bar"),
                  width = 6,
                  title = "Sales by Category"
                ),
                box(
                  plotlyOutput("sales_profit_scatter"),
                  width = 6,
                  title = "Profit vs Sales"
                )
              ),
              fluidRow(
                box(
                  plotlyOutput("sales_monthly"),
                  width = 12,
                  title = "Monthly Sales & Profit Trend"
                )
              )
      ),
      
      # Tab 3: Regional Performance
      tabItem(tabName = "regional",
              h2("Regional Performance"),
              fluidRow(
                box(
                  plotlyOutput("regional_sales"),
                  width = 6,
                  title = "Sales by Region"
                ),
                box(
                  plotlyOutput("regional_orders"),
                  width = 6,
                  title = "Order Count by Region"
                )
              ),
              fluidRow(
                box(
                  plotlyOutput("regional_category"),
                  width = 12,
                  title = "Category Performance by Region"
                )
              )
      ),
      
      # Tab 4: Customer Insights
      tabItem(tabName = "customers",
              h2("Customer Insights"),
              fluidRow(
                box(
                  plotlyOutput("customer_age"),
                  width = 6,
                  title = "Sales by Age Group"
                ),
                box(
                  plotlyOutput("customer_payment"),
                  width = 6,
                  title = "Payment Method Distribution"
                )
              ),
              fluidRow(
                box(
                  plotlyOutput("customer_shipping"),
                  width = 12,
                  title = "Shipping Method Analysis"
                )
              )
      ),
      
      # Tab 5: Raw Data
      tabItem(tabName = "data",
              h2("Raw Data View"),
              dataTableOutput("data_table")
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  # Reactive data filtering
  filtered_data <- reactive({
    data <- sales_data
    if (input$category_filter != "All") {
      data <- data %>% filter(product_category == input$category_filter)
    }
    if (input$region_filter != "All") {
      data <- data %>% filter(region == input$region_filter)
    }
    data
  })
  
  # Overview - Trend
  output$overview_trend <- renderPlotly({
    data <- filtered_data() %>%
      group_by(month) %>%
      summarise(Total_Sales = sum(sales_amount), .groups = "drop")
    
    plot_ly(data, x = ~month, y = ~Total_Sales, type = "scatter", mode = "lines+markers",
            line = list(color = "#2E86AB", width = 2),
            marker = list(size = 8, color = "#2E86AB")) %>%
      layout(title = "Sales Trend", xaxis = list(title = "Date"), 
             yaxis = list(title = "Total Sales ($)"))
  })
  
  # Overview - Category
  output$overview_category <- renderPlotly({
    data <- filtered_data() %>%
      group_by(product_category) %>%
      summarise(Total_Sales = sum(sales_amount), .groups = "drop") %>%
      arrange(desc(Total_Sales)) %>%
      head(5)
    
    plot_ly(data, x = ~reorder(product_category, Total_Sales), y = ~Total_Sales,
            type = "bar", marker = list(color = "#A23B72")) %>%
      layout(title = "Top 5 Categories", xaxis = list(title = "Category"),
             yaxis = list(title = "Sales ($)"))
  })
  
  # Overview - Region
  output$overview_region <- renderPlotly({
    data <- filtered_data() %>%
      group_by(region) %>%
      summarise(Total_Sales = sum(sales_amount), .groups = "drop")
    
    plot_ly(data, x = ~region, y = ~Total_Sales, type = "bar",
            marker = list(color = "#F18F01")) %>%
      layout(title = "Sales by Region", xaxis = list(title = "Region"),
             yaxis = list(title = "Sales ($)"))
  })
  
  # Sales - Category Bar
  output$sales_category_bar <- renderPlotly({
    data <- filtered_data() %>%
      group_by(product_category) %>%
      summarise(Total_Sales = sum(sales_amount), .groups = "drop") %>%
      arrange(desc(Total_Sales))
    
    plot_ly(data, x = ~product_category, y = ~Total_Sales, type = "bar",
            marker = list(color = ~Total_Sales, colorscale = "Blues")) %>%
      layout(title = "Sales by Category", xaxis = list(title = "Category"),
             yaxis = list(title = "Sales ($)"))
  })
  
  # Sales - Profit Scatter
  output$sales_profit_scatter <- renderPlotly({
    data <- filtered_data() %>%
      group_by(product_category) %>%
      summarise(Total_Sales = sum(sales_amount),
                Total_Profit = sum(profit),
                Order_Count = n(),
                .groups = "drop")
    
    plot_ly(data, x = ~Total_Sales, y = ~Total_Profit, size = ~Order_Count,
            text = ~product_category, mode = "markers",
            marker = list(sizemode = "diameter", sizeref = 2*max(data$Order_Count)/(40^2),
                         color = ~Total_Profit, colorscale = "Viridis", showscale = TRUE)) %>%
      layout(title = "Profit vs Sales", xaxis = list(title = "Total Sales ($)"),
             yaxis = list(title = "Total Profit ($)"))
  })
  
  # Sales - Monthly
  output$sales_monthly <- renderPlotly({
    data <- filtered_data() %>%
      group_by(month) %>%
      summarise(Total_Sales = sum(sales_amount),
                Total_Profit = sum(profit),
                .groups = "drop")
    
    plot_ly(data, x = ~month) %>%
      add_trace(y = ~Total_Sales, name = "Sales", type = "scatter", mode = "lines",
               line = list(color = "#2E86AB", width = 2)) %>%
      add_trace(y = ~Total_Profit, name = "Profit", type = "scatter", mode = "lines",
               line = list(color = "#A23B72", width = 2)) %>%
      layout(title = "Monthly Sales & Profit", xaxis = list(title = "Month"),
             yaxis = list(title = "Amount ($)"))
  })
  
  # Regional - Sales
  output$regional_sales <- renderPlotly({
    data <- filtered_data() %>%
      group_by(region) %>%
      summarise(Total_Sales = sum(sales_amount), .groups = "drop")
    
    plot_ly(data, labels = ~region, values = ~Total_Sales, type = "pie") %>%
      layout(title = "Sales Distribution by Region")
  })
  
  # Regional - Orders
  output$regional_orders <- renderPlotly({
    data <- filtered_data() %>%
      group_by(region) %>%
      summarise(Order_Count = n(), .groups = "drop")
    
    plot_ly(data, x = ~region, y = ~Order_Count, type = "bar",
            marker = list(color = "#06A77D")) %>%
      layout(title = "Orders by Region", xaxis = list(title = "Region"),
             yaxis = list(title = "Order Count"))
  })
  
  # Regional - Category
  output$regional_category <- renderPlotly({
    data <- filtered_data() %>%
      group_by(region, product_category) %>%
      summarise(Total_Sales = sum(sales_amount), .groups = "drop")
    
    plot_ly(data, x = ~region, y = ~Total_Sales, color = ~product_category,
            type = "bar") %>%
      layout(title = "Category Performance by Region", barmode = "stack",
             xaxis = list(title = "Region"), yaxis = list(title = "Sales ($)"))
  })
  
  # Customer - Age
  output$customer_age <- renderPlotly({
    data <- filtered_data() %>%
      group_by(customer_age_group) %>%
      summarise(Total_Sales = sum(sales_amount), .groups = "drop")
    
    plot_ly(data, x = ~factor(customer_age_group, levels = c("18-25", "26-35", "36-45", "46-55", "55+")),
            y = ~Total_Sales, type = "bar", marker = list(color = "#FF6B6B")) %>%
      layout(title = "Sales by Age Group", xaxis = list(title = "Age Group"),
             yaxis = list(title = "Sales ($)"))
  })
  
  # Customer - Payment
  output$customer_payment <- renderPlotly({
    data <- filtered_data() %>%
      group_by(payment_method) %>%
      summarise(Count = n(), .groups = "drop")
    
    plot_ly(data, labels = ~payment_method, values = ~Count, type = "pie") %>%
      layout(title = "Payment Method Distribution")
  })
  
  # Customer - Shipping
  output$customer_shipping <- renderPlotly({
    data <- filtered_data() %>%
      group_by(shipping_method) %>%
      summarise(Total_Sales = sum(sales_amount), Order_Count = n(), .groups = "drop")
    
    plot_ly(data, x = ~shipping_method, y = ~Total_Sales, type = "bar",
            marker = list(color = "#4ECDC4")) %>%
      layout(title = "Sales by Shipping Method", xaxis = list(title = "Shipping Method"),
             yaxis = list(title = "Sales ($)"))
  })
  
  # Data Table
  output$data_table <- renderDataTable({
    filtered_data()
  })
}

# Run the app
shinyApp(ui, server)
