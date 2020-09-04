
if(!file.exists("weather.rds")){
  
  download.file("https://assets.datacamp.com/production/repositories/34/datasets/b3c1036d9a60a9dfe0f99051d2474a54f76055ea/weather.rds", "weather.rds")
  dateDownloaded <- date()
}

# load the data

weather <- readRDS('weather.rds')

# class of weather
class(weather)

library(dplyr)

glimpse(weather)

head(weather,6)

# tidying the data
library(tidyr)

weather2 <- gather(weather,day,value,X1:X31, na.rm = TRUE)

weather2 <- weather2[,-1]

# Spread the data

weather3 <- spread(weather2,measure,value)

library(stringr)
library(lubridate)

#Remove X's from day column

weather3$day <- str_replace(weather3$day,"X","")

#unite the year, month and day columns
weather4 <- unite(weather3,date,year,month,day, sep="-")
weather4

# convert date column to proper date format using lubridates's ymd()

weather4$date <- ymd(weather4$date)

# rearrange columns using dplyr's select()

weather5 <- weather4 %>%  select(date,Events,CloudCover:WindDirDegrees)

head(weather5)

str(weather5)

weather5$PrecipitationIn <- str_replace(weather5$PrecipitationIn,"T","0")

# convert into numerics

weather6 <- mutate_at(weather5,vars(CloudCover:WindDirDegrees),funs(as.numeric))


# finding missing value
summary(weather6)

weather6[is.na(weather6$Max.Gust.SpeedMPH),]
