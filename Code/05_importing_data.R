#1/04
#script to import data from a computer or github

library(terra)
library(viridis)
library(imageRy)
library(patchwork)

setwd("C:\\Users\\fabis\\Downloads\\Uni\\SGN Magistrale\\Telerilevamento Geo-Eco in R")

list.files()

rgb<-rast("DJI_20260331174728_0001_D.JPG")
plot(rgb)

red<-rast("DJI_20260331174728_0001_MS_R.tiff")
plot(red)

nir<-rast("DJI_20260331174728_0001_MS_NIR.tiff")
plot(nir)

gre<-rast("DJI_20260331174728_0001_MS_G.tiff" )
plot(gre)

stack <- c(gre, red, nir)
plot(stack)

plotRGB(stack, r=3, g=2, b=1, stretch="lin")
plotRGB(stack, r=3, g=2, b=1, stretch="hist")

#without stretch
im.plotRGB(stack, r=3, g=2, b=1)

plotRGB(stack, 2, 3, 1, stretch="lin")
plotRGB(stack, 2, 1, 3, stretch="lin")

#create ndvi
ndvi<-im.ndvi(stack, 3, 2)

plot(ndvi, col=magma(100))
plot(ndvi, col=plasma(100))

#save the data
writeRaster(ndvi, "ndvi.tif")

#imaging that researcher is using your data: reimporting files
ndvi2<-rast("ndvi.tif")
plot(ndvi2)

#save a plot
im.multiframe(2,2)
plotRGB(stack, r=3, g=2, b=1, stretch="lin")
plotRGB(stack, 2, 3, 1, stretch="lin")
plotRGB(stack, 2, 1, 3, stretch="lin")
plot(ndvi)

#
png("figura_per_tesi.png")
plotRGB(stack, r=3, g=2, b=1, stretch="lin")
plotRGB(stack, 2, 3, 1, stretch="lin")
plotRGB(stack, 2, 1, 3, stretch="lin")
plot(ndvi)
dev.off()

#patchwork
p1<-im.ggplot(ndvi)
p2<-im.ridgeline(stack, scale=1, palette="viridis")
p1+p2

png("grafico_statistico.pdf")
p1<-im.ggplot(ndvi)
p2<-im.ridgeline(stack, scale=1, palette="viridis")
p1+p2
dev.off()

#import from git





