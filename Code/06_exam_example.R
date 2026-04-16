library(terra)
library(imageRy)

setwd("C:\\Users\\fabis\\Downloads\\Uni\\SGN Magistrale\\Telerilevamento Geo-Eco in R")
list.files()

richat<- rast("richatstructure_oli_20260306.jpg")
richat<- flip(richat)
plot(richat)


########
png("figura.png")
plot(richat)
dev.off()

im.multiframe(2,1)
plot(richat[[1]])
plot(richat[[2])

png("bande.png")
im.multiframe(2,1)
plot(richat[[1]])
plot(richat[[2])
dev.off()
##########          



