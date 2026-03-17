library(terra)
library(imageRy)

# listing files
im.list()

#importing data
mato1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 <- flip(mato1992)

# l1=NIR l2=red l3=green
im.plotRGB(mato1992, 1, 2, 3)

#excersise: put NIR on top of the green component of the RGB scheme
im.plotRGB(mato1992, 2, 1, 3)

#NIR on top of blue
im.plotRGB(mato1992, 3, 2, 1)

#vedo valore di riflettanza
mato1992

#import 2006
mato2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 <- flip(mato2006)

im.plotRGB(mato2006, 1, 2, 3)

#excersise
im.multiframe(1,2)
im.plotRGB(mato1992, 1, 2, 3)
im.plotRGB(mato2006, 1, 2, 3)

plotRGB(mato1992, 1,2,3, stretch="hist")
plotRGB(mato2006, 1,2,3, stretch="hist")

im.plotRGB(mato1992, 2, 1, 3)
im.plotRGB(mato2006, 2, 1, 3)

im.plotRGB(mato1992, 2, 3, 1)
im.plotRGB(mato2006, 2, 3, 1)

#DVI
# l1=NIR l2=red l3=green
dvi1992 <- mato1992[[1]] - mato1992[[2]]
plot(dvi1992)

im.plotRGB(mato1992, 1, 2, 3)

# 8 bit
# NIR - red = 255 - 0 = 255 massimo dvi possibile
# NIR - red = 0 - 255 = -255 mimimo dvi possibile
#range = -255, 255

#excercise: calculate min and max of DVI for an image composed by data at 4 bit
# 4 bit
# NIR - red = 15 - 0 = 15
# NIR - red = 0 - 15 = -15
#range = -15, 15

#NDVI
# (NIR - red)/(NIR+red)
#prendo immagine a 8 bit
# (NIR - red)/(NIR+red)= (255 - 0) / (255 + 0) = 1 max NDVI
# (NIR - red)/(NIR+red)= (0 - 255) / (0 + 255) = -1 max NDVI

#4 bit
# (NIR - red)/(NIR+red)= (15 - 0) / (15 + 0) = 1 max NDVI
# (NIR - red)/(NIR+red)= (0 - 15) / (0 + 15) = -1 max NDVI


#dvi 2006
dvi2006 <- mato2006[[1]] - mato2006[[2]]
plot(dvi2006)



#ndvi
ndvi1992 = dvi1992 / (mato1992[[1]] +  mato1992[[2]])
ndvi2006 = dvi2006 / (mato2006[[1]] +  mato2006[[2]])

im.multiframe(1,2)
plot(ndvi1992)
plot(ndvi2006)


library(viridis)
plot(ndvi1992, col=inferno(100))
plot(ndvi2006, col=inferno(100))


#dvi by imageRY
dvi1992 = im.dvi(mato1992, 1,2)
dvi2006 = im.dvi(mato2006, 1,2)
plot(dvi1992, col=inferno(100))
plot(dvi2006, col=inferno(100))

#ndvivia  imageRY
ndvi1992 = im.ndvi(mato1992, 1,2)
ndvi2006 = im.ndvi(mato2006, 1,2)
plot(ndvi1992, col=mako(100))
plot(ndvi2006, col=mako(100))

#exercise: plot dvis and ndvis for the two dates in two rows and colums
im.multiframe(2,2)
plot(dvi1992, col=inferno(100))
plot(dvi2006, col=inferno(100))
plot(ndvi1992, col=magma(100))
plot(ndvi2006, col=magma(100))












