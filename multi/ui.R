#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################

library(shiny)
library(rhandsontable)

shinyUI(fluidPage(

    titlePanel("非線形最小二乗法"),

    sidebarLayout(
        sidebarPanel(
          h3("初期パラメータ"),
          rHandsontableOutput("p_table"),
          actionButton("submit", "計算実行")
          
        ),

        mainPanel(
          fluidRow(
            column(width=12,
              tabsetPanel(type="tabs",
                tabPanel("Data", fluidRow(rHandsontableOutput("table"))),
                tabPanel("Result", fluidRow(verbatimTextOutput("summary")),plotOutput("plots")),
                id="tabs"
              )
            )
          )
        )
    )
))
