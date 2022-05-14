#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################

library(shiny)
library(rhandsontable)

shinyUI(fluidPage(

  titlePanel("デコンボリューション解析"),

  fluidRow(
    column(width=6,
      tabsetPanel(type="tabs",
        tabPanel("InputData", fluidRow(rHandsontableOutput("table"),actionButton("submit","計算実行"))),
        tabPanel("Result", fluidRow(plotOutput("plot"),tableOutput("result"))),
        id="tabs"
      )
    )
  )
))
