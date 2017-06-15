# Getting and Cleaning Data Course Project

This repo contains the following files
- README.md
- run_analysis.R - which cointains R-code to make the tidy-data if working directory contains the dataset "UCI HAR Dataset".
- codebook.txt - describing the variables, copyied directly from the original authors of the dataset: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 


## Info about the script

The script works in 6 stages. The first, 0), setting libraries and with commented code for downloading and unpacking the data, if this is needed.

Stages 1-5 follow the order of the tasks given on the project assignment page at Coursera. In brief the code works like this:

1) Load the different data files stepwise for inspection, merge the data and assign column-names, add activity numbers (labels) and subject identifiers.
2) Extract only columns that contain mean or std values for the variables of measurement.
3) Apply descriptive activity names (removes activity numbers)
4) (Course assignment was to apply proper variable (column) names, this is done already in step 1.
5) Get means for all measurements by subject and activity (in that order), and tidy data.

More details can be found in the script comments.
