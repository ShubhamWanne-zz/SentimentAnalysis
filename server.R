library(shiny)
library(twitteR)
library(dplyr)
library(stringr)
library(ROAuth)
library(tidytext)
library(ggplot2)
library(plotly)
setup_twitter_oauth("TXf87DWRZszH7TeGcA4L0TFgU",
                    "pvf5wFEoa6yvWdCogM1krWbwcEakMPxYFjiWbHotTbn6SF2vuA",
                    "847068157386752000-MEXv5dcgWTbNYruNWlnLEa4c7Dl6TWP",
                    "nrDjAvZv9YVjWpWibtrIr6Yiz0wu0sbeZKQ4t6mdhAdZF")

shinyServer(function(input,output){
  
  
  data_table<- reactive({
    paste("Search to be loading !")
    df<- twListToDF(searchTwitter(input$input,100))
    df<- data_frame(id=df$id, tweet = df$text,Person = df$screenName,TweetedOn = df$created)
    df
  })
  output$table<-DT::renderDataTable({
    data_table()
  })

  df_token<-reactive({
    df<- twListToDF(searchTwitter(input$input,100))
    df<- data_frame(id=df$id, tweet = df$text,Person = df$screenName,TweetedOn = df$created)
    #cleaning the data
    df$tweet <- gsub("[[:digit:]]","",df$tweet)
    df$tweet <- gsub("[[:punct:]]","",df$tweet)
    
    df_token <- df %>% unnest_tokens(tweet,tweet)
    df_token$tweet <- gsub("[[:cntrl:]]","",df_token$tweet)
    df_token
  })
  df_bing<-reactive({
    df_token() %>% 
      inner_join(get_sentiments('bing'),by=c('tweet'='word'))%>% 
      count(tweet,sentiment)
  })
  df_nrc<- reactive({
    df_token() %>% 
      inner_join(get_sentiments('nrc'),by=c('tweet'='word')) %>% count(tweet,sentiment)
  })
  df_afinn <- reactive({
    plot_token <- df_token()%>% group_by(tweet) %>% count(tweet) %>% inner_join(get_sentiments('afinn'),by=c('tweet'='word'))
    plot_token
  })
  output$bing_plot<- renderPlot({
    df_bing() %>%
      ggplot(aes(sentiment,n,fill=sentiment))+ggtitle(paste("Plot for",input$input,"(BING tokens)"))+ylab("frequency of word")+geom_bar(stat = 'identity')
    
  })
  output$nrc_plot<- renderPlot({
    df_nrc() %>%
      ggplot(aes(sentiment,n,fill=sentiment))+ggtitle(paste("Plot for",input$input,"(NRC tokens)"))+ylab("Frequency of word")+geom_bar(stat = 'identity')
    
  })
  
  output$afinn_table<- renderPlot({
    plot_token <-df_afinn()
    ggplot(plot_token,aes(as.integer(rownames(plot_token)),n*score,fill=score))+geom_col()+xlab("No. of Tweets")+ylab("Sentiment scores * word frequency")+ggtitle(paste("Plot for",input$input,"(AFINN tokens)"))
  })
})