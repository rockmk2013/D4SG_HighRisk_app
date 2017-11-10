library(shiny)

again_return <- reactive({
  # Read data
  test_again <- input$test_again
  test_again_data <- read.table(test_again$datapath,sep = ",",check.names=FALSE,header = TRUE,encoding = "utf-8")
  #
  #make model input data
  test_again = make_test_again_data(test_again_data)[[1]]
  test_ans = make_test_again_data(test_again_data)[[2]]
  test_id = make_test_again_data(test_again_data)[[3]]
  #load model and predit
  bst_again <- xgb.load("xgboost_again.model")
  
  #test set 
  Ypred_test =predict(bst_again,test_again)
  #outputresult
  pred <- ifelse(Ypred_test>0.5,1,0)
  
  #output 0
  # test_result_again = data.frame(test_id,test_ans,pred,Ypred_test)  %>% arrange(test_ans,Ypred_test)
  # names(test_result_again)=c("ID","Answer","Pred","Score")
  # again_accuracy = (table(test_ans,pred)[1,1]+table(test_ans,pred)[2,2])/sum(table(test_ans,pred))
  
  #output 1
  test_result_again = data.frame(test_id,pred,Ypred_test)  %>% arrange(pred,Ypred_test)
  names(test_result_again)=c("ID","Answer","Score")
 
  xgb.importance(feature_names = colnames(test_again), bst_again) %>% xgb.plot.importance(top_n=10)
  again_plot <- recordPlot()
  
  list("console_again" = test_result_again,
       #"accuracy_again" = again_accuracy,
       "figure_again" = again_plot
  )
  
})

make_test_again_data <- function(test_data){
  testid  = test_data$IDNO
  test_data = test_data[,-1]
  
  #-----test data transform to SMOTE form----
  cols.num <- colnames(test_data)
  test_data[cols.num] <- sapply(test_data[cols.num],as.numeric)
  sapply(test_data,class)
  test_data$isagain=as.factor(test_data$isagain)
  levels(test_data$isagain) = c("0","1")
  
  #--------transform to matrix-----------
  test_data <- sparse.model.matrix(~.-1, data = test_data)
  test_data <- data.frame(as.matrix(test_data))
  test_sample  <- test_data
  test_ans <- test_data$isagain1
  
  test_data <- subset(test_data, select = -c(isagain0,isagain1))
  testMatrix <- as.matrix(test_data)
  
  return(list("matrix" = testMatrix,
              "answer" = test_ans,
              "id" = testid
  ))
  
}


output$again_table = renderDataTable({
  again_table <- again_return()[["console_again"]]
})
output$again_imp_plot = renderPlot({
  plot <- again_return()[["figure_again"]]
  print(plot)
})
output$againaccuracy = renderText({
  # console <- again_return()[["accuracy_again"]]
  # accuracy = paste0("本次預測精準度為:",console)
  # print(accuracy)
})
output$downloadOutput_again <- downloadHandler(
  filename = 'again_console.csv',
  content = function(fname) {
    again_table <- again_return()[["console_again"]]
    write.csv(again_table, fname,row.names = FALSE)
  }
  
)

