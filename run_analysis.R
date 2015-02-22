## Merge the training and the test sets to create one data set.
library(plyr)
testData <- read.table("UCI HAR Dataset/test/X_test.txt")
trainData <- read.table("UCI HAR Dataset/train/X_train.txt")
testTrainData <- rbind(testData,trainData)
trainActivities <- read.table("UCI HAR Dataset/train/y_train.txt")
testActivities <- read.table("UCI HAR Dataset/test/y_test.txt")
activities <-rbind(testActivities, trainActivities)
names(activities) <- "activity"
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activityLabels) <- c("index", "activity")
## Use descriptive activity names to name the activities in the data set
activities <- unlist(lapply(activities$activity, 
  function(x) { 
    activities$activity[activities$activity == x] <- as.character(activityLabels[x,2])
  }))

## Extract only the measurements on the mean and standard deviation for 
## each measurement. 
features <- read.table("UCI HAR Dataset/features.txt")
names(testTrainData) <- features$V2
columns <- colnames(testTrainData)
stdMeanColumns <- grep("[Ss]td|[Mm]ean", columns)
stdMean <- testTrainData[stdMeanColumns]
stdMean <- stdMean[, !duplicated(colnames(stdMean))]
                     
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
subjects <- rbind(testSubjects, trainSubjects)
activitySubjects <- cbind(subjects, activities)
stdMean <- cbind(activitySubjects, stdMean)
names(stdMean)[1] <- "subject"
names(stdMean)[2] <- "activity"

## Appropriately label the data set with descriptive variable names.
newNames <- make.names(names(stdMean)[c(1:81)], unique=TRUE, allow_=TRUE)
angles <- names(stdMean)[c(82:length(names(stdMean)))]
angles <- gsub("\\(|\\)|,", " ", angles)
angles <- gsub("tB", "t B", angles)
newNames <- append(newNames, angles)
newNames <- strsplit(newNames,"\\.", fixed=TRUE)
newNames <- gsub("[\\.]+", " ", newNames)
newNames <- gsub("\\s+$", "", newNames)
newNames <- gsub("([A-Z])", " \\1", newNames)
simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1, 1)), substring(s, 2),
        sep = "", collapse = " ")
}
newNames <- unlist(lapply(newNames,simpleCap))
newNames <- unlist(lapply(newNames, function(line) { gsub("^T ", "Time ", line) }))
newNames <- unlist(lapply(newNames, function(line) { gsub(" T ", " Time ", line) }))
newNames <- unlist(lapply(newNames, function(line) { gsub("^F ", "Frequency ", line) }))
names(stdMean) <- newNames

## From the data set in step 4, create a second, independent tidy data 
## set with the average of each variable for each activity and each subject.
tidyData <- ddply(stdMean, c("Activity","Subject"), numcolwise(mean, na.rm = TRUE))