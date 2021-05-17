#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#-------------------------------------------------App Server----------------------------------
library(viridis)
library(dplyr)
library(tibble)
library(tidyverse)
library(shinythemes)
library(sf)
library(RCurl)
library(tmap)
library(rgdal)
library(leaflet)
library(shiny)
library(shinythemes)
library(plotly)
library(ggplot2)
library(timevis)
library(shinydashboard)
library(tigris)
library(sp)
library(DT)



#can run RData directly to get the necessary date for the app
#global.r will enable us to get new data everyday
#update data with automated script
#setwd("~/ADS/Fall2020-Project2-group7/app")
panel_2_data<-read.csv("../output/joined_weather_case_data.csv")
source("global.R") 
#load('./output/covid-19.RData')
shinyServer(function(input, output, session) {
  #----------------------------------------
  #tab panel 1 - Home Plots
  #preapare data for plot
  selected_data <- reactive({
    test <- data[data$start %in% seq(from=min(as.Date(strftime(req(input$dygraph_date_window[[1]]), "%Y-%m-%d"))),
                                     to=max(as.Date(strftime(req(input$dygraph_date_window[[2]]), "%Y-%m-%d"))), by = 0.02),]
  })
  
  output$timelineGroups <- renderTimevis({
    data_selected = selected_data()
    timevis(data = as.data.frame(data_selected) , options = list(stack = FALSE))
  })
  
  
  ## daily sales plot output 
  output$dygraph<-renderDygraph({
    dygraph(sales_data, main = "Covid-19 Daily Cases", ylab = "Daily Covid Cases", xlab = "Dates") %>% 
      dyRangeSelector(dateWindow = c("2020-02-01", "2020-09-30"))
  })
  
  output$timeline <- renderTimevis({
    timevis(data)
  })
  
  
  #----------------------------------------
  #tab panel 2 - Weather and covid-data
  # Subset data
  sub_data <- reactive({
    req(input$date)
    #validate(need(!is.na(input$date[1]) & !is.na(input$date[2]), "Error: Please provide both a start and an end date."))
    #validate(need(input$date[1] < input$date[2], "Error: Start date should be earlier than end date."))
    start = as.Date(input$date[1],format="%Y-%m-%d")
    end = as.Date(input$date[2],format="%Y-%m-%d")
    panel_2_data %>%
      mutate(Date=as.Date(Date),format="%Y-%m-%d")%>%
      filter(
        Date >=start & Date<=end
      )
  })
  
  
  
  # Create scatterplot object the plotOutput function is expecting
  output$main_plot <- renderPlot({
    data1=sub_data()
    ylim.prim<- c(1,6365)           #coronavirus cases
    ylim.sec<-c(21.7,80.3)         #temperature
    
    b <- diff(ylim.prim)/diff(ylim.sec)
    a <- b*(ylim.prim[1] - ylim.sec[1])
    
    
    plot<- ggplot(data1) +
      geom_bar(aes(x=data1$Date,  y=data1$CASE_COUNT, fill="grey"), stat = "identity", position = position_dodge(width = 1)) +
      geom_line(aes(x= data1$Date, y=a+b* (data1$Avg_temp), color="red"),group = 1, size=2)+
      scale_fill_manual(values="grey", name="Case_count")+
      scale_y_continuous(sec.axis = sec_axis(~ (. - a)/b, name = "Temperature(F)")) +
      scale_colour_manual(values="red", name="Temperature")+
      ggtitle("Covid-19 cases and Temperature in NYC")+ 
      labs(x="Date",y= "Case_count")+
      theme(axis.line.y.right = element_line(color = "red",linetype = 2), 
            #axis.ticks.y.right = element_line(color = "red"),
            #axis.text.y.right = element_text(color = "red",size=15, face=3), 
            axis.title.y.right = element_text(color = "red",size=15, face="bold"),
            plot.title= element_text(hjust = 0.5))+
      theme_light()
    plot
  })
  
  #Add summary output
  output$summary1<-renderTable({
    req(input$date)
    data2=sub_data()
    output1<-data2%>%
      select(CASE_COUNT)%>%
      summary()%>%
      as.data.frame()%>%
      select(Freq)%>%
      rename("Case_count_summary"="Freq")
  })
  output$summary2<-renderTable({
    req(input$date)
    data3=sub_data()
    output2<-data3%>%
      select(Avg_temp)%>%
      summary()%>%
      as.data.frame()%>%
      select(Freq)%>%
      rename("Temperature_summary"="Freq")
  })
  
  output$time1 <- renderPlotly({
    # d <- setNames(sub_data(), c("Date", "Case_count","Temperature"))
    # plot_ly(d) %>%
    #   add_lines(x = ~Case_count, y = ~Date,color='temperature')
    data=sub_data()
    plot2<- ggplot(data) +
      geom_bar(aes(x=Date,  y=CASE_COUNT, fill="grey"), stat = "identity",position = position_dodge(width = 1)) +
      scale_fill_manual(values="grey",name="count")+
      scale_x_date(date_labels = "%b/%d")+
      ggtitle("Covid-19 cases in NYC")+ 
      labs(x="Date",y= "Case_count")+
      theme(plot.title= element_text(hjust = 0.5))+
      theme_light()
    ggplotly(plot2)
  })
  output$time2 <- renderPlotly({
    data=sub_data()
    plot3<- ggplot(data) +
      geom_line(aes(x= Date, y=Avg_temp, color="red"),group = 1, size=.5)+
      scale_colour_manual(values="red", name="Temp")+
      scale_x_date(date_labels = "%b/%d")+
      ggtitle("Daily Temperature in NYC")+ 
      labs(x="Date",y= "Temperature(F)")+
      theme(plot.title= element_text(hjust = 0.5))+
      theme_light()
    ggplotly(plot3)
  })
  #tab 3
  char_zips <- zctas(cb = TRUE,state="NY") 
  #char_zips$GEOID10 <- as.integer(char_zips$GEOID10)
  
  output$canting <- DT::renderDataTable({
    
    stateFilter <- subset(restaurant_with_covid_s,
                          restaurant_with_covid_s$CUISINE == input$cai_restartant &
                            restaurant_with_covid_s$BORO == input$boro_restartant &
                            (restaurant_with_covid_s$POSITIVE_RATE >= min(input$range_restartant) & 
                               restaurant_with_covid_s$POSITIVE_RATE <= max(input$range_restartant)))
  })
  df_new_new<-reactive({
    if(is.null(input$boro)){
      true_area = as.vector(unlist(unique(restaurant_with_covid_s$BORO)))
    } else {
      true_area = input$boro
    }
    
    if(is.null(input$cai)) {
      true_cai = as.vector(unlist(unique(restaurant_with_covid_s$CUISINE)))
    } else {
      true_cai= input$cai
    }
    if(is.null(input$range)) {
      true_rate_max = max(restaurant_with_covid_s$POSITIVE_RATE)
      true_rate_min = min(restaurant_with_covid_s$POSITIVE_RATE)
    } else {
      true_rate_max= max(input$range)
      true_rate_min= min(input$range)
    }
    
    
    wxl<-restaurant_with_covid_s %>%
      filter(CUISINE %in% true_cai &
               BORO %in% true_area & 
               (POSITIVE_RATE <= true_rate_max) &
               (POSITIVE_RATE >= true_rate_min)) %>%
      group_by(ZIPCODE) %>%
      mutate(restaurant_number=n()) %>% 
      filter(row_number(POSITIVE_RATE) == 1) %>%
      dplyr::select(ZIPCODE,POSITIVE_RATE,restaurant_number)
    wxl$ZIPCODE<-as.character(wxl$ZIPCODE)
    geo_join(spatial_data = char_zips, 
             data_frame = wxl, 
             by_sp = "GEOID10", 
             by_df = "ZIPCODE",
             how = "inner")
  })
  
  
  output$map_density <- renderLeaflet({
    char_zips = df_new_new()
    
    pal <- colorNumeric(
      palette = "Reds",
      domain = as.data.frame(char_zips)$POSITIVE_RATE)
    
    # create labels for zipcodes
    labels <- 
      paste0(
        "Zip Code: ",
        as.data.frame(char_zips)$GEOID10, "<br/>",
        "Number of Restaurants: ",as.data.frame(char_zips)$restaurant_number, "<br/>",
        "Covid-19 Positive Rate: ",as.data.frame(char_zips)$POSITIVE_RATE) %>%
      lapply(htmltools::HTML)
    
    leaflet(char_zips) %>%
      # add base map
      addTiles() %>% 
      setView(-74.0260,40.7236, 11) %>%
      # add zip codes
      addPolygons(fillColor = ~pal(POSITIVE_RATE),
                  weight = 2,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.7,
                  highlight = highlightOptions(weight = 2,
                                               color = "#666",
                                               dashArray = "",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = labels) %>%
      # add legend
      leaflet::addLegend(pal = pal, 
                         values = as.data.frame(char_zips)$POSITIVE_RATE, 
                         opacity = 0.7, 
                         title = htmltools::HTML("Covid Rate "),
                         position = "bottomleft")
    
  })         
  
  
  
  
  
})




