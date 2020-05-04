---
title: "Codebook G&C Course Project"
author: "Megan Siemann"
date: "5/1/2020"
output: pdf_document
---

## Project Description
Completed for the Data Science Specialization - Getting and  Cleaning Data Course offered by John
Hopkins University on Coursera. Working with a dataset from the UCI Machine Learning Repository we
aim to produce a tidy independent data set that has subset and analyzed the original dataset.

##Study design and data processing

###Collection of the raw data
This section is heavily sourced from the features_info file within the dataset.

The original dataset is body movement measurements estimated from 30 subjects wearing a
smartphone. The subjects were observed while they completed 6 different types of
activity. The smartphone data collected two types of raw data : triaxial acceleration
from the phones accelerometer and triaxial angular velocity from the phones
gyroscope.The data from the 30 subjects were plit into a training and a test dataset.For
the data we are using - the raw data had already been processed using Fast Fourier
Transform to result in acceleration over frequency measurements in addition to the
accelation over time measurements for the following 17 variables:

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

For each of the above variables the following measures were calculated:

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.
  and for some of those variables:
gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

Resulting in a Subject ID, Activity, and 561 variables for each observation.


###Notes on the original (raw) data 
For more detailed information I recommend looking at the source website at
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones or
looking at the files available within the downloaded dataset
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.


##Creating the tidy datafile

###Guide to create the tidy data file
All of the following steps were carried out in a single script: run_analysis.R
To create the tidy data file I did the following:
1. Downloaded the zipped directory with the data
2. Extracted all of the files in a subdirectory 'UCI HAR Dataset' of my working directory
3. Read in and bound together the data observations to have two complete datasets:
      "test_data" and "train_data"
      * Labels were added manually for the subjectID (ex. subject_test) and activity (ex. y_test)
      * features.txt were used as the labels for X_test and X_train 
      * The observations were pieced together so that subject_test + y_test + X_test formed
        a complete observation in "test_data". The same was done for the "train_data"

Using these two sata sets, I then followed the 5 steps outlined for run_analysis:
1. Merges the training and the test sets to create one data set.
   + The two data sets were combined vertically using rbind to create a narrow dataset 
2. Extracts only the measurements on the mean and standard deviation for each measurement.
   + I considered this to be only the variables that were formed using mean() and std()
   + I disregarded the meanFreq and ...Mean variables
3. Uses descriptive activity names to name the activities in the data set
   + I used the activity_labels.txt files to read in and then rename the factor levels in the 
     in the merged data set
4. Appropriately labels the data set with descriptive variable names.
   + I decided to use capital letters to denote words beginning 
   + I elaborated the words "t", "f", and "Acc" to make the labels more descriptive
5. From the data set in step 4, creates a second, independent tidy data set with the average of 
   each variable for each activity and each subject.
   + I grouped by subjectid and activity then calculated the mean() for each variable
   
###Cleaning of the data
Labels were added for the subjectID (ex. subject_test) and activity (ex. y_test), features.txt were
used as the labels for X_test and X_train, subject_test + y_test + X_test were bound together, the same was done for the "train_data", test_data and train-data were merged, data was subset to include only columns including "mean" or "std", removed the columns that included "Freq", renamed the factor levels for activity variable, made feature names more descriptive by replacing t with "time" and f with "frequency", replaced "Acc" with "Acceleration", removed dashes and parentheses, grouped by subjectid and activity [Find more detail in the README.md]

##Description of the variables in the tidy_data.txt file
 - Dimensions: 180 obs. of 68 variables
 - means of each variable grouped by subjectid and activity
 - Variables 3-68 are numeric and are in standard gravity units
 - Variables present in the dataset

 [1] "subjectid"                                "activity"                                
 [3] "timeBodyAccelerationmeanX"                "timeBodyAccelerationmeanY"               
 [5] "timeBodyAccelerationmeanZ"                "timeBodyAccelerationstdX"                
 [7] "timeBodyAccelerationstdY"                 "timeBodyAccelerationstdZ"                
 [9] "timeGravityAccelerationmeanX"             "timeGravityAccelerationmeanY"            
[11] "timeGravityAccelerationmeanZ"             "timeGravityAccelerationstdX"             
[13] "timeGravityAccelerationstdY"              "timeGravityAccelerationstdZ"             
[15] "timeBodyAccelerationJerkmeanX"            "timeBodyAccelerationJerkmeanY"           
[17] "timeBodyAccelerationJerkmeanZ"            "timeBodyAccelerationJerkstdX"            
[19] "timeBodyAccelerationJerkstdY"             "timeBodyAccelerationJerkstdZ"            
[21] "timeBodyGyromeanX"                        "timeBodyGyromeanY"                       
[23] "timeBodyGyromeanZ"                        "timeBodyGyrostdX"                        
[25] "timeBodyGyrostdY"                         "timeBodyGyrostdZ"                        
[27] "timeBodyGyroJerkmeanX"                    "timeBodyGyroJerkmeanY"                   
[29] "timeBodyGyroJerkmeanZ"                    "timeBodyGyroJerkstdX"                    
[31] "timeBodyGyroJerkstdY"                     "timeBodyGyroJerkstdZ"                    
[33] "timeBodyAccelerationMagmean"              "timeBodyAccelerationMagstd"              
[35] "timeGravityAccelerationMagmean"           "timeGravityAccelerationMagstd"           
[37] "timeBodyAccelerationJerkMagmean"          "timeBodyAccelerationJerkMagstd"          
[39] "timeBodyGyroMagmean"                      "timeBodyGyroMagstd"                      
[41] "timeBodyGyroJerkMagmean"                  "timeBodyGyroJerkMagstd"                  
[43] "frequencyBodyAccelerationmeanX"           "frequencyBodyAccelerationmeanY"          
[45] "frequencyBodyAccelerationmeanZ"           "frequencyBodyAccelerationstdX"           
[47] "frequencyBodyAccelerationstdY"            "frequencyBodyAccelerationstdZ"           
[49] "frequencyBodyAccelerationJerkmeanX"       "frequencyBodyAccelerationJerkmeanY"      
[51] "frequencyBodyAccelerationJerkmeanZ"       "frequencyBodyAccelerationJerkstdX"       
[53] "frequencyBodyAccelerationJerkstdY"        "frequencyBodyAccelerationJerkstdZ"       
[55] "frequencyBodyGyromeanX"                   "frequencyBodyGyromeanY"                  
[57] "frequencyBodyGyromeanZ"                   "frequencyBodyGyrostdX"                   
[59] "frequencyBodyGyrostdY"                    "frequencyBodyGyrostdZ"                   
[61] "frequencyBodyAccelerationMagmean"         "frequencyBodyAccelerationMagstd"         
[63] "frequencyBodyBodyAccelerationJerkMagmean" "frequencyBodyBodyAccelerationJerkMagstd" 
[65] "frequencyBodyBodyGyroMagmean"             "frequencyBodyBodyGyroMagstd"             
[67] "frequencyBodyBodyGyroJerkMagmean"         "frequencyBodyBodyGyroJerkMagstd" 

###Variable 1 : Activity
Unique identifier for the individual being observed
Some information on the variable including:
 - Numeric
 - 1 - 30 
 
###Variable 2 : Subjectid
Unique identifier for the individual being observed
Some information on the variable including:
 - Factor
 - Levels: walking walkingupstairs walkingdownstairs sitting standing laying

###Variable 3 - 68:
The mean of the measured and transformed variables
 - Numeric
 - Standard units of gravity (g)
Names tend to be three or four parts: (time or frequency)(Measurement)(mean or std)(XYZ)
 - Part 1 - 
      + time is a more raw variable, frequency variables are the product of the FFT 
 - Part 2 -
      + "Body" indicates the variable is sourced from the accelerometer
      + "Gyro" indicates the variable is sourced from the gyroscope
      + "Mag" stands for Magnitude
      + "Jerk" has been calculted
 - Part 3 -
      + mean indicates the variable was calculated by mean()
      + std indicates the  variable was calculated by std()
 - Part 4 -
      + XYZ indicates direction of movement within 3D field

####Notes on Variables 3 - 68
- Features are normalized and bounded within [-1,1].

##Sources
Sources you used if any, otherise leave out.

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human
Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine.
International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the
authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

