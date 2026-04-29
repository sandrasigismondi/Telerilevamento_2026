# My functions!

somma <- function(x,y) {
  z=x+y
  return(z)
  }

# Excercise: make the function called difference
differenza <- function(x,y) {
  z=x-y
  return(z)
  }

#####

# par(mfrow...)
mf <- function(nx, ny) {
  par(mfrow=c(nx,ny))
  }

# with default
mf <- function(nx=1, ny=2) {
  par(mfrow=c(nx,ny))
  }

# if else
numeri <- function(x){
  if(x>0){
    print("Questo numero è positivo")
   }
  else {
    print("Questo numero è negativo")
   }
  }

numeri <- function(x){
  if(x>0){
    print("Questo numero è positivo")
   }
  else if(x<0) {
    print("Questo numero è negativo")
   }
    else {"Zero"
    }
  }

# for group
loop <- function() {
  for (i in 1:10) {
    print(i)
  }
}

loop()

loop2 <- function() {
  for (i in 1:10) {
    op<- i * 2
    print(op)
  }
}

loop2()

loop3 <- function() {
  for (i in 1:100) {
    op<- (i^3 * 2)/3
    print(op)
  }
}

loop3()


#setwd
sink("data.txt")
loop()
sink() #chiudo la funzione, stessa cosa di dev.off()











