###################################################################################################
# 0) Settings, libraries & inits 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
library(plyr)
library(dplyr)
library(reshape2)

# Download, unpack and look at data 
#
#Downlaod directly to wd()
#download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "Dataset.zip")

#One can just run unzip to unzip dataset directly to wd
#unzip(zipfile = "Dataset.zip")


# look at folders & files
#list.dirs()
#list.files(path = paste0(project_path, "/UCI HAR Dataset/"))
#list.files(path = paste0(project_path, "/UCI HAR Dataset/test/"))
#list.files(path = paste0(project_path, "/UCI HAR Dataset/train"))


###################################################################################################
#
# 1) Loading & Merging data data 
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# Here we load and merge data
# load train and test separately to check that dimensions for labels and and data match.
# The data covers measurements of 561 variables from different activities.
# The labels denote the activity category.


#load training data, labels and subjects
data_train     <- read.table(file = "UCI HAR Dataset/train/X_train.txt")
labels_train   <- read.table(file = "UCI HAR Dataset/train/Y_train.txt")
subjects_train <- read.table(file = "UCI HAR Dataset/train/subject_train.txt")

#load test data, labels and subjects
data_test      <- read.table(file = "UCI HAR Dataset/test/X_test.txt")
labels_test    <- read.table(file = "UCI HAR Dataset/test/Y_test.txt")
subjects_test  <- read.table(file = "UCI HAR Dataset/test/subject_test.txt")


#load features
#The features data denotes the variable names of the data
features     <- read.table(file = "UCI HAR Dataset/features.txt")


#merge data
data_total     <- rbind(data_train,     data_test)
labels_total   <- rbind(labels_train,   labels_test)
subjects_total <- rbind(subjects_train, subjects_test)


#remove unused data frames
rm(data_train, data_test, labels_train, labels_test, subjects_train, subjects_test)

#Let's apply feature (variable) names to the dataset
colnames(data_total)  <- features$V2

#Apply activiy label and subject identifier as new columns for a pretty dataset
data_total$activityNumber    <- labels_total$V1
data_total$subjectIdentifier <- subjects_total$V1

#remove unused features, labels and subjects dataframes
rm(features, labels_total, subjects_total)


###################################################################################################
#
# 2) Extract only measurements for mean and standard dev 
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#Find columns that contain "mean" for finding mean-value columns
mean_columns <- grep("mean()", colnames(data_total))

#Find columns that contain "std"
std_columns  <- grep("std", colnames(data_total))

#Subset to new data containing only mean and std
new_columns  <- c(mean_columns, std_columns)      #all columns contain mean or std
new_columns  <- new_columns[order(new_columns)]   #order by original col-number to keep original order
data_meanstd <- data_total[, c(new_columns)] #subset

# Remove unused vectors
rm(mean_columns, std_columns, new_columns)



###################################################################################################
#
# 3) Descriptive names for activities
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#load activity labels
activity_labels <- read.table(file = "UCI HAR Dataset/activity_labels.txt")

#Apply column names for matching
colnames(activity_labels) <- c("activityNumber", "activityLabel")

#join using plyrs join function to add descriptive labels
data_total <- join(data_total, activity_labels, by = "activityNumber")

#It would be fine to delete the column with the activity number now
data_total <- data_total[, -(colnames(data_total) %in% c("activityNumber"))]

#clean the environment for unused objects
rm(activity_labels)



###################################################################################################
#
# 4) Descriptive variable names
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# We applied feature names already in 1)


###################################################################################################
#
# 5) Tidy data - average of each variable for each activity and each subject
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#This sounds like a job for dplyr... Is it a bird, is it a plane? No, it's dplyr!

#we group by subject, then activity, then use summarize_all to get mean of all columns
#we should get 180 rows which is 30 subjects * 6 activities
data_tidy <- data_total %>% group_by(subjectIdentifier, activityLabel) %>% summarise_all(mean)

#rename "value" column to mean, as this is more correct (as we just took the mean of the variables)
colnames(data_tidy)[which(colnames(data_tidy) == "value")] <- "mean"
colnames(data_tidy)

#output dataframe
write.table(data_tidy, file = "data_tidy.txt", row.names = FALSE)
