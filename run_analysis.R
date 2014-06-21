

run_analysis <- function() {

## This function takes no arguments, but applies the
## anaylsis and processing steps necessary to transform the 
## raw UCI HAR Dataset into a tidy data set for future work

## This assumes that the required dataset has been loaded in the
##  current working directory as "UCI HAR Dataset" and subdirectories
##  exactly as provided by the zip file:
##  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## We are going to need the reshape librabry, so load it now
library(reshape)

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
activity_key <- read.table("UCI HAR Dataset/activity_labels.txt",
		row.names=NULL, header=FALSE)
print(activity_key)

activity_text <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
	"SITTING","STANDING","LAYING")


##  Load the features key
message("Loading the features key...")
features_key <- read.table("UCI HAR Dataset/features.txt",
		row.names=NULL, header=FALSE)
write(as.vector(features_key$V2),file="Features_Key.txt")


##  Load the subject list
message("Loading the subject lists...")
testsub <- read.table("UCI HAR Dataset/test/subject_test.txt",
		row.names=NULL, header=FALSE)
trainsub <- read.table("UCI HAR Dataset/train/subject_train.txt",
		row.names=NULL, header=FALSE)

##  Load the activity lists
message("Loading the activity lists...")
testactivity <- read.table("UCI HAR Dataset/test/y_test.txt",
		row.names=NULL, header=FALSE)
trainactivity <- read.table("UCI HAR Dataset/train/y_train.txt",
		row.names=NULL, header=FALSE)

## Process the variable names into more readable formats
qqq <- "("
message("vnames1")
vnames1 <- features_key$V2
print(vnames1)
vnames2 <- gsub("()","",vnames1,fixed=TRUE)
vnames3 <- gsub(qqq,"_of_",vnames2,fixed=TRUE)
vnames4 <- gsub("yro-","yro_",vnames3,fixed=TRUE)
vnames5 <- gsub("ag-","ag_",vnames4,fixed=TRUE)
vnames6 <- gsub("cc-","cc_",vnames5,fixed=TRUE)
vnames7 <- gsub("erk-","erk_",vnames6,fixed=TRUE)
vnames8 <- gsub(",","_",vnames7,fixed=TRUE)
vnames9 <- gsub(")","",vnames8,fixed=TRUE)
cleanednames <- vnames9
write(cleanednames, file="Features_cleannames.txt")


##  Load the activity data
message("Loading the activity data...")
testdata <- read.table("UCI HAR Dataset/test/X_test.txt",
		header=FALSE,row.names=NULL)
traindata <- read.table("UCI HAR Dataset/train/X_train.txt",
		header=FALSE,row.names=NULL)

# not needed due to rbind issue
## set the rownames in the train and test datasets
# tempvec <- paste("train_",rownames(traindata), sep ="")
# rownames(traindata) <- tempvec
# tempvec <- paste("test_",rownames(testdata), sep ="")
# rownames(testdata) <- tempvec

##  Combine the test and train datasets into a single combined dataset
# fulldata <- rbind(traindata,testdata)
## working around an unexpected issue with rbind
message("convert formats to work around rbind issue")
trainmatrix <- as.matrix(traindata)
testmatrix <- as.matrix(testdata)
message("rbind start")
fullmatrix <- rbind(traindata,testdata)
message("convert to data.frame")
fulldata <- data.frame(fullmatrix,row.names=NULL)
message("fulldata created")

##  Add the cleaned column names
colnames(fulldata) <- cleanednames

##  Now we find which variables are the means and std dev
v1 <- grepl("mean",cleanednames,fixed=TRUE)
v2 <- grepl("std",cleanednames,fixed=TRUE)
v3 <- grepl("Mean",cleanednames,fixed=TRUE)
vselect <- v1 | v2 | v3

##  select only the columns of means and std dev
selectdata <- fulldata[,vselect]
message("selected data only for further processing")
summary(selectdata)
whichcols <- colnames(selectdata)
write(whichcols,file="Features_Selected.txt")


##  Add the subject and activity codes to the datasets loaded
message("add subject ID to dataset")
selectdata$subject <- c((trainsub$V1),(testsub$V1))
print("trainsub")
print(trainsub)
print("selectdata$subject")
print(selectdata$subject)
# selectdata$subject <- rbind(trainsub,testsub)
message("add activity key to dataset")
activity_vector <- as.vector(rbind(trainactivity, testactivity))
# print(activity_vector)
# summary(activity_vector)
# stop("look at subject data")

##  Add descriptive activity names
# selectdata$activity <- c(trainactivity$V1,testactivity$V1)
selectdata$activity <- factor(selectdata$activity, levels=c(1,2,3,4,5,6), labels=activity_key$V1)

message("assembly complete")
# str(traindata)
# str(testdata)
# str(selectdata)
# summary(selectdata)

write.table(selectdata,file="Selectdata.txt",sep=",")

##  Now to make the tidy dataset
#
message("making the tidy_data:  first melt the selected data")
liquid <- melt(selectdata, id=(c("subject","activity")))
message("now recast to desired shape")
tidy_data <- cast(liquid, activity + subject ~ variable , mean)
print("tidy_data has been recast")
write.table(tidy_data,file="tidy_data.txt", sep="	")
message("writing tidy_data complete")

message("recast complete - see tidy_data.txt for results")


tidy_data
}



