library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(xgboost)
library(randomForest)
library(Matrix)

windowsFonts(BL = windowsFont("微軟正黑體"))

shinyServer(function(input, output) {
  
  options(scipen = 10)
  source('tabEntering.R', local=TRUE, encoding = "utf-8")
  source('tabAgain.R', local=TRUE, encoding = "utf-8")
})
