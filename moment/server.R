#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################

library(shiny)

shinyServer(function(input, output,session) {

  df <- data.frame(time=rep(NaN,20),conc=rep(NaN,20))
  output$table <- renderRHandsontable({
    rhandsontable(df,selectCallback = TRUE) %>% hot_cols(colWidths =100)
  })
  
  observeEvent(input$submit,{
    
    source("moment.R", local=TRUE)

    data_table <- hot_to_r(input$table)
    time<-data_table[,1]
    conc<-data_table[,2]
    time<-time[is.na(time)==F]
    conc<-conc[is.na(conc)==F]
    res <- moment(time,conc,as.numeric(input$n1),as.numeric(input$n0))
    
    output$plot <- renderPlot({
      par(mfrow=c(1,2))
      plot(data_table[,1],data_table[,2], xlim=c(0,max(time)), ylim=c(0,max(conc)*1.2),
           main="normal plot",xlab="time",ylab="conc",type="o")
      plot(data_table[,1],data_table[,2], xlim=c(0,max(time)), ylim=c(min(conc)*0.8,max(conc)*1.2),
        log="y",main="log plot",xlab="time",ylab="log(conc)")
      par(new=T)
      plot(res$pdata1, xlim=c(0,max(time)), ylim=c(min(conc)*0.8,max(conc)*1.2),
           log="y",xaxt="n",yaxt="n",type="l", lty="dashed", xlab="", ylab="")
      par(new=T)
      if(!is.null(res$pdata0)) {
          plot(res$pdata0, xlim=c(0,max(time)), ylim=c(min(conc)*0.8,max(conc)*1.2),
            log="y",xaxt="n",yaxt="n",type="l", xlab="", ylab="")
      }
    })

    output$moment <- renderTable(res$moment, digits=4)
    
    updateTabsetPanel(session, "tabs", selected = "Result")
  })
  
#  session$onSessionEnded(function(){
#    stopApp()
#    q("no")
#  })
  
})
