##Introduction

This repository contains the script for cleaning up data for downstream data analysis. The 
raw data is obtained as a zip file downloaded from the path:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The repository contains the following files:

1. run_analysis.R - R script for cleaning the raw data. The output of this script will be tidyData.txt.
2. cook_book.pdf - pdf file explaining the variables in the final data file - tidyData.txt.
3. README.md - This file explains the algorithm used, and assumptions made for the script to work.

##Requirements

The script:

1. Merges the training and the test sets present in the zipped archive to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Input and Output

### Input

The input to the script is the zip file obtained from the link provided in the Introduction section.

__Note__: This zip file should be downloaded and saved in the working directory before running the script.

### Output

After the script finishes running, it saves tidyData.txt file in the working directory. This file contains the final tidy data set which is mentioned at line 5 of the Requirements.  

##Dependencies

The script depends on the following R packages, which should be installed before running the script:

1. plyr
2. dplyr
3. reshape2

##Algorithm

The run_analysis.R script performs the following steps:

* Unzips the archive into the working directory and sets the 'UCI HAR Dataset' directory as the new working directory.
* Defines the following variables for storing paths for the files which will be read from this directory (The paths are relative to the 'UCI HAR Dataset' directory) :

```
    pActivityLabels <- "activity_labels.txt"
    pFeatures <- "features.txt"
    pTestSubject <- "test/subject_test.txt"
    pTestX <- "test/X_test.txt"
    pTestY <- "test/y_test.txt"
    pTrainSubject <- "train/subject_train.txt"
    pTrainX <- "train/X_train.txt"
    pTrainY <- "train/y_train.txt"
```
* Processes various labels associated with the data set. It reads activity labels from activity_labels.txt and feature labels from "features.txt". It creates the xColClasses and xColNames from these to extract the required columns from the dataset while reading it.
* Reads in test data and training data and performs the following operations on both:
    1. Reads the subseted X data - testX, trainX
    2. Reads the Y data and merges with activity vector to get the corressponding activities as factor - testY, trainY.
    3. Reads the subjects data and stores it in another data frame- testSubjects, trainSubjects.
    4. cbinds the data from each of 1,2,3 into a single dataframe - testData, trainData.
    5. Cleans up labels for the datasets obtained in 4.
    6. Row binds the testData and trainData into finalData.
* Renames the measurement variables to make them more readable. This completes the first 4 requirements mentioned in the Requirements section.
* To get the final tidy dataset, performs the following operations to the finalData data frame:
    1. Melts all the measurement variables.
    2. dCasts the tall and skinny data frame obtained in previous step with subject and activity to obtain the final tidyData data frame.
* Changes the working directory back to the original working directory and writes the tidyData dataframe into tidyData.txt file.