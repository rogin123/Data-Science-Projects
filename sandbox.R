library(tidycensus)
library(tidyverse)
library(mapview)
library(sf)
options(tigris_use_cache = TRUE)

census_api_key("b76598caee3135caf0d02f35006b220f6f962278", install = TRUE)

readRenviron("~/.Renviron")

evanston <- get_acs(stae = "IL", county = "Cook", geography = "tract", 
                  variables = "B02001_003", geometry = TRUE)

mapview(evanston, zcol = "estimate", legend = TRUE)


# Time of Day graph -------------------------------------------------------

# Select the data needed for this task
daily_trend <- subset(dat, select = c(`Arrest Date`,`Arrest Time`, Month)) 
#Change the time format to simply showing the hour so that it will be easier for regrouping the file and plotting (if name of x axis is too long, it will not be clear and pretty)
H<-format(as.POSIXct(strptime(daily_trend$`Arrest Time`, "%H:%M", tz="")), format="%H")
daily_trend$`Arrest Time` <- H

#convert the time column into class time
daily_trend$`Arrest Time` <- as.character.Date(daily_trend$`Arrest Time`, format="%H")

#count the pickups by two cololumns: time and month
daily_trend<- ddply(daily_trend, .(daily_trend$`Arrest Time`, daily_trend$Month), nrow) 

names(daily_trend)<- c("Hour","Month","Count") 

hourly <- daily_trend %>% 
  group_by(Hour)
%>% 
  summarise(max(Count))

daily_trend$Month<- factor(daily_trend$Month, levels = c("January", "February", "March", "April", "May", "June",
                                                         "July","August","September", "October", "November", "December"))
daily_trend<-daily_trend[order(daily_trend$Month),]

# plot the data - bar graph
#line graph
ggplot(daily_trend, aes(Hour, Count, group = Month))+
  geom_line(aes(color = Month))+
  ggtitle(label = "Trend Over Time of the Day")+
  theme_minimal()+
  theme(plot.title = element_text(hjust=0.5, lineheight = .8, face = "bold"))+
  xlab("Hour")+
  ylab("Number of Arrests")v17 <- load_variables(2017, "acs5", cache = TRUE)

View(v17)
