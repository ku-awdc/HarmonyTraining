library('runjags')

# Define data:

N<-300

m.short <-
  structure(c(0L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 0L, 1L, 1L, 0L, 1L, 
              1L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 
              1L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 
              1L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 
              1L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 
              1L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 1L, 
              0L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 0L, 
              0L, 1L, 1L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 1L, 
              0L, 1L, 0L, 0L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 1L, 0L, 1L, 1L, 1L, 
              0L, 0L, 1L, 0L, 1L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 1L, 1L, 1L, 
              1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 1L, 0L, 
              1L, 1L, 0L, 1L, 0L, 0L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 0L, 
              0L, 0L, 1L, 1L, 0L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 
              1L, 0L, 1L, 1L, 0L, 1L, 0L, 1L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 0L, 
              1L, 1L, 0L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 0L, 0L, 0L, 0L, 
              1L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 1L, 0L, 1L, 0L, 
              0L, 1L, 1L, 1L, 1L, 0L, 0L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 
              1L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 0L, 0L, 0L, 1L, 
              1L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 
              1L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 
              0L, 1L, 0L, 1L, 0L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 
              1L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 
              0L, 0L, 0L, 1L, 1L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 1L, 
              0L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 
              1L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 
              1L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 
              0L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 0L, 0L, 
              1L, 0L, 1L, 0L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 
              1L, 1L, 0L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 0L, 0L, 0L, 
              0L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 1L, 1L, 0L, 0L, 1L, 0L, 1L, 1L, 
              1L, 1L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 
              0L, 0L, 0L, 0L, 1L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 0L, 0L, 1L, 1L, 
              1L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 1L, 0L, 1L, 
              0L, 0L, 0L, 0L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 
              0L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 
              1L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 
              0L, 0L, 0L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 1L, 0L, 
              0L, 1L, 1L, 1L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 
              1L, 1L, 0L, 0L, 1L, 1L, 0L, 1L, 1L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 
              1L, 1L, 0L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 
              1L, 1L, 0L, 1L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 0L, 
              1L, 0L, 1L, 0L, 1L, 1L, 1L, 0L, 0L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 
              0L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 1L, 
              0L, 0L, 0L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 
              0L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 
              0L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 0L, 
              1L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 0L, 
              1L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 1L, 
              1L, 0L, 0L, 1L, 0L, 1L, 1L, 0L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 0L, 
              0L, 0L, 0L, 0L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 1L, 0L, 
              1L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 
              0L, 1L, 0L, 0L, 0L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 
              1L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 0L, 0L, 
              1L, 0L, 1L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 
              0L, 0L, 0L, 1L, 1L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 
              0L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 1L, 1L, 
              0L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 1L, 0L, 0L, 1L, 0L, 
              1L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 
              1L, 1L, 0L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 1L, 0L, 0L, 1L, 0L, 0L, 
              0L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 1L, 0L, 0L, 1L, 
              1L, 0L, 0L, 1L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 
              0L, 1L, 1L, 0L, 1L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 0L, 0L, 
              1L, 0L, 0L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
              0L, 1L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 0L, 
              1L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 
              1L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 0L, 
              1L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 0L, 
              0L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 1L, 0L, 0L, 1L, 
              1L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 1L, 
              1L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 1L, 
              0L, 1L, 1L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 
              0L, 0L, 1L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 1L, 0L, 1L, 0L, 
              1L, 0L, 0L, 1L, 1L, 0L, 1L, 0L, 1L, 1L, 0L, 1L, 1L, 1L, 0L, 0L, 
              1L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 0L, 1L, 0L, 
              1L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 0L, 
              0L, 0L, 1L, 0L, 0L, 1L, 1L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 0L, 0L, 
              1L, 0L, 1L, 0L, 0L, 0L, 0L, 1L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 
              1L, 1L, 1L, 0L, 0L, 1L, 1L, 0L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 1L, 
              1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 1L, 0L, 0L, 0L, 1L, 
              1L, 0L, 0L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 
              1L, 0L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
              1L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
              1L, 0L, 0L, 1L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 0L, 0L, 0L, 
              0L, 0L, 0L, 1L, 0L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 1L, 0L, 
              1L, 1L, 0L, 0L, 0L, 1L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 
              0L, 0L, 0L, 0L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 1L, 0L, 1L, 1L, 1L, 
              1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 
              0L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 0L, 1L, 
              0L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 
              1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 
              1L, 1L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 
              1L, 0L, 1L, 0L, 0L, 0L, 1L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 
              1L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 0L, 1L, 1L, 1L, 
              1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 
              1L, 0L, 0L, 1L, 0L, 0L, 1L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 
              0L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 
              0L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 
              1L, 1L, 0L, 1L, 1L, 0L, 1L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 
              1L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 1L, 1L, 
              0L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 
              1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 1L, 
              1L, 0L, 1L, 0L, 1L, 1L, 0L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 0L, 0L, 
              0L, 0L, 0L, 0L, 1L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 1L, 0L, 
              1L, 0L, 0L, 0L, 1L, 1L, 1L, 1L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 1L, 
              0L, 0L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 0L, 0L, 0L, 1L, 1L, 1L, 1L, 
              1L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 0L, 0L, 
              1L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
              0L, 0L, 1L, 1L, 1L, 0L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
              1L, 1L, 0L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 0L, 1L, 1L, 
              0L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 1L, 1L, 1L, 
              1L, 0L, 0L, 1L, 1L, 0L, 0L, 1L, 0L, 0L, 0L, 0L, 1L, 0L, 0L, 0L, 
              0L, 0L, 0L, 0L, 1L, 0L, 1L, 1L, 1L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 
              1L, 0L, 0L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 0L), .Dim = c(300L, 6L
              ), .Dimnames = list(NULL, c("Necropsy", "PCR", "ELISA_olddiff", 
                                          "Sex", "Age", "Cestodes")))

ones<-c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)

# We skip other initial values here but that would be a good idea!
inits1 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 100022)
inits2 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 300022)
inits3 = list(".RNG.name" ="base::Mersenne-Twister",
              ".RNG.seed" = 500022)

# run the model - equivalent to the longer scripts:
results_without <- run.jags('model1.bug', data=list(N=N, m.short=m.short, ones=ones), inits=list(inits1, inits2, inits3), monitor=c('prc','c1','c2','c3','s1','s2','s3','deviance','covs12','covs13','covs23','covc12','covc13','covc23'))

results_cestode <- run.jags('model.cestode.bug', data=list(N=N, m.short=m.short, ones=ones), monitor=c('prc','c1','c2','c3','s1','s2','s3','deviance','covs12','covs13','covs23','covc12','covc13','covc23','slope','intercept'))

# These give the main results:
results_without
results_cestode

# And the density plots as in analysis.R:
plot(results_without, plot.type='density', vars=c('c2','c3','s1','s2','s3'))
plot(results_without, plot.type='hist', vars=c('covs12'))

plot(results_cestode, plot.type='density', vars=c('c2','c3','s1','s2','s3'))
plot(results_cestode, plot.type='hist', vars=c('covs12'))


# Or we can extract specific variables e.g. slope and calculate OR and prevalence with and without covariates etc:
slope_samples <- combine.mcmc(results_cestode, vars='slope')
mean(slope_samples)  # slope
exp(mean(slope_samples)) # OR

# prevalence in Taenia neg. population
intercept_samples <- combine.mcmc(results_cestode, vars='intercept')
mean(intercept_samples) # intercept
exp(mean(intercept_samples))

PrTneg_samples <- exp(intercept_samples)/(1+exp(intercept_samples))
PrTneg <- mean(PrTneg_samples)
PrTneg

# prevalence in Taenia pos. population
mean(exp(slope_samples+intercept_samples))

PrTpos_samples <- exp(intercept_samples+slope_samples)/(1+exp(intercept_samples+slope_samples))
PrTpos <- mean(PrTpos_samples)
PrTpos

#############################################################


#Figure 1 effect of Taenia on prevalence of Echinococcus
#Plot for effect of taenia on prevalence
slopd <- slope_samples
itcp <- intercept_samples


plot(density((exp(itcp)/(1+exp(itcp)))), col="blue",ylim=c(0,15),xlim=c(0,1),xlab="",lwd=2);
lines(density((exp(itcp+slopd)/(1+exp(itcp+slopd)))), col="red",lwd=2)
abline(v = PrTneg, col = "blue")
abline(v = PrTpos, col = "red")
