#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################

library(shiny)

shinyServer(function(input, output, session) {

    maxLine <- 3

    output$p_table <- renderRHandsontable({
      df <- data.frame(values=rep(NaN,10))
      rhandsontable(df,selectCallback = TRUE) %>% hot_cols(colWidths =100)
    })

    output$table <- renderRHandsontable({
      df <- data.frame(time1=rep(NaN,20),conc1=rep(NaN,20))
      for(i in 2:maxLine){
        temp <- data.frame(rep(NaN,20),rep(NaN,20))
        colnames(temp) <- c(paste0("time",i),paste0("conc",i))
        df <- cbind(df,temp)
      }
      rhandsontable(df,selectCallback = TRUE) %>% hot_cols(colWidths =80)
    })
    
    observeEvent(input$submit,{
      
      df<-hot_to_r(input$table)
      data <-c()
      for(i in 1:maxLine){
        time <- df[,paste0("time",i)]
        time <- time[is.na(time)==F]
        len <- length(time) 
        if(len>0) {
          temp <- list(x=time, y=df[1:len,paste0("conc",i)])
          data <- c(data, list(temp))
        }
      }
      
      p <- hot_to_r(input$p_table)
      p <- p[is.na(p)==F]
      
      source("multi_rk.R")
      model <- nlm(p,data,isAbsError=TRUE)
      print(model)
      res <- summary(model)
      output$summary <- renderText(paste0(capture.output(res),"\n"))
      
     parms <- model$par
     sim <- c()
     for(i in 1:length(data)) {
       maxtime <- max(data[[i]]$x)
       if(!is.na(maxtime)){
         temp<-list(x=seq(0,maxtime,length.out=50))
         sim <- c(sim, list(temp))
       }
     }
      calc <- func(parms,sim)

      output$plots <- renderPlot({
        par(mfrow=c(2,2))
        par(mar = c(2, 2, 1, 1))
        par(oma = c(0, 0, 0, 0))
        for(i in 1:length(calc)){
          xmax<-max(sim[[i]]$x)
          ymin<-min(c(calc[[i]],data[[i]]$y))
          ymax<-max(c(calc[[i]],data[[i]]$y))
          plot(sim[[i]]$x,calc[[i]],xlim=c(0,xmax),ylim=c(ymin*0.8,ymax*1.2),type="l")
          par(new=T)
          plot(data[[i]]$x,data[[i]]$y,xlim=c(0,xmax),ylim=c(ymin*0.8,ymax*1.2),type="p",xaxt="n",yaxt="n")
        }
      })
      
      updateTabsetPanel(session, "tabs", selected = "Result")
    })
    
    session$onSessionEnded(function(){
        stopApp()
        q("no")
    })
})
