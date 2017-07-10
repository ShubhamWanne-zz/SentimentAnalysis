library(shiny)
shinyUI(fluidPage(
  titlePanel(
    fluidRow(
      column(4),
    column(5,
           div(img(src="icon.png",width=400,height=200),style="text-align: center")
           )
    )),
  sidebarLayout(
  sidebarPanel(
    div(img(src='Twitter.png',width=150,height=150), style="text-align: center"),
    textInput("input","Enter searchable",value = "@twitter")
  ), 
  
  mainPanel(
    tabsetPanel(
      tabPanel("Help",
               h1(span("Welcome, to TwitteR !",style = "color : #00ace6")),hr(),
               div(img(src='emoji.png',width=500,height=200),style="text-align: center"),
              h4(span("Sentiment analysis deals with identifying and classifying opinions or sentiments
      expressed in source text. Social media is generating a vast amount of sentiment 
                rich data in the form of tweets, status updates, blog posts etc. 
                Sentiment analysis of this user generated data is very useful in knowing the 
                opinion of the crowd.",style = 'color : #5f9ea0')), 
              h4(span("Twitter sentiment analysis is difficult compared to general sentiment analysis
                due to the presence of slang words and misspellings. However, this application uses :  ",style="color : #5f9ea0")),
              h3(span(" 1. NRC tokens(Saif Mohammad and Peter Turney.)",style = "color : #5f9ea0")),
              h3(span(" 2. BING tokens(Bing Liu and collaborators.)",style = "color : #5f9ea0")),
              h3(span(" 3. AFINN tokens(Finn Arup Nielsen.)",style = "color : #5f9ea0")),
              br(),
              br(),
              h4(span("Note : This application is just demonstration for the estimated sentiments. 
              It uses UniGrams(one Word) text involved in your searchables' tweet .",style='color:green')),
              div(span("Disclaimer : This application has nothing to do with the real life",strong("emotion"),"of the person.",style = "color:red"),style = "text-align: right")),
      tabPanel("Table",
    DT::dataTableOutput("table")
      ),
    tabPanel("NRC Lexicon",
             plotOutput("nrc_plot"),
             h3(span("The graph above represents",style = "color : lightcoral")),
             h3(span("The graph above represents",style = "color : lightcoral"))
             ),
    tabPanel("Bing Lexicon",
             plotOutput("bing_plot")
             ),
    tabPanel("AFINN Lexicon",
             plotOutput("afinn_table"))
    )
    )
)))