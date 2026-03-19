###### code for performing multitemporal analysis with satellite imagery

library(terra)
library(imageRy)

im.list()

EN_01 <- im.import("EN_01.png")
EN_01 <- flip(EN_01)
plot(EN_01)










