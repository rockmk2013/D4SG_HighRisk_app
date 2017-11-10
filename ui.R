library(shinythemes)
shinyUI(fluidPage(theme = shinytheme("journal"),
                  tags$head(
                    tags$link(rel = "stylesheet", type = "text/css", href = "tmp.css"),
                    tags$link(rel="shortcut icon", href="icon.png")
                  ),
                  
                  titlePanel(
                    div("D4SG High Risk Caculator"),
                    windowTitle = "D4SG High Risk Caculator"
                  ),
                  navlistPanel(
                    "Methods",
                    tabPanel("Methods",
                             h2('使用教學'),
                             HTML('<br><br>'),
                             HTML('<center><img src="method.jpg" height=auto width=auto></center>')
                    ),
                    
                    "Data",
                    tabPanel("Data Input",
                             h2("請選擇需預測重複通報之個案資料"),
                             HTML('<br>'),
                             #HTML('<center><img src="multi.png" height=auto width=auto></center>'),
                             #HTML('<br>'),
                             fileInput("test_again", "Choose CSV File",
                                       accept = c(
                                         "text/csv",
                                         "text/comma-separated-values,text/plain",
                                         ".csv")
                             ),
                             HTML('<br><br>'),
                             h2("請選擇需預測進入家防之個案資料"),
                             HTML('<br>'),
                             #HTML('<center><img src="multi.png" height=auto width=auto></center>'),
                             #HTML('<br>'),
                             fileInput("test_entering", "Choose CSV File",
                                       accept = c(
                                         "text/csv",
                                         "text/comma-separated-values,text/plain",
                                         ".csv")
                             ),
                             HTML('<br><br>')
                    ),
                    
                    "Output",
                    tabPanel("Predict Again Output",
                             tabsetPanel(
                               tabPanel("Again", 
                                        downloadButton("downloadOutput_again", "DownloadOuput!"),
                                        HTML('<br>'),
                                        HTML('<br>'),
                                        textOutput("againaccuracy"),
                                        HTML('<center><h2>預測是否可能為通報回頭客</h2></center>'),
                                        dataTableOutput("again_table"),
                                        HTML('<br>'),
                                        HTML('<br>'),
                                        HTML('<center><h2>重要程度圖表</h2></center>'),
                                        plotOutput("again_imp_plot"),
                                        HTML('<br>'),
                                        HTML('<br>')
                               ))),
                    tabPanel("Predict Entering Output",
                             tabsetPanel(
                               tabPanel("Entering", 
                                        downloadButton("downloadOutput_entering", "DownloadOuput!"),
                                        HTML('<br>'),
                                        HTML('<br>'),
                                        textOutput("accuracy"),
                                        HTML('<center><h2>預測是否進入家防</h2></center>'),
                                        dataTableOutput("entering_table"),
                                        HTML('<br>'),
                                        HTML('<br>'),
                                        HTML('<center><h2>重要程度圖表</h2></center>'),
                                        plotOutput("imp_plot"),
                                        HTML('<br>'),
                                        HTML('<br>')
                               ))),
                     fluid = TRUE)))