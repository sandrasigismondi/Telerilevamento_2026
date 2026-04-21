#code for classifying data

library(terra)
library(imageRy)
library(ggplot2)
library(patchwork)

#listing files
im.list()

#import sun
sun<-im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

#classify sun
sunc<-im.classify(sun)
sunc<-im.classify(sun, seed=3)
sunc<-im.classify(sun, seed=42)

#import and classify gran canyon data
can<-im.import("dolansprings_oli_2013088_canyon_lrg.jpg")
canc<-im.classify(can, seed=42, num_clusters=4)

#number of pixels
ncell(sun)
ncell(can)

#excercise
setwd("C:\\Users\\fabis\\Pictures")
getwd()

list.files()

sud<-rast("southgeorgia.jpg")
sud<-flip(sud)
plot(sud)
sudc<-im.classify(sud, num_clusters=2)

#










