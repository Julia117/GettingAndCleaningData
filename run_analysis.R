#1
test <- data.table::fread(file = "./UCI HAR Dataset/test/X_test.txt")
train <- data.table::fread(file = "./UCI HAR Dataset/train/X_train.txt")
y_test <- data.table::fread(file = "./UCI HAR Dataset/test/y_test.txt")
y_train <- data.table::fread(file = "./UCI HAR Dataset/train/y_train.txt")
subject_test <- data.table::fread(file = "./UCI HAR Dataset/test/subject_test.txt")
subject_train <- data.table::fread(file = "./UCI HAR Dataset/train/subject_train.txt")
test <- cbind(y_test, test)
test <- cbind(subject_test, test)
train <- cbind(y_train, train)
train <- cbind(subject_train, train)
data <- rbind(test, train)

#2
features <- data.table::fread(file = "./UCI HAR Dataset/features.txt")
use_cols_raw <- grep("mean()|std()", features$V2)

use_cols <- c(1, 2, use_cols_raw +2)

data <- data[, ..use_cols]

#3

activity_names = c("WALKING",
                   "WALKING_UPSTAIRS",
                   "WALKING_DOWNSTAIRS",
                   "SITTING",
                   "STANDING",
                   "LAYING"
)

data[,2] <- activity_names[unlist(data[,2])]

#4
features <- features[use_cols_raw]
features <- gsub("-", ".", features$V2)
features <- sub("t", "time", features)
features <- sub("f", "freq", features)
features <- c("subject", "activityLabel", features)
colnames(data) = features

#5
tidyDF <- group_by(data, subject, activityLabel)
tidyDF <- summarise_each(tidyDF, funs = "mean")
write.table(tidyDF, file = "tidyData.txt", row.names = FALSE)



