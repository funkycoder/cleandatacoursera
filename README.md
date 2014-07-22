------------------------------------------------------------------
Human Activity Recognition Using Smartphones Dataset
Description:
Tidy dataset for Coursera Getting and Cleaning Data 2014
In this dataset I use only part of the original dataset:
------------------------------------------------------------------
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, I captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
-------------------------------------------------------------------------------------------------
- The corresponding mean / average of each subject in the study by each activity




The tidy dataset includes the following files:
-------------------------------------------------------------------------------------------------
- 'README.md' This file

- 'CodeBook.md' describes the variables, the data, and any transformations or work that I performed to clean up the data

- 'cleandata.csv' The clean dataset itself

--------------------------------------------------------------------------------------------------
How the script works line by line
--------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------
#                   TRAIN DATASET
#             (7352 obs of 561 variables)
#-----------------------------------------------------------------------------------------------
#Read train dataset
train <- read.table("./train/X_train.txt")
#Get train labels
train.labels <- read.table("./train/y_train.txt")
#-----------------------------------------------------------------------------------------------
#                   TEST DATASET
#             (2947 obs of 561 variables)
#-----------------------------------------------------------------------------------------------
#Read test dataset
test <- read.table("./test/X_test.txt")
#Get test labels
test.labels <- read.table("./test/y_test.txt")
#-----------------------------------------------------------------------------------------------
#                  1. MERGE TRAIN AND TEST DATASET
#             (10299 obs of  561 variables)
#-----------------------------------------------------------------------------------------------
data.full <- rbind(train,test)
#-----------------------------------------------------------------------------------------------
#               2. Extracts only the measurements on the mean and standard deviation 
#-----------------------------------------------------------------------------------------------
#Get features name
features <- read.table("features.txt")
#Logical vector to get only features that have the characters "Mean, mean or std"
good<- grepl("[Mm]ean|std",features$V2)
#Extract the corresponding features
features.extracted <- features[good,]
#Get data subset with corresponding variables name stored in the first element of the features.extracted data frame
data <- subset(data.full,select- features.extracted[[1]])

#-----------------------------------------------------------------------------------------------
#              3. Uses descriptive activity names to name the activities in the data set 
#-----------------------------------------------------------------------------------------------
#Merge code labels from train and test dataset to have the full dataset. Remember that it contains only numbers
labels <- rbind(train.labels,test.labels)
#Get the labels as vector
mylabels<- labels[,1]

#Now get activity label. Dont convert to factor
labels.activity <- read.table("activity_labels.txt",as.is-TRUE)

#Convert labels to factors
mylabels<- factor(mylabels,levels-c(1,2,3,4,5,6),labels-labels.activity$V2)
#Now bind the activity labels column to the dataset. Now I have descriptive activity names 
# to name the activities in the data set
data <- cbind(data,mylabels)
#-----------------------------------------------------------------------------------------------
#              4. Appropriately labels the data set with descriptive variable names 
#-----------------------------------------------------------------------------------------------
#Get the column names in features.extracted$V2 then add them to the data columns names
#Last column is "activity" which were added in step 3
colnames(data)<- c(as.character(features.extracted$V2),"activity")
#Now display the data to see if every requirements met:
head(data)
#-----------------------------------------------------------------------------------------------
#              5. Creates a second, independent tidy data set with the average of 
#                       each variable for each activity and each subject. 
#-----------------------------------------------------------------------------------------------
# Get train subjects
train.subjects <- read.table("./train/subject_train.txt")
# Get test subjects
test.subjects <-  read.table("./test/subject_test.txt")
# Subjects of the whole dataset
subjects <- rbind(train.subjects,test.subjects)
# Merge subjects to data
data <- cbind(subjects,data)
# Name the first column to subjects
colnames(data)[1]<- "subjects"
#Creates a  data set with the average of each variable for each activity and each subject. 
aggdata<- aggregate(data,by-list(Group.subjects-data$subjects,Group.activity-data$activity),FUN-mean,na.rm-TRUE)
#Remember that aggdata have variables that keep the same values: Group.subjects - subjects,
# Group.activity- activity <- Violation to the tidy dataset concept
#Remove those two variable from the dataframe
drops<- c("subjects","activity")
df <- aggdata[,!(names(aggdata) %in% drops)]
#Now write the tidy dataset to a csv file!
write.csv(file-"cleandata.csv",x-df)
# DONE! Thank you for following !
