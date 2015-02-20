## Merge the training and the test sets to create one data set.
testData <- read.table("test/X_test.txt")
testData <- testData[, !duplicated(colnames(test))]
trainData <- read.table("train/X_train.txt")
trainData <- trainData[, !duplicated(colnames(train))]
activityLabels <- read.table("activity_labels.txt")
names(activityLabels) <- c("index", "activity")
y_train <- read.table("train/y_train.txt")
y_test <- read.table("test/y_test.txt")
y_bind <-rbind(y_test, y_train)
names(y_bind) <- "activity"
y_bind <- unlist(lapply(y_bind$activity, 
  function(x) { 
    y_bind$activity[y_bind$activity == x] <- as.character(activityLabels[x,2])
  }))
testTrainData <- rbind(testData,trainData)
features <- read.table("features.txt")
names(testTrainData) <- features$V2

## Extract only the measurements on the mean and standard deviation for 
## each measurement. 
columns <- colnames(testTrainData)
std_mean_columns <- grep ("[Ss]td|[Mm]ean", columns)
std_mean <- testTrainData[std_mean_columns]

## Use descriptive activity names to name the activities in the data set
subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")
subject <- rbind(subject_test, subject_train)
names(subject) <- "subject"
activity_subject <- cbind(subject, y_bind)
std_mean <- cbind(activity_subject, std_mean)

## Appropriately label the data set with descriptive variable names.
new_names <- make.names(names(std_mean), unique=TRUE, allow_=TRUE)
new_names <- strsplit(new_names,"\\.",fixed=TRUE)
new_names <- gsub("[\\.]+", " ", y)
new_names <- gsub("([A-Z])", " \\1", new_names)
simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1, 1)), substring(s, 2),
        sep = "", collapse = " ")
}
new_names <- unlist(lapply(new_names,simpleCap))
new_names <- unlist(lapply(new_names, function(line) { gsub("^T ", "Time ", line) }))
new_names <- unlist(lapply(new_names, function(line) { gsub("^F ", "Frequency ", line) }))
names(std_mean) <- new_names

## From the data set in step 4, create a second, independent tidy data 
## set with the average of each variable for each activity and each subject.
tidy_data <- ddply(std_mean, c("Activity","Subject"), numcolwise(mean, na.rm = TRUE))
