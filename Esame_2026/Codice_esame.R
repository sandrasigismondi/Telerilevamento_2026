# Pacchetti
library(terra)      # Gestione dei raster e shapefile, operazioni spaziali e funzioni di visualizzazione
library(viridis)    # Palette cromatiche
library(RStoolbox)  # Classificazione non supervisionata
library(glacieR)    # Strumenti per l'analisi dei ghiacciai tramite telerilevamento


# Cartella di lavoro

setwd("C:\\Users\\fabis\\Downloads\\Uni\\SGN Magistrale\\Telerilevamento Geo-Eco in R")
list.files()


# vect() importa lo shapefile come oggetto SpatVector

columbia <- vect("columbia_riproiettato.shp")


# rast() importa le immagini Sentinel-2 come oggetti SpatRaster

sep2020 <- rast("columbia_september2020.tif")
sep2021 <- rast("columbia_september2021.tif")
sep2023 <- rast("columbia_september2023.tif")


# prepareGlacier() utilizza internamente:
# - crop(): ritaglia il raster all'estensione dello shapefile
# - mask()): elimina i pixel esterni al contorno del ghiacciaio

sep2020_mask <- prepareGlacier(sep2020, columbia)
sep2021_mask <- prepareGlacier(sep2021, columbia)
sep2023_mask <- prepareGlacier(sep2023, columbia)


par(mfrow = c(1,3)) # Dispone i grafici in una finestra con 1 riga e 3 colonne

# plotglacier() visualizza l'immagine in composizione RGB naturale: r = rosso, g = verde, b = blu

plotGlacierRGB(sep2020_mask, r = 3, g = 2, b = 1, title = "Settembre 2020")
plotGlacierRGB(sep2021_mask, r = 3, g = 2, b = 1, title = "Settembre 2021")
plotGlacierRGB(sep2023_mask, r = 3, g = 2, b = 1, title = "Settembre 2023")


# NDSI
# glacierNDSI() calcola l'NDSI con la banda verde e la banda SWIR

ndsi_sep2020 <- glacierNDSI(sep2020_mask, green = 2, swir = 5)
ndsi_sep2021 <- glacierNDSI(sep2021_mask, green = 2, swir = 5)
ndsi_sep2023 <- glacierNDSI(sep2023_mask, green = 2, swir = 5)

# plotNDSI() visualizza le mappe NDSI con la palette "mako"

plotNDSI(ndsi_sep2020, title = "NDSI - Settembre 2020")
plotNDSI(ndsi_sep2021, title = "NDSI - Settembre 2021")
plotNDSI(ndsi_sep2023, title = "NDSI - Settembre 2023")


# NDWI
# glacierNDWI() calcola l'NDWI con la banda verde e la banda NIR

ndwi_sep2020 <- glacierNDWI(sep2020_mask, green = 2, nir = 4)
ndwi_sep2021 <- glacierNDWI(sep2021_mask, green = 2, nir = 4)
ndwi_sep2023 <- glacierNDWI(sep2023_mask, green = 2, nir = 4)

# plotNDWI() visualizza le mappe NDWI con la palette "viridis

plotNDWI(ndwi_sep2020, title = "NDWI - Settembre 2020")
plotNDWI(ndwi_sep2021, title = "NDWI - Settembre 2021")
plotNDWI(ndwi_sep2023, title = "NDWI - Settembre 2023")


# Classificazione
# glacierClass()

class_sep2020 <- glacierClass(sep2020_mask, nClasses = 3)
class_sep2021 <- glacierClass(sep2021_mask, nClasses = 3)
class_sep2023 <- glacierClass(sep2023_mask, nClasses = 3)

# plotClass() visualizza la classificazione con la palette "cividis"

plotClass(class_sep2020, title = "Settembre 2020")
plotClass(class_sep2021, title = "Settembre 2021")
plotClass(class_sep2023, title = "Settembre 2023")

par(mfrow = c(1,1))











