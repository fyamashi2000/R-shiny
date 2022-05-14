#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################

library(shiny)
library(rhandsontable)

shinyUI(fluidPage(

    titlePanel("モーメント解析"),

    sidebarLayout(
        sidebarPanel(
            textInput("n1","C(∞)外挿点数",value=3),
            textInput("n0","C(0)外挿点数",value=0),
            actionButton("submit", "計算実行")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(type="tabs",
            tabPanel("Data", rHandsontableOutput("table")),
            tabPanel("Result", fluidRow(plotOutput("plot"),tableOutput("moment"))),
            id="tabs"
          )
        )
    )
))
