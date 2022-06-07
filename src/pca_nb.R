## Daniel Farnand
## Testing Naive Bayes Classification with and without Principle Component
## Analysis on Fundamental Clustering Problems Suite (FCPS)

# Set this to true run only on datasets that are built into the packages
BUILTIN_ONLY = FALSE

library(tidyverse)
library(here)

source(here("src/functions.R"))

set.seed(2011)
results_list = list()


## FCPS Datasets* ####

if (!BUILTIN_ONLY) {
  files <- c("Hepta",
             "Lsun",
             "Tetra",
             "Atom",
             "EngyTime",
             "Target",
             "TwoDiamonds",
             "WingNut")
  lrn_filenames = here("data/FCPS/01FCPSdata", str_c(files, ".lrn"))
  cls_filenames = here("data/FCPS/01FCPSdata", str_c(files, ".cls"))
  
  # Loading the data and labels for each dataset separately, then combining
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
      col_types = "if",
      col_select = -X1
    ) %>% setNames(files)
  
  fcps <- map2(fcps_data, fcps_cls_data, bind_cols)
  
  res_fcps <- map2(fcps, files, ~PCACompare(.x, dataset_name = .y))
  results_list <- append(results_list, res_fcps)
}


## Crabs Data ####

data(crabs, package="MASS")

crabs <- crabs %>%
  mutate(Classes = factor(2 * (crabs$sex == "F") + (crabs$sp == "O"))) %>%
  select(FL, RW, CL, CW, BD, Classes)

results_list <-
  append(results_list, list(PCACompare(crabs, dataset_name = "Crabs")))


## Iris Data #####

data(iris)
results_list <-
  append(results_list, list(PCACompare(iris, dataset_name = "Iris")))


## Wine Data* ####

if (!BUILTIN_ONLY) {
  wine <- read_csv(here("data/wine.data"), col_names = FALSE) %>%
    select(X2:X14, Classes = X1) %>%
    mutate(Classes = as.factor(Classes))

  results_list <-
    append(results_list, list(PCACompare(wine, dataset_name = "Wine")))
}


## Spam Data* ####

if (!BUILTIN_ONLY) {
  spam <- read_csv(here("data/spambase.data"), col_names = FALSE) %>%
    mutate(X58 = as.factor(X58))
  
  results_list <-
    append(results_list, list(PCACompare(spam, dataset_name = "Spam")))
}


## Climate Data* ####

if (!BUILTIN_ONLY) {
  clim <- read_table(here("data/pop_failures.dat")) %>%
    select(-Study,-Run) %>%
    mutate(outcome = as.factor(outcome))
  
  results_list <-
    append(results_list, list(PCACompare(clim, dataset_name = "Climate")))
}


## Blood Data* ####

if (!BUILTIN_ONLY) {
  blood <-
    read_csv(here("data/transfusion.data"),
             col_names = FALSE,
             skip = 1) %>%
    mutate(X5 = as.factor(X5))
  
  results_list <-
    append(results_list, list(PCACompare(blood, dataset_name = "Blood")))
}


## Liver Data* ####

if (!BUILTIN_ONLY) {
  liver <-
    read_csv(here("data/Indian Liver Patient Dataset (ILPD).csv"),
             col_names = FALSE) %>%
    mutate(X2 = ifelse(X2 == "Female", 1, 0),
           X11 = as.factor(X11)) %>%
    filter(!is.na(X10)) # Removes 4 rows with missing value
  
  results_list <-
    append(results_list, list(PCACompare(liver, dataset_name = "Liver")))
}


## Fog Data* ####

if (!BUILTIN_ONLY) {
  fog <- read_table(here("data/S01R01.txt"), col_names = FALSE) %>%
    mutate(X11 = as.factor(X11))

  results_list <-
    append(results_list, list(PCACompare(fog, dataset_name = "FOG")))
}


## Seismic Data* ####

if (!BUILTIN_ONLY) {
  seismic <- read_csv(here("data/seismic-bumps.arff"), col_names=FALSE, skip = 154) %>%
    select(X4:X7, X9:X13, X17:X19) %>%
    mutate(X19 = as.factor(X19))
  
  results_list <-
    append(results_list, list(PCACompare(seismic, dataset_name = "Seismic")))
}


## Glass Data ####

data(Glass, package="mlbench")

glass <- mutate(Glass, Type = as.factor(Type))
  
results_list <-
  append(results_list, list(PCACompare(glass, dataset_name = "Glass")))


## Breast Cancer Data ####

data(biopsy, package="MASS")

cancer = biopsy %>% 
  select(-ID) %>%
  filter(!is.na(V6)) # Removes 16 rows

results_list <-
  append(results_list, list(PCACompare(cancer, dataset_name = "Cancer")))


## Sonar Data #####

data(Sonar, package="mlbench")


results_list <-
  append(results_list, list(PCACompare(Sonar, dataset_name = "Sonar")))


## Diabetes Data #####################

data(PimaIndiansDiabetes, package="mlbench")

results_list <-
  append(results_list, list(PCACompare(PimaIndiansDiabetes, dataset_name = "Diabetes")))


## Ionosphere Data #######################

data(Ionosphere, package="mlbench")

iono <- Ionosphere %>%
  select(V3:Class)

results_list <-
  append(results_list, list(PCACompare(iono, dataset_name = "Ionosphere")))


## Vehicles Data #####################

data(Vehicle, package="mlbench")

results_list <-
  append(results_list, list(PCACompare(Vehicle, dataset_name = "Vehicle")))


## Yeast Data* ##################

if (!BUILTIN_ONLY) {
  yeast <- read_table(here("data/yeast.data"), col_names=FALSE) %>%
    select(-X1, -X6, -X7) %>%
    mutate(X10 = as.factor(X10))
  
  results_list <-
    append(results_list, list(PCACompare(yeast, dataset_name = "Yeast")))
}

## Displaying and Saving Summary ####

results_df = bind_rows(results_list)
write_csv(results_df, here("data/results_table.csv"))

print(results_df, n=nrow(results_df))
