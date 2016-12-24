

# load packages required
packages <- c("data.table", "reshape2", "dplyr")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

#Download the file into the project folder

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("~/GitHub/Cousera repos/datasciencecoursera/GettingAndCleaningData/Project")) {
  dir.create("~/GitHub/Cousera repos/datasciencecoursera/GettingAndCleaningData/Project")
}

datadir <- setwd("~/GitHub/Cousera repos/datasciencecoursera/GettingAndCleaningData/Project")
f <- file.path(datadir, "Dataset.zip")
download.file(url, f)

##unzip the file
## file will be saved in "UCI HAR Dataset" folder
unzip(zipfile=f)


## set the folder to the new path and view the files
datadirA <- file.path(datadir, "UCI HAR Dataset")
list.files(datadirA, recursive = TRUE)

## read the Train and Test files
##read the Train and Test Subject Files
SubjectTrainPath <- file.path(datadirA, "train", "subject_train.txt")
SubjectTestPath <- file.path(datadirA, "test", "subject_test.txt")
dtSubjectTrain <- fread(SubjectTrainPath)
dtSubjectTest <- fread(SubjectTestPath)

## read the Train and Test set files
TrainPath <- file.path(datadirA, "train", "X_train.txt")
TestPath <- file.path(datadirA, "test", "X_test.txt")
dtTrain <- fread(TrainPath)
dtTest <- fread(TestPath)


##read the Train and Test Label/activity files
ActivityTrainPath <- file.path(datadirA, "train", "y_train.txt")
ActivityTestPath <- file.path(datadirA, "test", "y_test.txt")
dtActivityTrain <- fread(ActivityTrainPath)
dtActivityTest <- fread(ActivityTestPath)


## step1: Merging the training and the test sets to create one data set.
# Also naming the columns
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
dtSubject <- rename(dtSubject, subject = V1)

dtActivity <- rbind(dtActivityTrain, dtActivityTest)
dtActivity <- rename(dtActivity, activityID = V1)

dtSet <- rbind(dtTrain, dtTest)
##adding the feature labels
FeaturesPath <- file.path(datadirA, "features.txt")
dtFeatures <- fread(FeaturesPath)
dtFeatures<- rename(dtFeatures, featuresID = V1, features = V2)
setnames(dtSet, names(dtSet), dtFeatures$features)

##merging the subject, activity and data set
dt <- cbind(dtSubject, dtActivity, dtSet)
View(dt)

#setting the activityID and Subject column as key
setkey(dt, subject, activityID)

#Step2: Extracts only the measurements on the mean and standard deviation for each measurement.

dtFeaturesSubset <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", dtFeatures$features)]
extract <- c("subject", "activityID", dtFeaturesSubset$features)
dt <- dt[, extract, with = FALSE]


##step3: Uses descriptive activity names to name the activities in the data set.
# read the activity_labels,txt filr and merge it to the dataset
ActivityLabelPath <- file.path(datadirA, "activity_labels.txt")
dtActivityLabel <- fread(ActivityLabelPath)
dtActivityLabel<- rename(dtActivityLabel, activityID = V1, activity = V2)

dt <- merge(dtActivityLabel, dt, by = "activityID", all.x = TRUE)
#Add activityName as a key.
setkey(dt, subject, activityID, activity)

##Step4: Appropriately labels the data set with descriptive variable names.
#reshape the table to have ony one attribute on each column, i.e from wide format to long format
dtMelt <- data.table(melt(dt, key(dt), variable.name = "features"))
dtMelt$activity<-factor(dtMelt$activity)
dtMelt$features<-factor(dtMelt$features)

#seperate features column into  multiple variables
#domain= t=time, f=freq
#instrument: Acc=accelerometer, Gyro=gyroscope
#acceleration: BodyAcc = body, GravityAcc=gravity
#variable: mean()=mean, sd

#jerk: Jerk=jerk, blank=NA
#magnitude: Mag=Magnitude, blank=NA

#axis: X=x, Y=y, Z=z, blank=NA

## Features with 2 categories
n <- 2
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepl("^t", dtMelt$feature), grepl("^f", dtMelt$feature)), ncol = n)
dtMelt$domain <- factor(x %*% y, labels = c("time", "freq"))

x <- matrix(c(grepl("Acc", dtMelt$feature), grepl("Gyro", dtMelt$feature)), ncol = n)
dtMelt$instrument <- factor(x %*% y, labels = c("accelerometer", "gyroscope"))

x <- matrix(c(grepl("BodyAcc", dtMelt$feature), grepl("GravityAcc", dtMelt$feature)), ncol = n)
dtMelt$acceleration <- factor(x %*% y, labels = c(NA, "body", "gravity"))

x <- matrix(c(grepl("mean()", dtMelt$feature), grepl("std()", dtMelt$feature)), ncol = n)
dtMelt$variable <- factor(x %*% y, labels = c("mean", "sd"))

## Features with 1 category
dtMelt$jerk <- factor(grepl("Jerk", dtMelt$feature), labels = c(NA, "jerk"))
dtMelt$magnitude <- factor(grepl("Mag", dtMelt$feature), labels = c(NA, "magnitude"))

## Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepl("-X", dtMelt$feature), grepl("-Y", dtMelt$feature), grepl("-Z", dtMelt$feature)), ncol = n)
dtMelt$axis <- factor(x %*% y, labels = c(NA, "x", "y", "z"))


##Step5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
setkey(dtMelt, subject, activity, domain, acceleration, instrument,jerk, magnitude, variable, axis)

dtTidy <- dtMelt %>%
group_by(subject, activity, domain, acceleration, instrument,jerk, magnitude, variable, axis) %>% 
summarise(count=n(), average = mean(value))


##Make codebook called CodeBook.md
knit("makeCodebook.Rmd", output = "codebook.md", encoding = "ISO8859-1", quiet = TRUE)


#create README.md for scripts, explaining how the scripts wok and how they are connected

