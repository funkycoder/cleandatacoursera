
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
data <- subset(data.full,select= features.extracted[[1]])

#-----------------------------------------------------------------------------------------------
#              3. Uses descriptive activity names to name the activities in the data set 
#-----------------------------------------------------------------------------------------------
#Merge code labels from train and test dataset to have the full dataset. Remember that it contains only numbers
labels <- rbind(train.labels,test.labels)
#Get the labels as vector
mylabels<- labels[,1]

#Now get activity label. Dont convert to factor
labels.activity <- read.table("activity_labels.txt",as.is=TRUE)

#Convert labels to factors
mylabels<- factor(mylabels,levels=c(1,2,3,4,5,6),labels=labels.activity$V2)
#Now bind the activity labels column to the dataset. Now we have descriptive activity names 
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
aggdata<- aggregate(data,by=list(Group.subjects=data$subjects,Group.activity=data$activity),FUN=mean,na.rm=TRUE)
#Remember that aggdata have variables that keep the same values: Group.subjects = subjects,
# Group.activity= activity <- Violation to the tidy dataset concept
#Remove those two variable from the dataframe
drops<- c("subjects","activity")
df <- aggdata[,!(names(aggdata) %in% drops)]
#Now write the tidy dataset to a csv file!
write.csv(file="cleandata.csv",x=df)
# DONE! Thank you for following !