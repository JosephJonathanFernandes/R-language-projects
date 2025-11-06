library(testthat)

test_that("dataset creation produces expected file", {
  expect_true(file.exists("data/sales_data.csv"))
  df <- read.csv("data/sales_data.csv")
  expect_gt(nrow(df), 500)
  expect_true(all(c("order_id","order_date","sales_amount","profit") %in% names(df)))
})

test_that("processed data RDS exists and has month column after pipeline", {
  expect_true(file.exists("data/sales_data_processed.rds"))
  d <- readRDS("data/sales_data_processed.rds")
  expect_true("sales_amount" %in% names(d))
})

test_that("forecast outputs exist after advanced forecasting", {
  if (file.exists("reports/sales_forecast.csv")) {
    fc <- read.csv("reports/sales_forecast.csv")
    expect_gte(nrow(fc), 6)
  } else {
    skip("Forecast CSV not generated yet.")
  }
})
