
#1. Merges the training and the test sets to create one data set.

### a. Download zip file containing data (if file doesn't already exist in currect working directory)
if (!file.exists("UCI HAR Dataset.zip")) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

  download.file(url, "UCI HAR Dataset.zip")
  
  rm(url)
} 

### b. Unzip zip file containing data (if directory doesn't already exist in currect working directory)
if (!file.exists("UCI HAR Dataset")) {
  unzip("UCI HAR Dataset.zip")  
} 
setwd("UCI HAR Dataset")

### c. Load test and training data
testData <- read.table("test/X_test.txt")
testData_act <- read.table("test/y_test.txt")
testData_sub <- read.table("test/subject_test.txt")
if ( nrow(testData_act) != nrow(testData) || nrow(testData_sub) != nrow(testData) ) {
  stop('lengths of test data files do not match')
}

trainData <- read.table("train/X_train.txt")
trainData_act <- read.table("train/y_train.txt")
trainData_sub <- read.table("train/subject_train.txt")
if ( nrow(trainData_act) != nrow(trainData) || nrow(trainData_sub) != nrow(trainData) ) {
  stop('lengths of training data files do not match')
}

### d. Merge data
testData <- cbind(testData_sub,testData_act,testData)
trainData <- cbind(trainData_sub,trainData_act,trainData)
allData <- rbind(trainData,testData)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

allData_sd<-sapply(allData,sd,na.rm=TRUE)
View(allData_sd)
allData_mean<-sapply(allData,mean,na.rm=TRUE)
View(allData_mean)

# 4. Appropriately label the data set with descriptive variable names. 
features <- read.table("features.txt",colClasses = "character")

names(allData)=c("Subject","Activity",features$V2)

rm(features)

# 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt",colClasses = "character")

allData$Activity <- factor(allData$Activity,labels = activities$V2)

rm(activities)

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

setwd("..")

library(data.table)

DT <- data.table(allData)

tidyData<-DT[,lapply(.SD,mean),by="Activity,Subject"]
View(tidyData)
write.table(tidyData,file="tidyData.csv",sep=",",row.names = FALSE)

rm(DT)

# Remove loaded data and reset working directory

rm(allData)

rm(trainData_sub)
rm(trainData_act)
rm(trainData)

rm(testData_sub)
rm(testData_act)
rm(testData)
