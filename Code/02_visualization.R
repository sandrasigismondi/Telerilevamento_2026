#R code for visualizing satellite images

library(terra)
library(imageRy)

install.packages("viridis")
library(viridis)

#library(devtools)
#install_github("")

#listing data
im.list()

#importing images
b2<- im.import("sentinel.dolomites.b2.tif")

#changing colours
cl <- colorRampPalette(c("darkolivegreen", "brown1", "gold"))(100)
plot(b2, col=cl)

cl <- colorRampPalette(c("darkolivegreen", "brown1", "gold"))(3)
plot(b2, col=cl)

#viridis palette
plot(b2, col=inferno(100))

#exercise: plot with mako
plot(b2, col=mako(100))
plot(b2, col=mako(3)) #brutto

#plot b2 in greyscale palette
cl <- colorRampPalette(c("darkgrey", "grey", "lightgrey"))(100)
plot(b2, col=cl)

#
par(mfrow=c(1,2))
plot(b2, col=cl)
plot(b2, col=inferno(100))


im.multiframe<- (1,2)
plot(b2, col=cl)
plot(b2, col=inferno(100))












