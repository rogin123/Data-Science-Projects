
# Plot 1 - Arrests by Race and Gender -------------------------------------
age <- subset(dat, select = c( "Age")) 

#count the pickups by two cololumns: weekday and month
age <- ddply(age,
              .(age$Age), nrow)

#change the column name of the new data frame
names(age) <- c("Age","Count")

ggplot(age, aes(x = Age, y = Count)) +
  geom_line() +
  geom_smooth(method = 'loess',color="#6b6baf", se = FALSE)+
  theme_fivethirtyeight()+
  theme(legend.position = c(0.75,0.75), 
        legend.background = element_blank())+
  xlim(13,83)+
  ylim(0,40)+
  labs(y = "Count", 
       title = "Evanston Arrests by Age", 
       subtitle = "Source: City of Evanston Police Department")


# Arrests by Month --------------------------------------------------------

#subset the data so that the size is smaller, and it is easier to plot
monthly_trend <- subset(dat, select =  c(Month, Age, Sex, Race)) %>% 
  filter(Race == "White"| Race == "Black") 

#count the pickups by two cololumns: weekday and month
monthly_trend<- ddply(monthly_trend, .(monthly_trend$Month, monthly_trend$Race, monthly_trend$Sex), nrow)

#change the column name of the new data frame
names(monthly_trend) <- c("Month","Race", "Sex","Count")

#reorder the table accordiing to mouth so that it is easier to plot in the next step
monthly_trend$Month<- factor(monthly_trend$Month, levels = c("January", "February", "March", "April", "May", "June",
                                             "July","August","September", "October", "November", "December"))

monthly_trend<-monthly_trend[order(monthly_trend$Month),]


# Plot 1 ------------------------------------------------------------------

ggplot(monthly_trend, aes(x = Month, y = Count, fill = Race)) + 
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_fill_manual(values = c("Black" = "#aca1da", "White" = "#6b6baf"))+
  theme_fivethirtyeight() +
  theme(axis.text.x = element_text(size = 7),
        axis.title = element_text(), 
        axis.title.x = element_blank(),
        legend.position = "top")+
  labs(title = "Evanston Arrests by Month", 
       y = "Number of Arrests") 




# PMap Plot ---------------------------------------------------------------------
register_google(key = "AIzaSyBfBKJQ-ctrE_aXjzax0VJF_I7Pxa9hXWI")

ev_map <- get_map(location= c(lon = -87.6877, lat = 42.0451), zoom = 13,
                  maptype = 'terrain', source = "google")
ev <- ggmap(ev_map)

ev + 
  stat_density2d(aes(x = as.numeric(Longitude), y = as.numeric(Latitude), 
                     fill = ..level.., alpha=..level..),
                     size = 8, bins = 30, alpha=0.2, 
                 data = dat, geom = "polygon")+
  scale_fill_gradient(low="blue", high = "orange") + 
  theme(legend.position =  "none", 
        axis.text = element_blank(), 
        axis.ticks = element_blank())+
  labs(x = NULL, 
       y = NULL, 
       title = "Density Plot of Arrests in Evanston")


