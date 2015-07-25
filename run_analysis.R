library(plyr)
library(dplyr)
library(reshape2)

##Getting and saving wd
wd <- getwd()

##Unzipping the data
unzip("getdata_projectfiles_UCI HAR Dataset.zip")

##Setting working directory to be UCI HAR Dataset
setwd("UCI HAR Dataset")

##Defining paths for data files
pActivityLabels <- "activity_labels.txt"
pFeatures <- "features.txt"
pTestSubject <- "test/subject_test.txt"
pTestX <- "test/X_test.txt"
pTestY <- "test/y_test.txt"
pTrainSubject <- "train/subject_train.txt"
pTrainX <- "train/X_train.txt"
pTrainY <- "train/y_train.txt"

##Reading Activity Set
activities <- read.table(pActivityLabels, header = FALSE, col.names = c("id", "activity_name"))

##Reading Features Set
features <- read.table(pFeatures, header = FALSE, 
                     col.names = c("id", "feature_name"), colClasses = c("integer", "character"))

##grepl("mean\\(\\)|std\\(\\)", features$feature_name) will provide filtering of features data frame to get all mean and std
features <- filter(features, grepl("mean\\(\\)|std\\(\\)", features$feature_name))

##Preparing vectors for column classes to read X data
xColClasses <- rep("NULL", 561)
xColClasses[as.vector(features$id)] <- "numeric"

xColNames <- rep("NULL", 561)
xColNames[as.vector(features$id)] <- as.vector(features$feature_name)

##CLEANING AND PREPARING TEST DATA##

##Reading test data into memory and subsetting
testX <- read.table(pTestX, header = FALSE, colClasses = xColClasses, col.names = xColNames, check.names = FALSE)
testY <- read.table(pTestY, header = FALSE, col.names = c("activity_id"))
testY$id <- 1:nrow(testY)
testY <- merge(testY, activities, by.x = "activity_id", by.y = "id")
testY <- testY[order(testY$id),]
testSubjects <- read.table(pTestSubject, header = FALSE, col.names = c("subject"))

##cbinding test data
testData <- cbind(testSubjects$subject, testY$activity_name, testX)
##Couldn't debug why dplyr rename wasn't working.
testData <- plyr::rename(testData, c("testSubjects$subject" = "subject", "testY$activity_name" = "activity"))

##CLEANING AND PREPARING TRAINING DATA##

##Reading train data into memory and subsetting
trainX <- read.table(pTrainX, header = FALSE, colClasses = xColClasses, col.names = xColNames, check.names = FALSE)
trainY <- read.table(pTrainY, header = FALSE, col.names = c("activity_id"))
trainY$id <- 1:nrow(trainY)
trainY <- merge(trainY, activities, by.x = "activity_id", by.y = "id")
trainY <- trainY[order(trainY$id),]
trainSubjects <- read.table(pTrainSubject, header = FALSE, col.names = c("subject"))

##cbinding test data
trainData <- cbind(trainSubjects$subject, trainY$activity_name, trainX)
trainData <- plyr::rename(trainData, c("trainSubjects$subject" = "subject", "trainY$activity_name" = "activity"))

##GLOMMING test data and train data
finalData <- rbind(trainData, testData)

##Changing column names to make them more readable
colnames(finalData) <- gsub("-mean\\(\\)-|-mean\\(\\)", "Mean",names(finalData))
colnames(finalData) <- gsub("-std\\(\\)-|-std\\(\\)", "StdDev",names(finalData))
features$feature_name <- names(finalData[3:length(names(finalData))])

########################################################################################################################

##Creating final tidy set
m <- melt(finalData, id = c("subject", "activity"), measure.vars=as.vector(features$feature_name))
tidyData <- dcast(m, subject + activity ~ variable, mean)

##Writing to original working directory
setwd(wd)
write.table(tidyData, file="tidyData.txt", row.names = FALSE)
