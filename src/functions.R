library(e1071)
library(entropy)
library(psych)

NBTest <- function(dataset,
                   n_trials = 10,
                   n_cv_groups = 10,
                   clname = "Classes",
                   verbose = F) {
  #' NB Test
  #'
  #' Function does a cross-validation test on Naive Bayes analysis for the dataset
  #' Pass it the name of the Class column as clname
  #' @param dataset Dataframe to test
  #' @param n_trials number of times the test will be run; results are averaged across all trials. (default 10)
  #' @param n_cv_groups how many groups used to cross validate? (default 10)
  #' @param clname name of the column with class labels
  #' @return Returns a numeric accuracy rate

  # Makes the formula using the columns
  expr <- as.formula(paste0(clname, "~ ."))

  n_obs <- nrow(dataset)
  cor_rate <- 0
  for (i in 1:n_trials) {
    ind <- sample(rep(1:n_cv_groups, each = ceiling(n_obs / n_cv_groups)),
      size = n_obs,
      replace = F
    )
    # Creates a random order of numbers 1-K (equal numbers of each)

    cor_sum <- 0 # Running total of correct classifications
    for (j in 1:n_cv_groups) {
      # Leaving out 10% of the data randomly and then using the rest to predict
      # its points, and checking how many are correctly predicted.
      temp_result <- naiveBayes(expr, data = dataset[ind != j, ])
      preds <- predict(temp_result, dataset[ind == j, ])

      cor_count <- sum(unlist(dataset[ind == j, clname]) == preds)
      cor_sum <- cor_sum + cor_count
    }
    cor_rate <- cor_rate + (cor_sum / n_obs)
  }
  return(cor_rate / n_trials)
}


PCACompare <- function(dataset,
                       dataset_name = NA,
                       verbose = F) {
  #' PCA Compare
  #'
  #' Function that will take the dataset its given, do NB CV on both the original
  #' and the principle components version, and then return a vector containing the
  #' resulting scores, as well as other summary info about the dataset.
  #' The classes column needs to be the last one!
  len <- length(dimnames(dataset)[[2]])
  names(dataset)[len] <- "Cl"
  datapca <- as.data.frame(princomp(dataset[1:(len - 1)])$scores)
  datapca$Cl <- dataset$Cl

  # Check to make sure the class column is a factor
  stopifnot(is.factor(dataset$Cl))
  stopifnot(is.factor(datapca$Cl))

  orig_res <- NBTest(dataset, clname = "Cl", verbose = verbose)
  pca_res <- NBTest(datapca, clname = "Cl", verbose = verbose)
  results <- c(
    "Orig" = orig_res,
    "PCA" = pca_res,
    "Diff" = pca_res - orig_res,
    "NFeatures" = len - 1,
    "NGroups" = length(unique(dataset$Cl)),
    "NObs" = length(dimnames(dataset)[[1]]),
    "Entropy" = entropy.plugin(eigen(cor(dataset[, -len]))$values / dim(dataset[, -len])[2]),
    "KMO" = KMO(dataset[, -len])$MSA
  )
  # Add an extra column to name dataset
  if (!is.na(dataset_name)) {
    results["dataset"] <- dataset_name
  }


  return(results)
}
