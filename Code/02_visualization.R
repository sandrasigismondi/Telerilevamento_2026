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

b3 <- im.import("sentinel.dolomites.b3.tif")
b4 <- im.import("sentinel.dolomites.b4.tif")
b8 <- im.import("sentinel.dolomites.b8.tif")

##5/03
####andrea
#esercizio fare 4 plot multiframe per ogni banda                 
                 
par(mfrow=c(2,2))
cl=colorRampPalette(c("lightblue","blue","darkblue"))(100)
plot(b2,col=cl)
cl=colorRampPalette(c("lightgreen","green","darkgreen"))(100)
plot(b3,col=cl)
cl=colorRampPalette(c("red","red2","red4"))(100)
plot(b4,col=cl)
cl=colorRampPalette(c("orange","magenta","red"))(100)
plot(b8,col=cl)



#######
clb<-colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(b2, col=clb)

clg<-colorRampPalette(c("dark green", "green", "light green"))(100)
plot(b3, col=clg)

clr<-colorRampPalette(c("#8B1A1A", "red", "pink"))(100)
plot(b4, col=clg)

cln<-colorRampPalette(c("goldenrod3", "goldenrod2", "goldenrod"))(100)
plot(b8, col=cln)

plot(b2, col=inferno(100))
plot(b3, col=inferno(100))
plot(b4, col=inferno(100))
plot(b8, col=inferno(100))


#stack
#sist rife
sentinel <- c(b2,b3,b4,b8)
plot(sentinel)
plot(sentinel, col=inferno(100))

b2
sentinel
names(sentinel)

plot(sentinel$sentinel.dolomites.b8)

#layer1=b2, layer2=b3, layer4=b3, layer4=b8
plot(sentinel[[4]])
plot(sentinel[[2]])















