> ### Telerilevamento geo-ecologico in R
>> Sandra Sigismondi

# Analisi multitemporale del Columbia Glacier mediante telerilevamento in R / Evoluzione superficiale del Columbia Glacier (2020–2023) mediante immagini Sentinel-2

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
- calcolo del **Normalized Difference Snow Index (NDSI)**;
- calcolo del **Normalized Difference Water Index (NDWI)**;
- classificazione non supervisionata delle principali coperture superficiali;
- confronto quantitativo delle percentuali di copertura delle classi.

---

# 🛰️ Materiali e metodi

Pacchetti R utilizzati nelle analisi:

```r
library(terra)      # Gestione dei raster e shapefile, operazioni spaziali e funzioni di visualizzazione
library(viridis)    # Palette cromatiche
library(RStoolbox)  # Classificazione non supervisionata
library(glacieR)    # Strumenti per l'analisi dei ghiacciai tramite telerilevamento
```

 **glacieR** ➡️ **https://github.com/sandrasigismondi/glacieR**
 
 <img width="54" height="54" alt="glacieR_logo" src="https://github.com/user-attachments/assets/f9e15aed-e81c-4156-9ea3-90b75071ed5c" />

Immagini Sentinel-2 Surface Reflectance Harmonized scaricate da [Google Earth Engine](https://earthengine.google.com/) con risoluzione spaziale di 20 m. Sono state esportate le bande presenti in tabella.

| Banda | Colore | R |
| :---: | :---: | :--- |
| **B2** | Blu | [[1]] |
| **B3** | Verde | [[2]] |
| **B4** | Rosso | [[3]] |
| **B8** | Vicino Infrarosso (NIR) | [[4]] |
| **B11** | SWIR 1 | [[5]] |
| **B12** | SWIR 2 | [[6]] |

```r
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

<p align="center"><img width="727" height="327" alt="plotRGBsettembre" src="https://github.com/user-attachments/assets/b9f6b39a-7e22-4dc2-a4d2-b7565e91e531" />

Le aree innevate e coperte da ghiaccio appaiono prevalentemente bianche, le superfici detritiche assumono tonalità grigio-scure, mentre i corpi idrici risultano molto scuri. Le differenze più evidenti si osservano in corrispondenza della lingua glaciale, che mostra un progressivo arretramento tra il 2020 e il 2023.

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

plotNDSI(ndsi_sep2020)
plotNDSI(ndsi_sep2021)
plotNDSI(ndsi_sep2023)
```

<p align="center"><img width="727" height="217" alt="plotNDSI" src="https://github.com/user-attachments/assets/029969e3-886d-4e9e-b0e3-53be1b25d9dd" />

Le aree innevate e coperte da ghiaccio appaiono prevalentemente bianche, le superfici detritiche assumono tonalità grigio-scure, mentre i corpi idrici risultano molto scuri. Le differenze più evidenti si osservano in corrispondenza della lingua glaciale, che mostra un progressivo arretramento tra il 2020 e il 2023.

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

plotNDWI(ndwi_sep2020)
plotNDWI(ndwi_sep2021)
plotNDWI(ndwi_sep2023)
```

<p align="center"><img width="727" height="244" alt="plotNDWI" src="https://github.com/user-attachments/assets/cc53183b-c730-4674-9b2a-e5d0c07841c6" />

Le tre mappe mostrano una distribuzione spaziale dell'NDWI piuttosto simile. Le differenze osservabili sono localizzate in prossimità del fronte glaciale e delle aree di drenaggio.

---

# Classificazione non supervisionata

È stata applicata una classificazione non supervisionata mediante algoritmo k-means, specificando tre classi. L'algoritmo raggruppa automaticamente i pixel in base alla loro similarità spettrale, senza utilizzare campioni di addestramento. Successivamente le classi sono state interpretate come superfici scure, ghiaccio coperto da detrito e neve/ghiaccio pulito.

```r
# glacierClass() 

class_sep2020 <- glacierClass(sep2020_mask, nClasses = 3)
class_sep2021 <- glacierClass(sep2021_mask, nClasses = 3)
class_sep2023 <- glacierClass(sep2023_mask, nClasses = 3)

# plotClass() visualizza la classificazione con la palette "cividis"

plotClass(class_sep2020)
plotClass(class_sep2021)
plotClass(class_sep2023)
```

<p align="center">

---

# Analisi quantitativa delle classi

argomento

---

# Percentuali di copertura

argomento

---

# 📊 Discussione

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
