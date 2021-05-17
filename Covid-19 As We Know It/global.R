#--------------------------------------------------------------------
###############################Install Related Packages #######################
if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}
if (!require("tibble")) {
  install.packages("tibble")
  library(tibble)
}
if (!require("tidyverse")) {
  install.packages("tidyverse")
  library(tidyverse)
}
if (!require("shinythemes")) {
  install.packages("shinythemes")
  library(shinythemes)
}

if (!require("sf")) {
  install.packages("sf")
  library(sf)
}
if (!require("RCurl")) {
  install.packages("RCurl")
  library(RCurl)
}
if (!require("tmap")) {
  install.packages("tmap")
  library(tmap)
}
if (!require("rgdal")) {
  install.packages("rgdal")
  library(rgdal)
}
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}
if (!require("shiny")) {
  install.packages("shiny")
  library(shiny)
}
if (!require("shinythemes")) {
  install.packages("shinythemes")
  library(shinythemes)
}
if (!require("plotly")) {
  install.packages("plotly")
  library(plotly)
}
if (!require("ggplot2")) {
  install.packages("ggplot2")
  library(ggplot2)
}
if (!require("viridis")) {
  install.packages("viridis")
  library(viridis)
}
if (!require("timevis")) {
  install.packages("timevis")
  library(timevis)
}
if (!require("shinyWidgets")) {
  install.packages("shinyWidgets")
  library(shinyWidgets)
}
if (!require("lubridate")) {
  install.packages("lubridate")
  library(lubridate)
}
if (!require("DT")) {
  install.packages("DT")
  library(DT)
}
if (!require("jsonlite")) {
  install.packages("jsonlite")
  library(jsonlite)
}
if (!require("plotly")) {
  install.packages("plotly")
  library(plotly)
}
if (!require("xts")) {
  install.packages("xts")
  library(xts)
}
if (!require("dygraphs")) {
  install.packages("dygraphs")
  library(dygraphs)
}
if (!require("tidyr")) {
  install.packages("tidyr")
  library(tidyr)
}
if (!require("shinydashboard")) {
  install.packages("shinydashboard")
  library(shinydashboard)
}

#--------------------------------------------------------------------
data <- read.csv("../data/Events.csv")
colnames(data) <- c("id", "start","end","content")
data$start <- as.Date(data$start,"%m/%d/%Y")
data <- data.frame(
  content = data$content,
  start   = data$start
)

sales_data = read.csv('../data/case-hosp-death.csv')
date <- as.Date(sales_data$DATE_OF_INTEREST,"%m/%d/%Y")
cases <- as.numeric(sales_data$CASE_COUNT)
sales_data <- xts(cases,date)
colnames(sales_data)<- "Cases"
#--------------------------------------------------------------------------------------------------------
# tab 2
NYC_cases <- (read.csv('../data/case-hosp-death.csv'))
daily_case<-NYC_cases%>%
  #mutate(DATE = as.factor(DATE_OF_INTEREST))%>%
  mutate(DATE = as.Date(DATE_OF_INTEREST,format='%m/%d/%Y'))%>%
  filter(DATE>="2020-02-29"& DATE<="2020-09-30")%>%
  select(DATE,CASE_COUNT)
tail(daily_case,10)    #Not accumulative counts, date range: 2/29 ~ 9/30

write.csv(daily_case, file='../output/NYC_covid-19.csv')


#Load the data
nyc_case_data <-read.csv("../output/NYC_covid-19.csv")
nyc_case<-nyc_case_data%>%
  mutate(Date=as.Date(nyc_case_data$DATE,"%Y-%m-%d"))%>%
  select(Date, CASE_COUNT)


weather_data<-read.csv("../output/Avrage_tem.csv")

cleaned_weather<-weather_data%>%
  mutate(Date = as.Date(weather_data$Date,"%m/%d/%Y"))%>%
  mutate(Avg_temp=round(Avrage_value, digits =1))%>%
  select(Date, Avg_temp)

joined_data<-nyc_case%>%
  inner_join(cleaned_weather, by="Date")
head(joined_data)

write.csv(joined_data, file='../output/joined_weather_case_data.csv')

#tab restaurent

covid_case <- read.csv('../data/recent-4-week-by-modzcta.csv')
covid_case <- covid_case[c('MODIFIED_ZCTA','PERCENT_POSITIVE_4WEEK')]
names(covid_case)[names(covid_case) == "PERCENT_POSITIVE_4WEEK"] <- "POSITIVE_RATE"

restaurant <- read.csv('../data/restaurant_data_cleaned.csv')
restaurant <- restaurant %>% distinct(NAME,STREET,BUILDING,.keep_all = TRUE)
names(restaurant)[names(restaurant) == "CUISINE.DESCRIPTION"] <- "CUISINE"

restaurant_with_covid <- restaurant %>% left_join(covid_case, by = c("ZIPCODE" = "MODIFIED_ZCTA" ))
restaurant_with_covid_s <- restaurant_with_covid[c('NAME','BORO','CUISINE','ZIPCODE','STREET','POSITIVE_RATE')]