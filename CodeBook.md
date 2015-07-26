### Introduction

This file describes the data, the variables, and the work that has been performed by run_analysis.R to clean up the data and produced the require results.

#### Download and unzip the data respository

If the zip file "UCI HAR Dataset.zip" does not already exist in the working directory it is downloaded from the url provided on the Course Project page.

If the data directory "UCI HAR Dataset" does not exist in the working directory "UCI HAR Dataset.zip" is unzipped.

```
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
```

`read.table` is used to load the data to R environment for both the test and training data.  Both the test data tables and training data tables are checked to make sure they contain the same number of rows.

```
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
```

#### Merge test and training sets into one data set, including the subjects and activities

The `Subject` and  `Activity` columns are appended to the test and train data frames, and then are both merged in the `allData` data frame.

```
### d. Merge data
testData <- cbind(testData_sub,testData_act,testData)
trainData <- cbind(trainData_sub,trainData_act,trainData)
allData <- rbind(trainData,testData)
```

#### Extract only the measurements on the mean and standard deviation for each measurement

`mean()` and `sd()` are applied to `allData` via `sapply()` to extract the requested measurements.

```
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
allData_sd<-sapply(allData,sd,na.rm=TRUE)
View(allData_sd)
allData_mean<-sapply(allData,mean,na.rm=TRUE)
View(allData_mean)
```

#### Appropriately label the data set with descriptive variable names. 

Each data frame of the data set is labeled - using the `features.txt` - with the information about the variables used on the feature vector. The `Activity` and `Subject` columns are also named properly.

```
# 4. Appropriately label the data set with descriptive variable names. 
features <- read.table("features.txt",colClasses = "character")

names(allData)=c("Subject","Activity",features$V2)

rm(features)
```

#### Uses descriptive activity names to name the activities in the data set

The class labels linked with their activity names are loaded from the `activity_labels.txt` file. The numbers of the 
`allData` data frame is replaced by those names:

```
# 3. Uses descriptive activity names to name the activities in the data setactivities <- read.table("activity_labels.txt",colClasses = "character")

allData$Activity <- factor(allData$Activity,labels = activities$V2)

rm(activities)
```

#### Creates a second, independent tidy data set with the average of each variable for each subject and activity.

The data.table library is loaded and used to create a `tidy` data table with the average of each measurement per subject/activity combination. The new dataset is saved in `tidyData.csv` file.

```
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

setwd("..")

library(data.table)

DT <- data.table(allData)

tidyData<-DT[,lapply(.SD,mean),by="Activity,Subject"]
View(tidyData)
write.table(tidyData,file="tidyData.csv",sep=",",row.names = FALSE)

rm(DT)
```

### All data loaded removed from R

```
# Remove all initial and intermidiate data from

rm(allData)

rm(trainData_sub)
rm(trainData_act)
rm(trainData)

rm(testData_sub)
rm(testData_act)
rm(testData)
```
