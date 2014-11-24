# Set working directory to 'Final Project'
if (!getwd() == "C:/Users/user/Desktop/Final Project") {
  setwd("C:/Users/user/Desktop/Final Project")
}

# Load required libraries
library(data.table)
library(dplyr)
library(plyr)

# Download data zip file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","temp.zip")

# Unzip the data file
unzip("temp.zip")

features <- read.table("./UCI HAR Dataset/features.txt")
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
                       
# Assign column names
colnames(xTrain) <- features[,2]
colnames(xTest) <- features[,2]

# Merge sets together
xTrain$activities <- yTrain[, 1]
xTrain$participants <- subjectTrain[, 1]
xTest$activities <- yTest[, 1]
xTest$participants <- subjectTest[, 1]

# 1. Create a single set
MySet <- rbind(xTrain, xTest)

# 2. Extract means 
MyMean <- grep("mean()", names(MySet), value = FALSE, fixed = TRUE)

# 3. Assign names to activities instead of numbers
MySet$activities[MySet$activities == 6] <- "lay"
MySet$activities[MySet$activities == 5] <- "stand"
MySet$activities[MySet$activities == 4] <- "sit"
MySet$activities[MySet$activities == 3] <- "Walk_down"
MySet$activities[MySet$activities == 2] <- "Walk_up"
MySet$activities[MySet$activities == 1] <- "Walk"

# 4. Label the data set for each of 30 participants
for (i in 1:30) {
   MySet$participants[MySet$participants == i] <- paste("Participant", toString(i), sep = " ") 
}

# 5. Create smaller data set with means for activities (#3) and participants (#4)
ind_set <- MySet[, lapply(.SD, mean), by="participants,activities"]

# Write tidy data set to a file
write.table(ind_set, file = "tidy.txt", row.names = FALSE)