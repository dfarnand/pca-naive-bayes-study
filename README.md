# Study of PCA and Naive Bayes

This repo contains code and the contents for an empirical study of the usage of Principle Component Analysis (PCA) for improving the performance of Naive Bayes classifiers.

More details and findings [in the paper](report/pca_nb_report.md).

The remainder of this readme will refer to running code to replicate the study.

## Data

This study uses several external datasets. However if you want to skip those sources, you can limit the code to only run on datasets included in the R packages by setting `BUILTIN_ONLY=TRUE` at the top of `src/pca_nb.R`.

External datasets:

- **Fundamental Clustering Problems Suite (FCPS)**: [download `FCPS.zip` from here](https://www.researchgate.net/publication/281492504_Fundamental_Clustering_Problems_Suite_FCPS) and extract the contents to the `data` folder.

The following files should be obtained and copied to the `data/` folder:

- `wine.data` from http://archive.ics.uci.edu/ml/datasets/Wine
- `spambase.data` from https://archive.ics.uci.edu/ml/datasets/spambase
- `pop_failures.dat` from https://archive.ics.uci.edu/ml/datasets/climate+model+simulation+crashes
- `transfusion.data` from https://archive.ics.uci.edu/ml/datasets/Blood+Transfusion+Service+Center
- `Indian Liver Patient Dataset (ILPD).csv` from https://archive.ics.uci.edu/ml/datasets/ILPD+(Indian+Liver+Patient+Dataset)
- `S01R01.txt` from https://archive.ics.uci.edu/ml/datasets/Daphnet+Freezing+of+Gait
- `seismic-bumps.arff` from https://archive.ics.uci.edu/ml/datasets/seismic-bumps
- `yeast.data` from https://archive.ics.uci.edu/ml/datasets/Yeast

## Environment

To make sure you have the right environment set up for the code, its recommended that you use [renv](https://rstudio.github.io/renv/articles/renv.html). 

Once renv is installed, you can run `renv::restore()` from an R session in the project directory to get the specific package versions that I used.

## Code

You should run the `pca_nb.R` file, either by sourcing in Rstudio or from the command line:
```
Rscript src/pca_nb.R
```

This will print the results and save a copy of the results table to `data/results_table.csv`