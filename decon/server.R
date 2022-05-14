#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################

library(shiny)

shinyServer(function(input, output,session) {

  df <- data.frame(time_iv=rep(NaN,20),conc_iv=rep(NaN,20),time_po=rep(NaN,20),conc_po=rep(NaN,20))
  
  output$table <- renderRHandsontable({
    rhandsontable(df,selectCallback = TRUE) %>% hot_cols(colWidths =100)
  })
  
  observeEvent(input$submit,{
    
    df<-hot_to_r(input$table)
    x_iv <- df[,"time_iv"]
    y_iv <- df[,"conc_iv"]
    x_po <- df[,"time_po"]
    y_po <- df[,"conc_po"]
    
    source("decon.R",local=TRUE)
    res <- deconvolution(x_iv,y_iv,x_po,y_po)
      
    output$plot <- renderPlot({
      plot(res,type="o")
    })
    
    output$result <- renderTable(res,digits=4)
    
    updateTabsetPanel(session, "tabs", selected = "Result")
  })
  
  session$onSessionEnded(function(){
    stopApp()
    q("no")
  })
})
