# Titolo progetto esame⛓️

l'area di studio...

ho scelto la mauritania perchè...
<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="800" viewBox=" 0 0 3000 2000"><path fill="#d01c1f" d="M0 0H3000V2000H0z"/><path fill="#00a95c" d="M0 400H3000V1600H0z"/><path fill="#ffd700" d="M1299 744h153l48-144 48 144h153l-126 92 51 146-126-90-126 90 51-146zM750 670a 760.092776 628 0 0 0 1500 0 750 730 0 0 1-1500 0z"/></svg>

<img width="1200" height="800" alt="Flag_of_Mauritania" src="https://github.com/user-attachments/assets/b533f3c6-2b6b-4ab3-b14f-630d382e0bce" />



## Pacchetti utilizzati
per questo esame...

``` r
library(terra)
library(imageRy) # pacchetto per multiframe e altro
```

## Importazione dei dati
i dati sono stati scaricati da [Earth Observatory](https://science.nasa.gov/earth/earth-observatory/eyeing-the-richat-structure/)

I codice usato è il seguente; prima di tutto selezionamo la working directory

``` r
setwd()
# c://bla//bla//bla
getwd()

list.files()

```

per importare dati è stata usata la funzione `rast()` del pacchetto `terra`:

```
richat<- rast("richatstructure_oli_20260306.jpg")
richat<- flip(richat)
plot(richat)
```

<img width="1440" height="960" alt="richatstructure_oli_20260306" src="https://github.com/user-attachments/assets/2c260f8c-a35a-4a42-b1d6-82c4ffbb7551" />


## Analisi esplorativa

``` r
png("bande.png")
im.multiframe(2,1)
plot(richat[[1]])
plot(richat[[2])
dev.off()
```

<img width="480" height="480" alt="bande" src="https://github.com/user-attachments/assets/91ba5ef9-770c-479b-af01-1715635926a7" />

siccome sono pigra uso ciclo for:

```r
par
colori<-c("")
for
```













