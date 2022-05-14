#################################################################
#  Copyright (c) 2022 Fumiyoshi Yamashita. All rights reserved  #
#################################################################

library(shiny)
library(rhandsontable)

shinyUI(fluidPage(

    titlePanel("MULTI(RUNGE)"),

    sidebarLayout(
        sidebarPanel(
          h4("初期パラメータ"),
          rHandsontableOutput("p_table"),
          h2(" "),
          radioButtons("weight","重みづけ",choices=list("絶対誤差"=TRUE,"相対誤差"=FALSE)),
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
