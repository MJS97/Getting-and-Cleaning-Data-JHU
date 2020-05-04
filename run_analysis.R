# We will be using these packages, please install using install.packages()
# if these packages have not been installed on your machine before loading.

library(magrittr)
library(plyr)
library(dplyr)

# I include my code for downloading (ln 11-19) and reading in the data (ln 21 - 43) but feel 
# free to skip to line 46 if you only want to see the discrete steps for run_analysis

# The script assumes you have the files from the zip extracted and available in a 
# subdirectory of your working directory called "UCI HAR Dataset"

# If not please uncomment and download + extract the zip first with lines 16, 17, and 19
# download the zip with the data sets
#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url, destfile = "UCI HAR Dataset.zip", method = "curl", mode = "wb")
# Extract all files from the zipped file directory to folder that will be made if necessary
#unzip(zipfile = "./UCI HAR Dataset.zip")

# Now we will read in and build up two separate data sets: test and train
# Read in the column labels for the data
feature_labels <- read.table("./UCI HAR Dataset/features.txt")
# Reading in and labeling the test data 
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(x_test) <- feature_labels[ ,2]
# Reading in and labeling the activity column
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
colnames(y_test) <- c("activity")
# Reading in and labeling the subject ID column
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- c("subjectid")
# Binding the columns together
test_data <- cbind(subject_test, y_test, x_test)
# Now the same for the training data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(x_train) <- feature_labels[ ,2]
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
colnames(y_train) <- c("activity")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- c("subjectid")
# Binding the columns together
train_data <- cbind(subject_train, y_train, x_train)


# Now onto the data analysis:

# 1. Merges the training and the test sets to create one data set.
merged_data <- rbind(test_data, train_data)
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Use regular expression to find column names w/ "mean" or "std"
m_std <- c(1, 2, grep("mean|std", names(merged_data))) # 1 and 2 for subjectid and activity
sub_merged <- merged_data[ ,m_std]
# Remove the columns for meanFreq
freq <- grepl("Freq", names(sub_merged))
sub_merged <- sub_merged[ , !freq]
# 3. Uses descriptive activity names to name the activities in the data set
# Rename the factor levels to be the names in the activity label file
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
frm <- as.character(activity_labels$V1)
to <- as.character(activity_labels$V2)
to <- tolower(to) # made activities lowercase
to <- sub("_", "", to) # removed underscores
# currently activity is numeric variable so we need to treat it as a factor
sub_merged$activity <- mapvalues(as.factor(sub_merged$activity), frm, to)
# 4. Appropriately labels the data set with descriptive variable names
# pull out the variable names from the merged data set
variables <- names(sub_merged)
# remove "()", remove "-", lengthen "t", "f", and "Acc"
variables %<>% sub("\\()", "", x = .) %<>% 
          gsub("-", "", x = .) %<>%
          sub("^t", "time", x = .) %<>%
          sub("^f", "frequency", x = .) %<>%
          sub("Acc", "Acceleration", x = .)
# pass vars back in as the column names for sub_merged
colnames(sub_merged) <- variables
# 5. From the data set in step 4, creates a second, independent 
#    tidy data set with the average of each variable for each 
#    activity and each subject.
sub_tbl <- as_tibble(sub_merged)
grouped_data <- sub_tbl %>% group_by(subjectid, activity) 
tidy_data <- grouped_data %>% summarise_all(mean, na.rm = TRUE)
tidy_data
# tidy_data is our final output : a tidy independent data set with the 
# average for each mean() and std() variable grouped by subject and activity

# If you would like to export the tidy_data, you can uncomment and run the following code
# write.table(tidy_data, file = "./Tidy_Data_Set.txt")
# This data can then be read back into R using the following code line
# tidy_data <- read.table("Tidy_Data_Set.txt")

### Thank you 

