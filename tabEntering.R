library(shiny)

entering_return <- reactive({
  # Read data
  test <- input$test_entering
  test_data <- read.table(test$datapath,sep = ",",check.names=FALSE,header = TRUE,encoding = "utf-8")
  #
  #make model input data
  test_enter = make_test_data(test_data)[[1]]
  test_ans = make_test_data(test_data)[[2]]
  test_id = make_test_data(test_data)[[3]]
  #load model and predit
  bst_enter <- xgb.load("xgboost_entering.model")
  
  #test set 
  Ypred_test =predict(bst_enter, test_enter)
  #outputresult
  pred <- ifelse(Ypred_test>0.5,1,0)

  #output 0
  # test_result_enter = data.frame(test_id,test_ans,pred,Ypred_test) %>% arrange(test_ans,Ypred_test)
  # names(test_result_enter)=c("ID","Answer","Pred","Score")
  # entering_accuracy = (table(test_ans,pred)[1,1]+table(test_ans,pred)[2,2])/sum(table(test_ans,pred))
  #output 1
  test_result_enter = data.frame(test_id,pred,Ypred_test) %>% arrange(pred,Ypred_test)
  names(test_result_enter)=c("ID","Pred","Score")
  

  xgb.importance(feature_names = colnames(test_enter), bst_enter) %>% xgb.plot.importance(top_n=10)
  plot <- recordPlot()
  
  list("console" = test_result_enter,
       #"accuracy" = entering_accuracy,
       "figure" = plot
       )
  
})

make_test_data <- function(test_data){
  testid  = test_data$IDNO
  test_data = test_data[,-1]
  #-----test data transform to SMOTE form----
  cols.num <- colnames(test_data)
  test_data[cols.num] <- sapply(test_data[cols.num],as.numeric)
  sapply(test_data,class)
  test_data$is_enter=as.factor(test_data$is_enter)
  levels(test_data$is_enter) = c("0","1")
  
  #--------transform to matrix-----------
  test_data <- sparse.model.matrix(~.-1, data = test_data)
  test_data <- data.frame(as.matrix(test_data))
  test_sample  <- test_data
  test_ans <- test_data$is_enter1
  
  test_data <- subset(test_data, select = -c(is_enter0,is_enter1))
  testMatrix <- as.matrix(test_data)
  
  return(list("matrix" = testMatrix,
              "answer" = test_ans,
              "id" = testid
  ))
  
}


output$entering_table = renderDataTable({
  entering_table <- entering_return()[["console"]]
  })
output$imp_plot = renderPlot({
  plot <- entering_return()[["figure"]]
  print(plot)
})
output$accuracy = renderText({
  # console <- entering_return()[["accuracy"]]
  # accuracy = paste0("本次預測精準度為:",console)
  # print(accuracy)
})
output$downloadOutput_entering <- downloadHandler(
  filename = 'entering_console.csv',
  content = function(fname) {
    entering_table <- entering_return()[["console"]]
    write.csv(entering_table, fname,row.names = FALSE)
  }

)

