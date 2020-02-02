library(tidyverse)
library(ggplot2)
library(ggthemes)
library(evaluate)
library(ggmap)
require(maps)
library(plyr)
library(mapproj)
library(grid)
library(scales)
require(scales)

dat <- read_csv("arrests.csv") %>%
  extract(Location, c("Latitude", "Longitude"), "\\(([^,]+), ([^)]+)\\)")


#separate value time from the dataframe and store it
arrest_time <- format(as.POSIXct(strptime(dat$`Arrest Time`,"%H%M",tz="")), format="%H:%M")

#separate value date from the dataframe and store it
arrest_date <- format(as.POSIXct(strptime(dat$`Arrest Date`,"%m/%d/%Y",tz="")), format="%m/%d/%Y")

##create another column Time to the end of the column fill column with the time data
dat$`Arrest Time`<- arrest_time

#create another column Date to the end of the column fill column with the data separeted from Data.Time
dat$`Arrest Date` <- arrest_date

#create another column weekdays to the end of the column fill column with the data converted from the column Date
dat$Weekday <- weekdays(as.Date(dat$`Day of the Week`,format="%A"))


#add column Month to the master data frame
dat$Month<-months(as.POSIXct(dat$`Arrest Date`, format="%m/%d/%Y"))


