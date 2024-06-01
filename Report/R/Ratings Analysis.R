#Adding Libraries and Importing Data
library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)
library(janitor)
library(stringr)
naruto<- read_csv("E:/DA_Course/Naruto/Dataset/naruto_ratings_data_v04.csv")

#Cleaning Data
naruto<-clean_names(naruto)
naruto <- subset(naruto, select=-c(2,3,4,7,8,11))
n_distinct(naruto$episode_number_overall)
str(naruto)
naruto$episode_number_overall<- as.character(naruto$episode_number_overall)
write.csv(naruto,file="E:/DA_Course/Naruto/Dataset/naruto1.csv") #Exporting to split directors and writers columns
naruto<-read_csv("E:/DA_Course/Naruto/Dataset/naruto.csv")

#Analyzing Data
naruto$weight<- ((naruto$votes)/sum(naruto$votes))
#fr stands for Fair Rating, which I calculated by getting the weighted average of the votes and multiplying them with the rating each episode got, so we can eliminate influence of number of votes on the rating of each episode.
#Also, fr is not scaled between 1 to 5, the more fr the better.
naruto$fr<- (naruto$rating*naruto$weight) 
naruto$fr<- naruto$fr*100
naruto$fr<-round(naruto$fr,2)
summary(naruto$fr)
naruto <- subset(naruto, select=-c(7))
write.csv(naruto,file = "E:/DA_Course/Naruto/Report/for_viz.csv")
n_distinct(naruto$writer)

top_n(group_by(naruto$director),10)
test <-top_n(naruto %>%
  group_by(naruto$director) %>%
  summarise(avgFR = mean(fr)),20) #Taking Top 20 directors cause its hard to visualize 108 

write.csv(test, file= "E:/DA_Course/Naruto/Report/topdir.csv")
