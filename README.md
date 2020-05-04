---
title: "README"
author: "Megan Siemann"
date: "5/1/2020"
output: pdf_document
---

# Getting and Cleaning Data Course Project

Codebook - describes the variables and
README - this file! The guide to ,y code and decisions made in tidying and
analysing the data
run_analysis.R - the script file that contains all my code from downloading to
cleaning to analysis 
tidy_data.txt - The final independent tidy dataset

## My Steps

1. Download and unzip data set
2. Read in and build up test and train datasets to have complete observations
3. Merges the training and the test sets to create one data set.
4. Extract the measurements on the mean and standard deviation for each measurement.
5. Adds descriptive activity names for the activities in the data set
6. Labels the data set with descriptive variable names.
7. Find the average for each feature grouped by subjectid and activity
8. Write the final independent tidy data set 

## All of my code is in the run_analysis.R
My code uses three packages beyond the base R : magrittr, plyr, dplyr

I include code to load the packages, but the packages must be installed prior to running my
script.

### 1. Download and unzip data set
I downloaded the zip folder using the url and the download.file()
```
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "UCI HAR Dataset.zip", method = "curl", mode = "wb")
```
I then unzipped the datasset into the working directory
```
unzip(zipfile = "./UCI HAR Dataset.zip")
```
The rest of my script assumes that the data files have been unzipped into the working directory 
under the folder name "UCI HAR Dataset" that we downloaded the folder under

### 2. Read in and build up test and train datasets to have complete observations
# Now we will read in and build up two separate data sets: test and train
# Read in the column labels for the data
To read in and compile the test data into a single dataframe I read in features.txt, X_test.txt,
Y_test, and subject_test.txt using read.table() with the default arguments. I used colnames() to
assign the second column of the feature_labels as the variable names for x_test. I set "activity"
as the variable name for the y_test column, and "subjectid" as the variable name for the
subject_test column. I then used cbind() to bind together subject_test, y_test and x_test in that
order
```
feature_labels <- read.table("./UCI HAR Dataset/features.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(x_test) <- feature_labels[ ,2]
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
colnames(y_test) <- c("activity")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- c("subjectid")
test_data <- cbind(subject_test, y_test, x_test)
```
I followed the same steps to read in and compile the train_data

### 3. Merges the training and the test sets to create one data set.
I used rbind to combine test_data and train_data into a single narrow data set
```
merged_data <- rbind(test_data, train_data)
```

### 4. Extract the measurements on the mean and standard deviation for each measurement.
I decided to interpret this instruction as ONLY wanting to look at the columns that were created 
by the mean() and std() functions. To do that I used grep() and regular expressions to first pull
all the columns including the literals "mean" or "std" and then narrowing further to disclude the
columns including "Freq".
```
m_std <- c(1, 2, grep("mean|std", names(merged_data))) # 1 and 2 for subjectid and activity
sub_merged <- merged_data[ ,m_std]
# Remove the columns for meanFreq
freq <- grepl("Freq", names(sub_merged))
sub_merged <- sub_merged[ , !freq]
```

### 5. Adds descriptive activity names for the activities in the data set
I used the labels provided in activity_labels.txt to rename the factor levels of the activity
variable. I did this by using read.table() to read in the data and coercing the columns into 
character objects. Before renaming the factors I tidied the activity labels further by making
them all lowercase and removing the underscores.I used mapvalues() from the plyr package to
rename the  factor levels to the tidied descriptive names. To do this I had to coerce the
existing activity variable as a factor.
```
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
frm <- as.character(activity_labels$V1)
to <- as.character(activity_labels$V2)
to <- tolower(to) # made activities lowercase
to <- sub("_", "", to) # removed underscores
sub_merged$activity <- mapvalues(as.factor(sub_merged$activity), frm, to)
```
### 6. Labels the data set with descriptive variable names.
I stored the names of the subset merged data set as a character vector so I would not be directly
manipulating the dataframe with each edit to the variable names. To clean the variable names up
and make them more descriptive I removed the parentheses and dashes. I decided to leave upper
case letters to make the names more readable. I used sub and gsub to do this and also to replace
"t", "f", and "Acc" with "time", "frequency", and "Acceleration". I then replaced the colnames of
sub_merged with the edited character vector.

```
variables <- names(sub_merged)
# remove "()", remove "-", lengthen "t", "f", and "Acc"
variables %<>% sub("\\()", "", x = .) %<>% 
          gsub("-", "", x = .) %<>%
          sub("^t", "time", x = .) %<>%
          sub("^f", "frequency", x = .) %<>%
          sub("Acc", "Acceleration", x = .)
colnames(sub_merged) <- variables
```
### 7. Find the average for each feature grouped by subjectid and activity
I used the dplyr package to coerce submerged to a tibble object. I then group_by() subjectid and activity. I finally used summarise_all() to calculate the average of each column of the grouped data using mean() and assigned the results to tidy_data.

```
sub_tbl <- as_tibble(sub_merged)
grouped_data <- sub_tbl %>% group_by(subjectid, activity) 
tidy_data <- grouped_data %>% summarise_all(mean, na.rm = TRUE)
```
This tidy_data is our final output of a tidy independent data set.

### 8. Write the final independent tidy data set 
To export the tidy_data I used write.table() with the default arguments.
```
write.table(tidy_data, file = "./Tidy_Data_Set.txt")
```
This data can then be read back into R using the read.table() with the default arguments.
```
tidy_data <- read.table("Tidy_Data_Set.txt")
```


