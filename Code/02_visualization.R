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


###################visualization temp su duccio 10/03
library(viridis)
libray(ggplot2)
library(terra)
library(imageRy)
install.packages("patchwork")
library(patchwork)
install.packages("GGally")
library(GGally)
###ggpairs servirebbe un dataframe, lo abbiamo messo per provarlo ma lo faremo più avanti


im.list()
b2 <- im.import("sentinel.dolomites.b2.tif")
b3 <- im.import("sentinel.dolomites.b3.tif")
b4 <- im.import("sentinel.dolomites.b4.tif")
b8 <- im.import("sentinel.dolomites.b8.tif")

im.ggplot(b8)

p1 <- im.ggplot(b8)
p2 <- im.ggplot(b4)

p1+p2

# Multiframe:
#1 par(mf=c(1,2))
#2 im.multiframe(1,2)
#3 stack
#4 ggplot2 patchwork

# RGB plotting
sentinel <- c(b2, b3, b4, b8)
sentinel
# 1=b2 blue, 2=b3 green, 3=b4 red, 4=b8 nir infrarosso vicino (alla banda del visibile)


im.multiframe(1,2)

#abbiamo a disposizione 3 filtri e 4 bande, devo fare una scelta. uso solo bande del visibile
im.plotRGB(sentinel, r=3, g=2, b=1)
#natural colors

#in rosso abbiamo messo il vicino infrarosso, il resto li abbiamo spostati e levato il blu
im.plotRGB(sentinel, r=4, g=3, b=2)
#false colors

plot(sentinel[[4]])
im.plotRGB(sentinel, r=4, g=3, b=2)

#uso infrarosso in componente green g=4
im.plotRGB(sentinel, r=3, g=4, b=2)

#excersice: NIR on topo on the blue component of the RGB scheme
im.plotRGB(sentinel, r=3, g=2, b=4)

#plot the four manners of RGB in a single multiframe
im.multiframe(2,2)

# positioning of visible bands
im.multiframe(1,2)
im.plotRGB(sentinel, r=4, g=3, b=2)
im.plotRGB(sentinel, r=4, g=2, b=3)

pairs(sentinel)








