
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#ag
#    http://shiny.rstudio.com/
#
# Define UI for application that draws a histogram
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
#load('./output/covid-19.RData')

shinyUI(
  fluidPage(titlePanel(title="")
            ,navbarPage(title = "COVID-19 as we know it!",
                        #Select whichever theme works for the app 
                        theme = shinytheme("united"),
                        #--------------------------
                        #tab panel 1 - Time tine of COVID
                        tabPanel("ABOUT",icon = icon("home") ,
                                 dashboardBody(
                                     tags$img(src = "Coronavirus.png",height = "460px",
                                              width = "767px",
                                              style = 'position: absolute; opacity: 0.2;'
)
                                   ),
                                
                                # img(src = "Coronavirus.png",align = "right"),
                                 #img(src = "Rest-COVID.png",align = "bottom"),
                                 HTML(
                                   paste(
                                     h1(strong("COVID-19 as we know it!",sep = "\n")),
                                     h6("(play on words from the movie, 'Life as we know it')"),
                                     
                                     h5("Authors: Siyu D., Sneha S., Luyao S., Mengyao H., Wannian L."),'<br/>'
                                     ,'<br/>','<br/>','<br/>','<br/>','<br/>',
                                     
                                     h3(strong("We created this app to give the public a 'one stop shop' for things COVID related.
                                        Tab one provides users with an overview of big events that have happened so far.
                                        It gives the users the ability to get details about the relationship between the events and the daily cases.
                                        Also indirectly provides insights about the incoming second wave. 
                                        The next tab is for those interested in seeing if the President's claim about weather and cases is true.
                                        Lastly, the final tab gives users the ability to search for restaurents based on zip codes and percent positive rates. 
                                        The individuals can customize the location and the risk they are willing to take when it comes to deciding which restaurant to go to.",sep = "\n")),
                                     h3(strong("Overall, this app is meant for the public, to looking back at historic events to see how far we have come, stay informed about COVID fallacies and,
                                         make sound personal decisions about one's health and well-being.",sep = "\n")),
                                     '<br/>','<br/>','<br/>','<br/>','<br/>','<br/>','<br/>','<br/>','<br/>',
                                     h3("Enjoy the app!")
                                   )
                                 )
                        ),
                        #--------------------------
                        #tab panel 2 - Time tine of COVID
                        
                        tabPanel("TIMELINE",icon = icon("calendar"),
                                 dygraphOutput("dygraph"),
                                 fluidPage(timevisOutput("timelineGroups")),
                                 HTML(
                                   paste(
                                     h3(strong("About: The top graph represents daily cases and the bottom timeline represents COVID related events which impacted the economy.
                                     You can adjust the band in the middle of the two graphs to view specific date ranges and details. 
                                               The rates of events peaked around March, as you can see. Also the occurance of new events died down around late May.
                                               The graph correlates with the timeline on April 6th which shows the highest recorded number of COVID cases.",sep = "\n")),'<br/>',
                                               h4("Source:",sep = "\n"),
                                               h4("https://en.wikipedia.org/wiki/2020_coronavirus_pandemic_in_New_York_City",sep = "\n"),
                                               h4("https://github.com/nychealth/coronavirus-data?fbclid=IwAR36hHhkd0x-ChML4SQ5y_G-dDRqI2wQ8NhdXSeOS7bD-zXRS7hrBokAarY")
                                   ))
                        ),
                        
                        
                        # ----------------------------------
                        # tab panel 3 - 
                        tabPanel('COVID-19 & TEMPERATURE',icon = icon("bar-chart-o"),
                                 dateRangeInput("date", strong("Date range"), start = "2020-02-29",
                                                end = "2020-09-30", min = "2020-02-29", max = "2020-09-30", format = "yyyy-mm-dd") ,
                                 HTML(
                                   paste(
                                     h3(strong("About: The President claimed that high temperature will lower the amount of cases. 
                                        This tab shows graphs of the relationship between cases and temperature and individual graphs of daily cases and temperature 
                                        from Feb. 29th, 2020 to Sept. 30th, 2020.
                                        Using this tab you can moniter the rise and fall in tempreature and the respective daily cases.",sep = "\n")),
                                     h4("Source:",sep = "\n"),
                                       h4("Source: https://www.wunderground.com/weather/us/ny/new-york-city and",sep = "\n"),
                                               h4("https://github.com/nychealth/coronavirus-data?fbclid=IwAR36hHhkd0x-ChML4SQ5y_G-dDRqI2wQ8NhdXSeOS7bD-zXRS7hrBokAarY")
                                     
                                   )),
                                 mainPanel(
                                   fluidRow(column(12,
                                                   plotOutput(outputId= "main_plot",width="900px",click = "plot_click")
                                   ),
                                   column(6,
                                          plotlyOutput("time1")
                                   ),
                                   column(6,
                                          plotlyOutput("time2")
                                   ),
                                   column(4,
                                          tableOutput(outputId= "summary1")
                                   ),
                                   column(4,
                                          tableOutput(outputId= "summary2")
                                   )
                                   )
                                 )
                        ),
                        
                        
                        
                        # ----------------------------------
                        # tab panel 4 -
                        tabPanel("COVID-19 & FOOD",fluidPage(
                          tabsetPanel(
                            tabPanel("COVID Cases Density Map",titlePanel("COVID Cases Density Map"),
                                     sidebarPanel(
                                       selectInput("boro", "Choose the Borough",
                                                   choices = restaurant$BORO,
                                                   multiple = T),
                                       selectInput("cai","Select the Cuisine/Food You Like",
                                                   choices = sort(restaurant$CUISINE), multiple = T),
                                       sliderInput("range","Covid Positive Rate",0,7,.1, value = c(0,7))
                                       
                                     ),
                                     mainPanel(
                                       
                                       leafletOutput("map_density",height = "700px")
                                     )
                            ),
                            tabPanel("Restaurant",titlePanel("Restaurant"),
                                     
                                     sidebarPanel(
                                       selectInput("boro_restartant", "Choose the Borough",
                                                   choices = restaurant$BORO,
                                                   multiple = T),
                                       selectInput("cai_restartant","Select the Cuisine/Food You Like",
                                                   choices = restaurant$CUISINE, multiple = T),
                                       sliderInput("range_restartant","Covid Positive Rate",0,7,.1, value = c(0,7))
                                       
                                     ),
                                     mainPanel(
                                       DT::dataTableOutput("canting")
                                       
                                     )
                            )
                          )
                          
                        ),  HTML(
                         paste(
                           h3(strong("About: This tab has two sub tabes which let users specify borough(s), type(s) of cuisine/food and, percent positive rate range.
                           The first sub tab, 'COVID Cases Density Map' shows the percent positive rate and the number of restaurents on the heat map. 
                           The second sub tab, 'Restaurant' gives a list of specific restaurants and their coresponding information.
                           As an added feature, in the top right hand side, the users can enter a keyword to filter the table (i.e. specific restaurent).",sep = "\n")),
                           h4("Source:",sep = "\n"),
                           h4("https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/43nn-pn8j and",sep = "\n"),
                                     h4("https://github.com/nychealth/coronavirus-data?fbclid=IwAR36hHhkd0x-ChML4SQ5y_G-dDRqI2wQ8NhdXSeOS7bD-zXRS7hrBokAarY")
                             
                           )),
                        
                        ),
                        
                        
                        
                        # ----------------------------------
                        # tab panel 5 -Biases
                        tabPanel("BIASES",icon = icon("cog") ,
                                 HTML(
                                   paste(
                                     h1(strong("Biases:",sep = "\n")),'<br/>',
                                     h2("TIMELINE: We are not sure how 'NYC Health' and Wikipedia colected their data.",sep = "\n"), 
                                        h2("COVID-19 & TEMPERATURE: We are not considering the other factors that can effect case count. In addition, 
                                        once again, we are not sure how 'NYC Health' and 'Weather Underground' collected their data.",sep = "\n"),
                                       h2( "COVID-19 & FOOD: The restaurant dataset was obtained from NYC OpenData on Oct 9,2020. 
                                        NYC OpenData compiled several large administrative data systems to creat the dataset which may have resulted in 
                                        missing data or incorrect data.")
                                     
 
                                     
                                     
                                     )
                                 )
                        )
                        
                        
                        
            ))
  
)