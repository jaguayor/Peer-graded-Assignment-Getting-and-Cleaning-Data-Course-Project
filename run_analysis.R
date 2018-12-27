# Peer-graded Assignment: Getting and Cleaning Data Course Project
#

#The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
  
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Here are the data for the project:
  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#You should create one R script called run_analysis.R that does the following.

#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.

#Loading required packages

library(dplyr)

#Download the dataset

filename <- "GettingCleaningData_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  
###############################################################
# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
###############################################################
#Assigning all data frames

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


#creating  R script called run_analysis.R that does the following:

#Step 1: Merges the training and the test sets to create one data set.

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)


#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))


#Step 3: Uses descriptive activity names to name the activities in the data set.

TidyData$code <- activities[TidyData$code, 2]


#Step 4: Appropriately labels the data set with descriptive variable names.

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


#Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)


#Final Check Stage

#Checking variable names

str(FinalData)
#Classes ‘grouped_df’, ‘tbl_df’, ‘tbl’ and 'data.frame': 180 obs. of  88 variables:
#  $ subject                                           : int  1 1 1 1 1 1 2 2 2 2 ...
#$ activity                                          : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
#$ TimeBodyAccelerometer.mean...X                    : num  0.222 0.261 0.279 0.277 0.289 ...
#$ TimeBodyAccelerometer.mean...Y                    : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
#$ TimeBodyAccelerometer.mean...Z                    : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
#$ TimeGravityAccelerometer.mean...X                 : num  -0.249 0.832 0.943 0.935 0.932 ...
#$ TimeGravityAccelerometer.mean...Y                 : num  0.706 0.204 -0.273 -0.282 -0.267 ...
#$ TimeGravityAccelerometer.mean...Z                 : num  0.4458 0.332 0.0135 -0.0681 -0.0621 ...
#$ TimeBodyAccelerometerJerk.mean...X                : num  0.0811 0.0775 0.0754 0.074 0.0542 ...
#$ TimeBodyAccelerometerJerk.mean...Y                : num  0.003838 -0.000619 0.007976 0.028272 0.02965 ...


#Take a look at final data

FinalData
# That was fun! Thank you for the course!