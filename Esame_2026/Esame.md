> ### Telerilevamento geo-ecologico in R
>> Sandra Sigismondi

# Evoluzione superficiale del Columbia Glacier (2020–2023) mediante immagini Sentinel-2

# ⛰️ Introduzione

Il ghiacciaio Columbia, situato nell'**Alaska meridionale** nei Monti Chugach, si estende da un campo glaciale posto a circa **3050 m s.l.m.** fino a sfociare direttamente nelle acque del Prince William Sound. A partire dagli anni 80' ha subito un marcato **arretramento del fronte glaciale**: il ramo principale ha perso oltre 20 km di lunghezza e più della metà del proprio volume e spessore. Tale evoluzione è dovuta sia all'aumento delle temperature atmosferiche e oceaniche, sia a processi dinamici. In particolare, arretrando, il ghiacciaio ha perso il contatto con il banco morenico terminale che ne stabilizzava il fronte, favorendo il fenomeno del calving, ovvero il distacco di iceberg in mare. La conseguente **perdita di massa** contribuisce all'innalzamento del livello medio del mare e rappresenta quasi la metà della perdita di ghiaccio della catena montuosa dei Monti Chugach.

<p align="center"><img width="500" height="250" alt="columbiaglacier_pho_201606" src="https://github.com/user-attachments/assets/6023d73b-2f6b-4b60-a53f-0b7da76d1e5b" />

**Monitorare** l'evoluzione dei ghiacciai è fondamentale per diversi motivi:
- quantificare la perdita di massa glaciale;
- comprendere gli effetti del cambiamento climatico sulla criosfera;
- migliorare le stime del loro contributo all'innalzamento del livello del mare;
- valutare gli effetti della fusione glaciale sugli ecosistemi costieri.

<p align="center"><img width="447" height="318" alt="Columbia Glacier" src="https://github.com/user-attachments/assets/8d042c35-0369-4356-83c1-5371437bc134">

##  📌 Obiettivo dello studio

Analizzare l'evoluzione superficiale del Columbia Glacier tra **settembre 2020**, **settembre 2021** e **settembre 2023** tramite:
- visualizzazione RGB delle immagini;
- calcolo del **Normalized Difference Snow Index (NDSI)** e analisi delle sue variazioni temporali;
- calcolo del **Normalized Difference Water Index (NDWI)**;
- classificazione non supervisionata delle principali coperture superficiali;
- confronto quantitativo delle percentuali di copertura delle classi.

---

# 🛰️ Materiali e metodi

## Pacchetti R

```r
library(terra)      # Gestione dei raster e shapefile, operazioni spaziali e funzioni di visualizzazione
library(viridis)    # Palette cromatiche
library(RStoolbox)  # Classificazione non supervisionata
library(ggplot2)    # Realizzazione di grafici statistici
library(patchwork)  # Composizione e affiancamento di grafici.
library(glacieR)    # Strumenti per l'analisi dei ghiacciai tramite telerilevamento
```

><img width="34" height="34" alt="glacieR_logo" src="https://github.com/user-attachments/assets/f191e9ef-6fba-4b5b-abd1-b7376044796e" /> Repository del pacchetto **glacieR** ➡️ **https://github.com/sandrasigismondi/glacieR**

## Dati satellitari
Sono state utilizzate immagini Sentinel-2 Surface Reflectance Harmonized scaricate da [Google Earth Engine](https://earthengine.google.com/) con risoluzione spaziale di 20 m. Sono state esportate le bande presenti in tabella.

| **Banda** | **Descrizione** | **Utilizzo** |
|:---:|:---|:---|
| **B2** | Blu | RGB, classificazione |
| **B3** | Verde | RGB, NDSI, NDWI, classificazione |
| **B4** | Rosso | RGB, classificazione |
| **B8** | Vicino Infrarosso (NIR) | NDWI, classificazione |
| **B11** | SWIR 1 | NDSI, classificazione |
| **B12** | SWIR 2 | Classificazione |

## Preparazione dei dati
Per delimitare l'area di studio è stato utilizzato uno shapefile del Columbia Glacier, scaricato da [NASA Sea Level Change Portal](https://sealevel.nasa.gov/vesl/web/glaciers/columbia/). Successivamente sono state importate le immagini Sentinel-2 e ritagliate sull'area del ghiacciaio, mantenendo i pixel all'interno del suo perimetro.

```r
# vect() importa lo shapefile come oggetto SpatVector

columbia <- vect("columbia_riproiettato.shp")

# rast() importa le immagini Sentinel-2 come oggetti SpatRaster

sep2020 <- rast("columbia_september2020.tif")
sep2021 <- rast("columbia_september2021.tif")
sep2023 <- rast("columbia_september2023.tif")

# prepareGlacier() utilizza internamente:
# - crop(): ritaglia il raster all'estensione dello shapefile
# - mask()): mantiene solo i pixel interni al contorno dello shapefile

sep2020_mask <- prepareGlacier(sep2020, columbia)
sep2021_mask <- prepareGlacier(sep2021, columbia)
sep2023_mask <- prepareGlacier(sep2023, columbia)

```

---

# Visualizzazione RGB

```r
par(mfrow = c(1,3))   # Dispone i grafici in una finestra con 1 riga e 3 colonne

# plotglacier() visualizza l'immagine in composizione RGB naturale: r = rosso, g = verde, b = blu

plotGlacierRGB(sep2020_mask, r = 3, g = 2, b = 1, title = "Settembre 2020")
plotGlacierRGB(sep2021_mask, r = 3, g = 2, b = 1, title = "Settembre 2021")
plotGlacierRGB(sep2023_mask, r = 3, g = 2, b = 1, title = "Settembre 2023")
```

<p align="center"><img width="1052" height="452" alt="plotRGB2" src="https://github.com/user-attachments/assets/a7094e1c-704d-400d-b85b-7a0afc730cbe" />

>Le aree innevate e coperte da ghiaccio appaiono prevalentemente bianche, le superfici detritiche assumono tonalità grigio-scure, mentre i corpi idrici risultano molto scuri. Le differenze più evidenti si osservano in corrispondenza della lingua glaciale, che mostra un progressivo arretramento tra il 2020 e il 2023.

## Composizione a falsi colori (NIR-Red-Green)

```r
visualizza l'immagine in composizione a falsi colori:
# r = NIR, g = rosso, b = verde

plotGlacierRGB(sep2020_mask, 4, 3, 2, title = "Settembre 2020")
plotGlacierRGB(sep2021_mask, 4, 3, 2, title = "Settembre 2021")
plotGlacierRGB(sep2023_mask, 4, 3, 2, title = "Settembre 2023")

```

<p align="center"><img width="1052" height="432" alt="plotRGB_falsecolor" src="https://github.com/user-attachments/assets/7e3eba0c-b162-476d-8fe3-82e5dd161294" />
>La vegetazione appare in tonalità rosse, mentre ghiaccio e neve risultano chiari.

---

# NDSI - Normalized Difference Snow Index

Questo indice evidenzia la presenza di neve e ghiaccio. Valori elevati (prossimi a 1) sono tipici di neve e ghiaccio pulito, mentre valori bassi o negativi sono generalmente associati a rocce, detrito, acqua o superfici prive di copertura nevosa.

$$
NDSI=\frac{Green-SWIR}{Green+SWIR}
$$

```r
# glacierNDSI() calcola l'NDSI con la banda verde e la banda SWIR

ndsi_sep2020 <- glacierNDSI(sep2020_mask, green = 2, swir = 5)
ndsi_sep2021 <- glacierNDSI(sep2021_mask, green = 2, swir = 5)
ndsi_sep2023 <- glacierNDSI(sep2023_mask, green = 2, swir = 5)

# plotNDSI() visualizza le mappe NDSI con la palette "mako"

plotNDSI(ndsi_sep2020, title = "NDSI - Settembre 2020")
plotNDSI(ndsi_sep2021, title = "NDSI - Settembre 2021")
plotNDSI(ndsi_sep2023, title = "NDSI - Settembre 2023")
```

<p align="center"><img width="1052" height="347" alt="plotNDSI2" src="https://github.com/user-attachments/assets/6e20e205-be6c-4683-b5e6-cab47c86cddd" />

>In tutti gli anni predominano valori elevati, indicativi di un'ampia copertura di ghiaccio e/o neve. I valori più bassi si concentrano principalmente nelle zone in cui ci sono affioramenti rocciosi.

## Variazioni di NDSI nel tempo

Per evidenziare le variazioni della copertura nivale e glaciale nel tempo è stata calcolata la differenza tra le mappe NDSI dei diversi anni. Valori positivi indicano un aumento dell'NDSI, mentre valori negativi indicano una sua diminuzione.

```r
# Sottrazione delle mappe NDSI tra gli anni

ndsi_diff_21_20 <- ndsi_sep2021 - ndsi_sep2020
ndsi_diff_23_21 <- ndsi_sep2023 - ndsi_sep2021
ndsi_diff_23_20 <- ndsi_sep2023 - ndsi_sep2020

# visualizza le differenze con la palette "inferno"

plot(ndsi_diff_21_20, col = inferno(200), main="ΔNDSI 2021 - 2020")
plot(ndsi_diff_23_21, col = inferno(200), main="ΔNDSI 2023 - 2021")
plot(ndsi_diff_23_20, col = inferno(200), main="ΔNDSI 2023 - 2020")

```

<p align="center"><img width="1052" height="320" alt="plot_diffNDSI" src="https://github.com/user-attachments/assets/5bae9468-721e-40fc-82f0-1dd3b0f42519" />

Le differenze di NDSI risultano generalmente contenute, indicando una sostanziale stabilità della distribuzione della neve e del ghiaccio durante il periodo analizzato. Le variazioni più evidenti sono localizzate nelle aree periferiche del ghiacciaio e nelle zone di transizione tra ghiaccio pulito, ghiaccio con detriti e affioramenti rocciosi
Il confronto 2020–2023 evidenzia modifiche più marcate rispetto ai confronti annuali, suggerendo un'evoluzione graduale della superficie glaciale nel corso dell'intero periodo di studio.

---

# NDWI - Normalized Difference Water Index

Questo indice evidenzia la presenza di acqua superficiale e di aree interessate dalla fusione della neve e del ghiaccio. Valori più elevati indicano superfici con maggiore presenza di acqua liquida, mentre valori bassi o negativi sono generalmente associati a rocce, detrito e superfici asciutte.

$$
NDWI=\frac{Green-NIR}{Green+NIR}
$$

```r
# glacierNDWI() calcola l'NDWI con la banda verde e la banda NIR

ndwi_sep2020 <- glacierNDWI(sep2020_mask, green = 2, nir = 4)
ndwi_sep2021 <- glacierNDWI(sep2021_mask, green = 2, nir = 4)
ndwi_sep2023 <- glacierNDWI(sep2023_mask, green = 2, nir = 4)

# plotNDWI() visualizza le mappe NDWI con la palette "viridis"

plotNDWI(ndwi_sep2020, title = "NDWI - Settembre 2020")
plotNDWI(ndwi_sep2021, title = "NDWI - Settembre 2021")
plotNDWI(ndwi_sep2023, title = "NDWI - Settembre 2023")
```

<p align="center"><img width="1052" height="337" alt="plotNDWI2" src="https://github.com/user-attachments/assets/6579bd91-c3cf-49b3-96aa-b9c24011e437" />

>Le tre mappe mostrano una distribuzione spaziale dell'NDWI piuttosto simile. Le differenze osservabili sono localizzate in prossimità del fronte glaciale e delle aree di drenaggio.

---

# Classificazione non supervisionata

È stata applicata una classificazione non supervisionata mediante algoritmo k-means, specificando tre classi. L'algoritmo raggruppa automaticamente i pixel in base alla loro similarità spettrale, senza utilizzare campioni di addestramento. Per la classificazione sono state utilizzate tutte le bande multispettrali esportate, in modo da considerare l'intera informazione spettrale disponibile e non solo quella fornita dalla composizione RGB o dai singoli indici.

```r
# glacierClass() esegue una classificazione non supervisionata

class_sep2020 <- glacierClass(sep2020_mask, nClasses = 3) # Classificazione fatta su 3 classi
class_sep2021 <- glacierClass(sep2021_mask, nClasses = 3)
class_sep2023 <- glacierClass(sep2023_mask, nClasses = 3)

# plotClass() visualizza la classificazione con la palette "cividis"

plotClass(class_sep2020)
plotClass(class_sep2021)
plotClass(class_sep2023)
```

<p align="center"><img width="1052" height="327" alt="plotClass2" src="https://github.com/user-attachments/assets/5317b8a1-d58d-4ccd-957d-d05d40b5d290" />

>La classificazione individua tre gruppi spettralmente distinti. Poiché l'algoritmo assegna i numeri delle classi in modo arbitrario e indipendente per ciascun anno, le etichette numeriche non risultano direttamente confrontabili tra le diverse immagini.

## Riclassificazione

Per rendere confrontabili i risultati ottenuti nei tre anni, le etichette numeriche sono state uniformate mantenendo la stessa corrispondenza tra numero di classe e tipologia di superficie.

```r
# subst() riclassifica i valori delle classi

class2020 <- subst(class_sep2020$map, from = c(1, 2, 3), to = c(1, 3, 2))
class2021 <- subst(class_sep2021$map, from = c(1, 2, 3), to = c(1, 2, 3))
class2023 <- subst(class_sep2023$map, from = c(1, 2, 3), to = c(1, 2, 3))

# Palette "cividis" e nome delle classi

colori <- viridis(3, option = "E")
nomi <-c("Superfici a bassa riflettanza", "Ghiaccio con detriti", "Ghiaccio pulito e neve")

# Visualizzazione delle mappe riclassificate

plot(class2020, col=colori, main="2020")
plot(class2021, col=colori, main="2021")
plot(class2023, col=colori, main="2023")

# legend() aggiunge la legenda

legend("bottomleft",  # Posizione della legenda
       legend = nomi, # Eticchette delle classi
       fill = colori, # Colori associati alle classi
       bg = "white",  # Sfondo
       xpd = TRUE)    # Consente di disegnare la legenda anche fuori dal grafico

```

<p align="center"><img width="1052" height="428" alt="plotClass_2_legenda" src="https://github.com/user-attachments/assets/a5dd8ad6-5d7b-46de-850a-e2f58a08138d" />

>Le tre mappe mostrano una distribuzione spaziale complessivamente coerente delle principali coperture superficiali del ghiacciaio. La classe attribuita al ghiaccio pulito/neve interessa prevalentemente le porzioni più elevate del ghiacciaio, mentre le superfici rocciose risultano concentrate nelle aree periferiche prive di copertura glaciale. La classe identificata come ghiaccio sporco, detriti o superfici umide si distribuisce principalmente lungo la lingua glaciale e nelle zone prossime al fronte.

---

# Analisi quantitativa delle classi

Per confrontare quantitativamente le classificazioni ottenute, è stata calcolata la percentuale di copertura di ciascuna classe per ogni anno analizzato.

```r
# freq() calcola la frequenza assoluta dei pixel appartenenti a ciascuna classe

f2020 <- freq(class2020)
f2021 <- freq(class2021)
f2023 <- freq(class2023)

# Calcolo della percentuale di copertura di ogni classe rispetto al totale dei pixel classificati

perc2020 <- (f2020$count / sum(f2020$count)) * 100
perc2021 <- (f2021$count / sum(f2021$count)) * 100
perc2023 <- (f2023$count / sum(f2023$count)) * 100

# round() arrotonda le percentuali a due cifre decimali

round(perc2020, 2)
round(perc2021, 2)
round(perc2023, 2)

# data.frame() crea una tabella riassuntiva con le percentuali di copertura per ciascun anno

tabella <- data.frame(
  Classe = nomi,
  Settembre2020 = round(perc2020, 2),
  Settembre2021 = round(perc2021, 2),
  Settembre2023 = round(perc2023, 2)
)

tabella
```

| Classe | Settembre 2020 (%) | Settembre 2021 (%) | Settembre 2023 (%) |
|:----------------------------------|-------------------:|-------------------:|-------------------:|
| Superfici a bassa riflettanza | 28.33 | 24.60 | 26.97 |
| Ghiaccio con detriti | 26.99 | 23.76 | 26.64 |
| Ghiaccio pulito e neve | 44.68 | 51.65 | 46.39 |

>La classe "Ghiaccio pulito e neve" è quella predominante in tutti gli anni. Le classi "Superfici a bassa riflettanza" e "Ghiaccio con detriti" presentano percentuali inferiori, con una lieve diminuzione nel 2021 e un successivo incremento nel 2023.

## Grafici a barre

Per visualizzare in modo più intuitivo le differenze tra i tre anni, le frequenze relative percentuali delle classi sono state rappresentate mediante grafici a barre utilizzando il pacchetto **ggplot2**. I grafici sono stati successivamente affiancati tramite **patchwork**, così da facilitarne il confronto visivo.

```r
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

```

<img width="1795" height="708" alt="barplot" src="https://github.com/user-attachments/assets/f7c19068-9f82-4a5e-9194-045e9aa8a043" />

---

# 📊 Discussione e Conclusione

argomento

## Limiti dello studio

- utilizzo di sole tre date di acquisizione;
- classificazione non supervisionata soggetta a interpretazione;
- assenza di dati di validazione a terra;
- possibile influenza delle condizioni atmosferiche e dell'illuminazione;
- utilizzo esclusivo di dati ottici Landsat.

---

# 🎯 Conclusione

argomento

---

# 📚 Riferimenti

-  European Space Agency (ESA): https://www.esa.int/Space_in_Member_States/Italy/Immagine_EO_della_Settimana_Ghiacciaio_Columbia_Alaska
-  Google Earth Engine Data Catalog: https://developers.google.com/earth-engine/datasets/catalog/COPERNICUS_S2_SR_HARMONIZED
-  Hood, E., & Berner, L. (2009). Effects of changing glacial coverage on the physical and biogeochemical properties of coastal streams in southeastern Alaska. Journal of Geophysical Research: Biogeosciences, 114(G3). https://doi.org/10.1029/2009JG000971
-  NASA Earth Observatory: https://science.nasa.gov/earth/earth-observatory/alaskas-iconic-columbia-glacier-still-retreats-153291/
-  NASA Earth Observatory. *World of Change: Columbia Glacier*: https://science.nasa.gov/earth/earth-observatory/world-of-change/columbia-glacier/
-  NASA Sea Level Change Portal: https://sealevel.nasa.gov/vesl/web/glaciers/columbia/
