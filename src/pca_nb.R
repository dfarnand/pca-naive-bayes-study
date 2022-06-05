#############################################################################
## Daniel Farnand                                                          ##
## Testing Naive Bayes Classification with and without Principle Component ##
## Analysis on Fundamental Clustering Problems Suite (FCPS)                ##
#############################################################################

library(here)
source(here("src", "functions.R"))

# require(klaR)
library(tidyverse)
# require(foreign)
# require(e1071)
# require(mlbench)
# require(entropy)
# require(psych)
# require(rgl)

# #################################################################################
# ## Function to Simplify adding a row to a dataframe and updating the rownames. ##
# #################################################################################
# 
# dfaddrow <- function(datafr, newrow, rowname) {
#   temprows <- rownames(datafr)
#   datafr <- rbind(datafr,newrow)
# 
#   rownames(datafr) <- c(temprows,rowname)
# 
#   return(datafr)
# }


################################################################################

print("Getting started")
set.seed(2011)

#######################################################
## Building a Dataframe of Different Dataset Results ##
#######################################################

## Importing Data
files <- c("Hepta",
           "Lsun", 
           "Tetra", 
           # "Chainlink", 
           "Atom", 
           "EngyTime", 
           "Target",
           "TwoDiamonds", 
           "WingNut", 
           "GolfBall")
lrn_filenames = here("data", "FCPS", "01FCPSdata", str_c(files, ".lrn"))
cls_filenames = here("data", "FCPS", "01FCPSdata", str_c(files, ".cls"))

# fcpsdata <- vector(mode="list", length=length(files))
fcps_data <-
  map(
    lrn_filenames,
    read_tsv,
    comment = "%",
    col_names = FALSE,
    col_select = -X1
  ) %>% setNames(files)

fcps_cls_data <-
  map(
    cls_filenames,
    read_tsv,
    comment = "%",
    col_names = c("X1", "Classes"),
    # col_types = "if",
    col_select = -X1
  ) %>% setNames(files)

fcps <- map2(fcps_data, fcps_cls_data, bind_cols)
PCACompare(fcps[[3]])


  # map(files, ~read_csv(paste("FCPS/01FCPSdata/",.,".lrn",sep=""),
  #                                 header=T,row.names=1,sep="\t",comment.char="%"))
names(fcpsdata) <- files
for(d in seq_along(fcpsdata)) {
  fcpsdata[[d]]$Classes <- factor(unlist(read.table(paste("FCPS/01FCPSdata/"
                                                         ,files[d],".cls",sep=""),
                                                    header=F,row.names=1,sep="\t",
                                                    comment.char="%")))
}


resultsDF <- data.frame()

for (ds in seq_along(fcpsdata)) {
  resultsDF <- df.addrow(resultsDF, PCA.Compare(fcpsdata[[ds]]), files[ds])}




################
## Crabs Data ##
################

crabs <- read.dta("crabs.dta")
crabs$Classes <- factor(2*(crabs$sex=="Female")+(crabs$species=="Orange"))

resultsDF <- df.addrow(resultsDF,PCA.Compare(crabs[,4:9]),"Crabs")


###############
## Iris Data ##
###############

data(iris)
##irispca <- as.data.frame(princomp(iris[1:4])$scores)
##irispca$Species <- iris$Species

## NB.Test(iris, clname="Species")
## NB.Test(irispca, clname="Species")

resultsDF <- df.addrow(resultsDF,PCA.Compare(iris),"Iris")


###############
## Wine Data ##
###############
wine <- read.table("wine/wine.data",sep=",")
wine[,15] <- as.factor(wine[,1])
wine <- wine[-1]

resultsDF <- df.addrow(resultsDF,PCA.Compare(wine),"Wine")


###############
## Spam Data ##
###############
spam <- read.table("spambase/spambase.data",sep=",")
#spam[,58] <- as.factor(spam[,58])

resultsDF <- df.addrow(resultsDF,PCA.Compare(spam),"Spam")

resultsDF


##################
## Climate Data ##
##################

clim <- read.table("pop_failures.dat", sep="", header=T)

resultsDF <- df.addrow(resultsDF,PCA.Compare(clim[,3:21]),"Climate")


################
## Blood Data ##
################

blood <- read.table("transfusion.data", sep=",", header=T)

resultsDF <- df.addrow(resultsDF,PCA.Compare(blood),"Blood")


################
## Liver Data ##
################

liver <- read.table("Indian Liver Patient Dataset (ILPD).csv",sep=",")
liver$V2 <- as.numeric(liver$V2)

resultsDF <- df.addrow(resultsDF,PCA.Compare(liver),"Liver")


##############
## Fog Data ##
##############

fog <- read.table("dataset_fog_release/dataset/S01R01.txt")

resultsDF <- df.addrow(resultsDF,PCA.Compare(fog,verbose=T),"FOG")


##################
## Seismic Data ##
##################

seismic <- read.table("seismic-bumps.arff",sep=",",skip=154)

resultsDF <- df.addrow(resultsDF,PCA.Compare(seismic[,c(4:7,9:13,17:19)]),"Seismic")


################
## Glass Data ##
################

glass <- read.table("glass/glass.data",sep=",")

resultsDF <- df.addrow(resultsDF,PCA.Compare(glass),"Glass")



########################
## Breast Cancer Data ##
########################

data(BreastCancer)

resultsDF <- df.addrow(resultsDF,PCA.Compare(BreastCancer[,-1]),"Cancer")


################
## Sonar Data ##
################

data(Sonar)

resultsDF <- df.addrow(resultsDF,PCA.Compare(Sonar),"Sonar")

###################
## Diabetes Data ##
###################

data(PimaIndiansDiabetes)

resultsDF <- df.addrow(resultsDF,PCA.Compare(PimaIndiansDiabetes),"Diabetes")

#####################
## Ionosphere Data ##
#####################

data(Ionosphere)

resultsDF <- df.addrow(resultsDF,PCA.Compare(Ionosphere[,3:35]),"Ionosphere")


###################
## Vehicles Data ##
###################
vehicles <- read.table("vehicles/vehicles.dat")

resultsDF <- df.addrow(resultsDF,PCA.Compare(vehicles),"Vehicles")


################
## Yeast Data ##
################

yeast <- read.table("yeast/yeast.data")
##Removed columns with low variance
resultsDF <- df.addrow(resultsDF,PCA.Compare(yeast[,c(-1,-6,-7)]),"Yeast")



##                  Orig       PCA NFeatures NGroups   NObs        Change
## Hepta       1.0000000 1.0000000         3       7    212  0.0000000000
## Lsun        1.0000000 0.9975000         2       3    400 -0.0025000000
## Tetra       1.0000000 1.0000000         3       4    400  0.0000000000
## Chainlink   0.9798000 0.6538000         3       2   1000 -0.3260000000
## Atom        0.9953750 0.9952500         3       2    800 -0.0001250000
## EngyTime    0.9574463 0.9566406         2       2   4096 -0.0008056641
## Target      1.0000000 1.0000000         2       6    770  0.0000000000
## TwoDiamonds 1.0000000 1.0000000         2       2    800  0.0000000000
## WingNut     0.9917323 0.9646654         2       2   1016 -0.0270669291
## GolfBall           NA        NA         3       1   4002            NA
## Crabs       0.3740000 0.9330000         5       4    200  0.5590000000
## Iris        0.9533333 0.9206667         4       3    150 -0.0326666667
## Wine        0.9730337 0.9573034        13       3    178 -0.0157303371
## Spam        0.7131928 0.7484677        57       2   4601  0.0352749402
## Climate     0.9490741 0.9333333        18       2    540 -0.0157407407
## Blood       0.7505348 0.7783422         4       2    748  0.0278074866
## Liver       0.5507719        NA        10       2    583            NA
## FOG         0.7806582 0.8546659        10       3 151987  0.0740076454
## Seismic            NA 0.8885836        14       2   2584            NA
## Glass              NA 0.9355140        10       6    214            NA
## Cancer      0.9738197        NA         9       2    699            NA
## Sonar       0.6793269 0.7250000        60       2    208  0.0456730769
## Diabetes    0.7541667 0.7467448         8       2    768 -0.0074218750
## Ionosphere  0.8190883 0.9031339        32       2    351  0.0840455840
## Vehicles    0.4576832 0.7621749        18       4    846  0.3044917
## Yeast       0.5715633 0.552628          6      10   1484 -0.0189353

