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















