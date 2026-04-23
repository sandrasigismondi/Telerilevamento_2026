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

#mato grosso example
im.list()
m2006<-im.import("matogrosso_ast_2006209_lrg.jpg")
m1992<-im.import("matogrosso_l5_1992219_lrg.jpg")

im.multiframe(2,1)
plot(m1992)
plot(m2006)

#land cover
dev.off()
m1992c<-im.classify(m1992, seed=42, num_clusters=2)

# Assign labels
levels(m1992c) <- data.frame(
  value = c(1, 2),
  label = c("forest", "human")
)
m1992c
plot(m1992c)


m2006c<-im.classify(m2006, seed=42, num_clusters=2)
levels(m2006c) <- data.frame(
  value = c(2, 1),
  label = c("forest", "human")
)
plot(m2006c)

#
setwd("C:\\Users\\fabis\\Downloads\\Uni\\SGN Magistrale\\Telerilevamento Geo-Eco in R")

#defyning the function
source("im.barplot.R") #non funziona

#calculating frequencies
f1992<-freq(m1992c)
f2006<-freq(m2006c)

#proportions
prop1992<-f1992$count/ncell(m1992c)
prop2006<-f2006$count/ncell(m2006c)

#%
perc1992<-prop1992*100
perc2006<-prop2006*100

#table (dataframe)
tabout<-data.frame(
  class=c("Forest", "Human"),
  perc1992=c(83, 17),
  perc2006=c(45, 55)
  )


#####################
library(ggplot2)
library(patchwork)


p1<-ggplot(tabout, aes(x=class, y=perc1992, color=class))+ # structure
  geom_bar(stat="identity", fill="white")+ # bar plot
  ylim(c(0,100))+ # limits
  theme(legend.position="none") # remove legend

#plot bars of 2006
p2<-ggplot(tabout, aes(x=class, y=perc2006, color=class))+ # structure
  geom_bar(stat="identity", fill="white")+ # bar plot
  ylim(c(0,100))+ # limits
  theme(legend.position="none") # remove legend

p1+p2











