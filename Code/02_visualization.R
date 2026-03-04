#R code for visualizing satellite images

library(terra)
library(imageRy)

#listing data
im.list()

#importing images
b2<- im.import("sentinel.dolomites.b2.tif")

#changing colours
cl <- colorRampPalette(c("darkolivegreen", "brown1", "gold"))(100)
plot(b2, col=cl)

cl <- colorRampPalette(c("darkolivegreen", "brown1", "gold"))(3)
plot(b2, col=cl)





