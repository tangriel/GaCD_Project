library(plyr)

getData = function() {
    # Checks for data directory and creates one if it doesn't exist
    if (!file.exists("data")) {
        message("Making data folder")
        dir.create("data")
    }
    if (!file.exists("data/UCI HAR Dataset")) {
        # download initial dataset if necessary
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zipFile="data/UCI_HAR_data.zip"
        message("Downloading data")
        download.file(fileURL, destfile=zipFile)
        unzip(zipFile, exdir="data")
    }
}

mergeData = function() {
    # Merge training and test datasets
    # Read
    message("getting X_train.txt")
    training.x <- read.table("data/UCI HAR Dataset/train/X_train.txt")
    message("getting y_train.txt")
    training.y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
    message("getting subject_train.txt")
    training.subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
    message("getting X_test.txt")
    test.x <- read.table("data/UCI HAR Dataset/test/X_test.txt")
    message("getting y_test.txt")
    test.y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
    message("getting subject_test.txt")
    test.subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
    
    # Merge
    merged.x <- rbind(training.x, test.x)
    merged.y <- rbind(training.y, test.y)
    merged.subject <- rbind(training.subject, test.subject)
    
    # merge datasets and return
    list(x=merged.x, y=merged.y, subject=merged.subject)
}

meanStd = function(df) {
    # Extracting mean and standard deviation from each measurement

    # Read feature list
    features <- read.table("data/UCI HAR Dataset/features.txt")
    # Find mean and std columns
    mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
    std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
    # Extract the appropriate data
    edf <- df[, (mean.col | std.col)]
    colnames(edf) <- features[(mean.col | std.col), 2]
    edf

}

activityNames = function(df) {
    # Descriptive activity names for activities
    
    activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt")
    colnames(df) <- "activity"
    df$activity <- factor(df$activity, levels=activity_labels$V1, labels=activity_labels$V2)
    df
}

bindData <- function(x, y, subjects) {
    # Bind mean-std (x), activities (y) and subjects
    cbind(x, y, subjects)
}

tidyData = function(df) {
    # Given bindData, create the tidy dataset with the mean 
    # within each activity and subject
    
    tidy <- aggregate(.~ subject+activity, data = df, mean)[order(tidy$subject),]
    tidy
}

cleanAll = function() {
    # Download data
    getData()
    
    # merge training and test datasets. get a list of X, y, and subject
    merged <- mergeData()
    
    # Extracting mean and standard deviation from each measurement
    cx <- meanStd(merged$x)
    
    # Name activities
    cy <- activityNames(merged$y)
    
    # Column name for subjects
    colnames(merged$subject) <- c("subject")
    
    # Bind mean-std (cx), activities (cy) and subjects
    combined <- bindData(cx, cy, merged$subject)
    
    # Produce tidy dataset
    tidy <- tidyData(combined)
    
    # Write the result into csv file
    write.csv(tidy, "tidy_UCI.csv", row.names=FALSE)
}
