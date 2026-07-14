> ### Telerilevamento geo-ecologico in R
>> Sandra Sigismondi

# Analisi multitemporale delle variazioni superficiali del Columbia Glacier (Alaska) mediante dati Landsat e Remote Sensing in R

## ⛰️ Introduzione

Il **Columbia Glacier** è uno dei ghiacciai di marea (*tidewater glacier*) più studiati al mondo e rappresenta uno dei casi più emblematici di rapido ritiro glaciale osservato negli ultimi decenni. Situato nei Monti Chugach, nell'Alaska meridionale, il ghiacciaio si estende da un campo glaciale posto a circa **3050 m s.l.m.** fino al Prince William Sound.

<p align="center"><img width="520" height="280" alt="columbiaglacier_pho_201606" src="https://github.com/user-attachments/assets/6023d73b-2f6b-4b60-a53f-0b7da76d1e5b" />

A partire dai primi anni Ottanta il Columbia Glacier ha iniziato un rapido arretramento della fronte glaciale che continua ancora oggi. Dal 1980 il ramo principale ha perso oltre **20 km** di lunghezza e più della metà del proprio volume e spessore. Tale evoluzione è dovuta sia all'aumento delle temperature atmosferiche e oceaniche, sia a processi meccanici quali il distacco del ghiacciaio dalla morena terminale e l'intenso fenomeno di *calving*, ovvero il distacco di iceberg dalla fronte glaciale (NASA Earth Observatory).

L'evoluzione del Columbia Glacier rappresenta quindi un importante indicatore degli effetti dei cambiamenti climatici e costituisce un laboratorio naturale per applicare tecniche di telerilevamento multispettrale.

<p align="center"><img width="547" height="418" alt="Columbia Glacier" src="https://github.com/user-attachments/assets/8d042c35-0369-4356-83c1-5371437bc134">

###  📌 Obiettivo dello studio

Analizzare l'evoluzione superficiale del Columbia Glacier tra **settembre 2020**, **settembre 2021** e **settembre 2023** tramite:
- visualizzazione RGB delle immagini;
- calcolo del **Normalized Difference Snow Index (NDSI)**;
- classificazione non supervisionata delle principali coperture superficiali;
- confronto quantitativo delle percentuali di copertura delle classi;
- analisi delle componenti principali (PCA);
- stima dell'eterogeneità spaziale mediante deviazione standard locale della prima componente principale.

---

# 🛰️ Materiali e metodi

## Dataset

Sono state utilizzate tre immagini satellitari Landsat acquisite nei mesi di settembre degli anni:

- Settembre 2020
- Settembre 2021
- Settembre 2023

# 1. Preparazione delle immagini

Le immagini satellitari vengono importate come oggetti `SpatRaster` e ritagliate utilizzando il perimetro del ghiacciaio. (fonte)

```r
sep2020 <- rast("columbia_september2020.tif")
sep2020_mask <- prepareGlacier(sep2020, columbia)

sep2021 <- rast("columbia_september2021.tif")
sep2021_mask <- prepareGlacier(sep2021, columbia)

sep2023 <- rast("columbia_september2023.tif")
sep2023_mask <- prepareGlacier(sep2023, columbia)
```


---

## Software

L'intera analisi è stata svolta in **R** con i seguenti pacchetti:

```r
library(terra)      # gestione dei raster e operazioni spaziali
library(viridis)    # palette cromatiche
library(RStoolbox)  # classificazione non supervisionata e PCA
```

utilizzando il pacchetto **glacieR**, disponibile al seguente link:

➡️ **https://github.com/sandrasigismondi/glacieR**

<img width="54" height="54" alt="glacieR_logo" src="https://github.com/user-attachments/assets/f9e15aed-e81c-4156-9ea3-90b75071ed5c" />

---

## Analisi
- visualizzazione RGB;
- calcolo dell'indice NDSI;
- classificazione non supervisionata in tre classi;
- calcolo delle percentuali di copertura;
- rappresentazione grafica delle variazioni temporali

---

# 📊 Risultati

## Immagini RGB

Per ogni anno viene costruita una composizione a colori reali (RGB), utile per una prima valutazione visiva dello stato del ghiacciaio.

```r
plotGlacierRGB(sep2020_mask, r = 3, g = 2, b = 1)
plotGlacierRGB(sep2021_mask, r = 3, g = 2, b = 1)
plotGlacierRGB(sep2023_mask, r = 3, g = 2, b = 1)
```

<p align="center"><img width="727" height="294" alt="plotGlacierRGB" src="https://github.com/user-attachments/assets/709993e4-223e-4f50-a365-8abca989ef3e" />

---

## Calcolo del NDSI

L'indice **NDSI (Normalized Difference Snow Index)** permette di evidenziare neve e ghiaccio pulito.

```r
ndsi_sep2020 <- glacierNDSI(sep2020_mask, green = 2, swir = 5)
ndsi_sep2021 <- glacierNDSI(sep2021_mask, green = 2, swir = 5)
ndsi_sep2023 <- glacierNDSI(sep2023_mask, green = 2, swir = 5)

plotNDSI(ndsi_sep2020)
plotNDSI(ndsi_sep2021)
plotNDSI(ndsi_sep2023)
```

Valori elevati di NDSI identificano principalmente neve e ghiaccio pulito, mentre valori bassi corrispondono a ghiaccio coperto da detrito, rocce o acqua.

<p align="center"><img width="727" height="217" alt="plotNDSI" src="https://github.com/user-attachments/assets/029969e3-886d-4e9e-b0e3-53be1b25d9dd" />

---

## Calcolo dell'NDWI

L'indice **NDWI (Normalized Difference Water Index)** viene utilizzato per individuare la presenza di acqua superficiale e acqua di fusione.

```r
ndwi_sep2020 <- glacierNDWI(sep2020_mask, green = 3, nir = 5)
ndwi_sep2021 <- glacierNDWI(sep2021_mask, green = 3, nir = 5)
ndwi_sep2023 <- glacierNDWI(sep2023_mask, green = 3, nir = 5)

plotNDWI(ndwi_sep2020)
plotNDWI(ndwi_sep2021)
plotNDWI(ndwi_sep2023)
```

Valori elevati indicano la presenza di acqua liquida, mentre valori inferiori sono associati a neve, ghiaccio e superfici rocciose.

<p align="center"><img width="727" height="213" alt="plotNDWI" src="https://github.com/user-attachments/assets/b18d0538-65e3-4663-8065-9371a99d986b" />


---


## Classificazione non supervisionata

Per ogni immagine è stata eseguita una classificazione non supervisionata mediante algoritmo **k-means**, suddividendo la superficie glaciale in tre classi spettrali.

```r
class_sep2020 <- glacierClass(sep2020_mask, nClasses = 3)
class_sep2021 <- glacierClass(sep2021_mask, nClasses = 3)
class_sep2023 <- glacierClass(sep2023_mask, nClasses = 3)

plotClass(class_sep2020)
plotClass(class_sep2021)
plotClass(class_sep2023)
```

Le classi sono state successivamente associate alle seguenti categorie:

- Superfici scure
- Ghiaccio coperto da detrito
- Neve / ghiaccio pulito

<p align="center">

---

## Analisi quantitativa delle classi


---

### Percentuali di copertura


---

# 💬 Discussione

L'analisi multitemporale evidenzia come il Columbia Glacier presenti variazioni nella distribuzione delle principali coperture superficiali tra il 2020 e il 2023.

L'NDSI conferma la predominanza di valori elevati associati alla neve e al ghiaccio, mentre le classificazioni non supervisionate permettono di distinguere efficacemente tre macro-tipologie superficiali: superfici scure, ghiaccio ricoperto da detrito e neve/ghiaccio pulito.

L'analisi PCA mostra che la quasi totalità della variabilità radiometrica è concentrata nella prima componente principale (>98%), indicando una forte ridondanza informativa tra le bande Landsat.

L'analisi dell'eterogeneità evidenzia una lieve maggiore variabilità nel 2021 rispetto agli altri anni, probabilmente riconducibile a differenti condizioni superficiali, distribuzione del detrito o condizioni di illuminazione al momento dell'acquisizione.

I risultati sono coerenti con quanto riportato dalla letteratura scientifica, che descrive il Columbia Glacier come un ghiacciaio in rapido ritiro caratterizzato da continue modificazioni morfologiche e da un'intensa dinamica di fusione e calving.

## Limiti dello studio

L'analisi presenta alcuni limiti:

- utilizzo di sole tre date di acquisizione;
- classificazione non supervisionata soggetta a interpretazione;
- assenza di dati di validazione a terra;
- possibile influenza delle condizioni atmosferiche e dell'illuminazione;
- utilizzo esclusivo di dati ottici Landsat.

Un'analisi più completa potrebbe integrare immagini Sentinel-2, dati SAR e modelli digitali di elevazione per valutare anche le variazioni volumetriche.

---

# 📎 Conclusione
Questo lavoro dimostra come il telerilevamento multispettrale rappresenti uno strumento efficace per monitorare l'evoluzione dei ghiacciai.

L'integrazione tra immagini RGB, indice NDSI, classificazione non supervisionata, PCA e analisi dell'eterogeneità consente di descrivere quantitativamente le variazioni superficiali del Columbia Glacier e di individuare differenze spaziali e temporali tra gli anni analizzati.

Tali metodologie costituiscono un valido supporto per il monitoraggio degli effetti dei cambiamenti climatici sui ghiacciai e possono essere facilmente replicate su altri sistemi glaciali mediante dati satellitari liberamente disponibili.

---

# 📚 Riferimenti

- Columbia glacier shapefile: https://sealevel.nasa.gov/vesl/web/glaciers/columbia/
- Documentazione Sentinel-2 ESA - [Google Earth Engine](https://earthengine.google.com/)
-  NASA Earth Observatory. *World of Change: Columbia Glacier*.
