# Pacchetti
library(terra)      # Gestione dei raster e shapefile, operazioni spaziali e funzioni di visualizzazione
library(viridis)    # Palette cromatiche
library(RStoolbox)  # Classificazione non supervisionata
library(ggplot2)    # Realizzazione di grafici statistici
library(patchwork)  # Composizione e affiancamento di grafici
library(glacieR)    # Strumenti per l'analisi dei ghiacciai tramite telerilevamento


# Cartella di lavoro

setwd("C:\\Users\\fabis\\Downloads\\Uni\\SGN Magistrale\\Telerilevamento Geo-Eco in R")
list.files()


# rast() importa le immagini Sentinel-2 come oggetti SpatRaster

sep2020 <- rast("columbia_september2020.tif")
sep2021 <- rast("columbia_september2021.tif")
sep2023 <- rast("columbia_september2023.tif")


# prepareGlacier() utilizza internamente:
# - vect(): importa lo shapefile come oggetto SpatVector
# - crop(): ritaglia il raster all'estensione dello shapefile
# - mask()): mantiene i pixel interni al perimetro dello shapefile

sep2020_mask <- prepareGlacier(sep2020, "columbia_riproiettato.shp")
sep2021_mask <- prepareGlacier(sep2021, "columbia_riproiettato.shp")
sep2023_mask <- prepareGlacier(sep2023, "columbia_riproiettato.shp")


par(mfrow = c(1,3)) # Dispone i grafici in una finestra con 1 riga e 3 colonne

# plotglacier() visualizza l'immagine in composizione RGB naturale: r = rosso, g = verde, b = blu

plotGlacierRGB(sep2020_mask, r = 3, g = 2, b = 1, title = "Settembre 2020")
plotGlacierRGB(sep2021_mask, r = 3, g = 2, b = 1, title = "Settembre 2021")
plotGlacierRGB(sep2023_mask, r = 3, g = 2, b = 1, title = "Settembre 2023")


# Visualizza l'immagine in composizione a falsi colori:
# r = NIR, g = rosso, b = verde

plotGlacierRGB(sep2020_mask, 4, 3, 2, title = "Settembre 2020")
plotGlacierRGB(sep2021_mask, 4, 3, 2, title = "Settembre 2021")
plotGlacierRGB(sep2023_mask, 4, 3, 2, title = "Settembre 2023")


# NDSI
# glacierNDSI() calcola l'NDSI con la banda verde e la banda SWIR

ndsi_sep2020 <- glacierNDSI(sep2020_mask, green = 2, swir = 5)
ndsi_sep2021 <- glacierNDSI(sep2021_mask, green = 2, swir = 5)
ndsi_sep2023 <- glacierNDSI(sep2023_mask, green = 2, swir = 5)

# plotNDSI() visualizza le mappe NDSI con la palette "mako"

plotNDSI(ndsi_sep2020, title = "NDSI - Settembre 2020")
plotNDSI(ndsi_sep2021, title = "NDSI - Settembre 2021")
plotNDSI(ndsi_sep2023, title = "NDSI - Settembre 2023")

# Differenza NDSI
# Sottrazione delle mappe NDSI tra gli anni

ndsi_diff_21_20 <- ndsi_sep2021 - ndsi_sep2020
ndsi_diff_23_21 <- ndsi_sep2023 - ndsi_sep2021
ndsi_diff_23_20 <- ndsi_sep2023 - ndsi_sep2020

# visualizza le differenze con la palette "inferno"
plot(ndsi_diff_21_20, col = inferno(200), main="ΔNDSI 2021 - 2020")
plot(ndsi_diff_23_21, col = inferno(200), main="ΔNDSI 2023 - 2021")
plot(ndsi_diff_23_20, col = inferno(200), main="ΔNDSI 2023 - 2020")


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
# glacierClass() esegue una classificazione non supervisionata

class_sep2020 <- glacierClass(sep2020_mask, nClasses = 3) # Classificazione fatta su 3 classi
class_sep2021 <- glacierClass(sep2021_mask, nClasses = 3)
class_sep2023 <- glacierClass(sep2023_mask, nClasses = 3)

# plotClass() visualizza la classificazione con la palette "cividis"

plotClass(class_sep2020)
plotClass(class_sep2021)
plotClass(class_sep2023)

# subst() riclassifica i valori delle classi

class2020 <- subst(class_sep2020$map, from = c(1, 2, 3), to = c(1, 3, 2))
class2021 <- subst(class_sep2021$map, from = c(1, 2, 3), to = c(1, 2, 3))
class2023 <- subst(class_sep2023$map, from = c(1, 2, 3), to = c(1, 2, 3))

# Palette "cividis" e nome delle classi

colori <- viridis(3, option = "E")
nomi <-c("Superfici a bassa riflettanza", "Ghiaccio con detriti", "Ghiaccio pulito e neve")

# Visualizzazione delle mappe riclassificate

plot(class2020, col=colori, main="Settembre 2020")
plot(class2021, col=colori, main="Settembre 2021")
plot(class2023, col=colori, main="Settembre 2023")

# legend() aggiunge la legenda

legend("bottomleft",  # Posizione della legenda
       legend = nomi, # Eticchette delle classi
       fill = colori, # Colori associati alle classi
       bg = "white",  # Sfondo della legenda
       xpd = TRUE)    # Consente di disegnare la legenda anche fuori dal grafico


# Analisi quantitativa delle classi
#freq() calcola la frequenza assoluta dei pixel appartenenti a ciascuna classe

f2020 <- freq(class2020)
f2021 <- freq(class2021)
f2023 <- freq(class2023)

# Calcolo della percentuale di copertura di ogni classe rispetto al totale dei pixel classificati

perc2020 <- (f2020$count / sum(f2020$count))*100
perc2021 <- (f2021$count / sum(f2021$count))*100
perc2023 <- (f2023$count / sum(f2023$count))*100

# round() arrotonda le percentuali a due cifre decimali

round(perc2020,2)
round(perc2021,2)
round(perc2023,2)

# data.frame() crea una tabella riassuntiva con le percentuali di copertura per ciascun anno


tabella <- data.frame(
  Class = nomi,
  Settembre2020 = round(perc2020,2),
  Settembre2021 = round(perc2021,2),
  Settembre2023 = round(perc2023,2)
)

tabella


# Grafici delle frequenze percentuali

# ggplot() crea il grafico specificando:
# - i dati da utilizzare (tabella)
# - l'asse x (classi)
# - l'asse y (percentuale di copertura)
# - il colore delle barre in base alla classe

p2020 <- ggplot(tabella, aes(x = Class, y = Settembre2020, fill = Class)) +
  
  # geom_bar() costruisce il grafico a barre;
  # stat = "identity" utilizza i valori riportati nella tabella
  geom_bar(stat = "identity") +
  
  # ylim() imposta l'intervallo dell'asse y tra 0 e 100%
  ylim(0,100) +
  
  # labs() aggiunge titolo e nomi degli assi
  labs(title = "Settembre 2020",
       x = "Classe",
       y = "Copertura (%)") +
  
  # scale_fill_manual() assegna i colori definiti in precedenza alle classi
  scale_fill_manual(values = colori) +
  
  # theme_minimal() applica un tema grafico essenziale
  theme_minimal() +
  
  # theme() rimuove la legenda dal singolo grafico
  theme(legend.position = "none")


p2021 <- ggplot(tabella, aes(x = Class, y = Settembre2021, fill = Class)) +
  geom_bar(stat = "identity") +
  ylim(0,100) +
  labs(title = "Settembre 2021",
       x = "Classe",
       y = "Copertura (%)") +
  scale_fill_manual(values = colori) +
  theme_minimal() +
  theme(legend.position = "none")


p2023 <- ggplot(tabella, aes(x = Class, y = Settembre2023, fill = Class)) +
  geom_bar(stat = "identity") +
  ylim(0,100) +
  labs(title = "Settembre 2023",
       x = "Classe",
       y = "Copertura (%)") +
  scale_fill_manual(values = colori) +
  theme_minimal() +
  theme(legend.position = "none")


# patchwork affianca i tre grafici
p2020 + p2021 + p2023
