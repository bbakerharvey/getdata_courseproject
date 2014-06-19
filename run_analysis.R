

run_analysis <- function() {

## This function takes no arguments, but applies the
## anaylsis and processing steps necessary to transform the 
## raw UCI HAR Dataset into a tidy data set for future work

## This assumes that the required dataset has been loaded in the
##  current working directory as "UCI HAR Dataset" and subdirectories
##  exactly as provided by the zip file:
##  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


##  First insure that the expected raw dataset is present

if (!file.exists("UCI HAR Dataset")) {
	stop("Required dataset (UCI HAR Dataset) not found in working directory")
	}

if (!file.exists("UCI HAR Dataset/test")) {
	stop("Required dataset (UCI HAR Dataset/test) not found in working directory")
	}

if (!file.exists("UCI HAR Dataset/train")) {
	stop("Required dataset (UCI HAR Dataset/train) not found in working directory")
	}

message("data set found OKAY")


##  Load the activity key
message("Loading the activity key...")
activity_key <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE)
print(activity_key)


##  Load the features key
message("Loading the features key...")
features_key <- read.table("UCI HAR Dataset/features.txt",header=FALSE)
print(features_key)


##  Load the subject list
message("Loading the subject lists...")
testsub <- read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)
trainsub <- read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE)

##  Load the activity lists
message("Loading the activity lists...")
testactivity <- read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE)
trainactivity <- read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE)

##  Load the activity data
message("Loading the activity data...")
testdata <- read.table("UCI HAR Dataset/test/X_test.txt",
		header=FALSE,row.names=NULL)
traindata <- read.table("UCI HAR Dataset/train/X_train.txt",
		header=FALSE,row.names=NULL)

##  Add the subject and activity codes to the datasets loaded
testdata$subject <- testsub
traindata$subject <- trainsub
testdata$activity <- testactivity
traindata$activity <- trainactivity


##  Combine the test and train datasets into a single combined dataset
fulldata <- rbind(traindata,testdata)
str(traindata)
str(testdata)
str(fulldata)


}



