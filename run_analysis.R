## Coursera Course project

## Load data
## Note that the files must be in their original directory structure within your
## working directory for the code to work. (all files should be in "UCI HAR Dataset")
## The file "features.txt" must be in the directory as well
## Code relies on dplyr package for certain steps

## load initial files
setwd("UCI HAR Dataset/test")
subject_test <- read.table("subject_test.txt")
x_test <- read.table("x_test.txt")
y_test <- read.table("y_test.txt")
test_data <- cbind(subject_test, y_test, x_test)

setwd("../")
setwd("train")
subject_train <- read.table("subject_train.txt")
x_train <- read.table("x_train.txt")
y_train <- read.table("y_train.txt")
train_data <- cbind(subject_train, y_train, x_train)

##Step 1: Merges the training and the test sets to create one data set.
all_data <- rbind(test_data, train_data)

##Step 2: Extracts only the measurements on the mean and standard deviation for 
##each measurement.
## define needed columns
cols <- c(1,2,3,4,5,6, 
          41,42,43,44,45,46,
          81,82,83,84,85,86,
          121,122,123,124,125,126,
          161,162,163,164,165,166,
          201,202,
          214,215,
          227,228,
          240,241,
          253,254,
          266,267,268,269,270,271,
          345,346,347,348,349,350,
          424,425,426,427,428,429,
          503,504,
          516,517,
          529,530,
          542,543)
cols <- cols + 2
all_data <- all_data[ , c(1,2,cols)]

##Step 3: Uses descriptive activity names to name the activities in the data set
setwd("../")
activities <- read.table("activity_labels.txt")
all_data <- merge(all_data, activities, by.x = "V1.1", by.y = "V1", all = TRUE)
ord <- 3:68
all_data <- all_data[ , c(2, 69, ord)]

##Step 4:Appropriately labels the data set with descriptive variable names.
features <- read.table("features.txt")
cols <- cols - 2
features <- features[cols, ]
actlist <- as.vector(features[ ,2])
## clean up activity labels
actlist <- gsub("\\()","",actlist)
actlist <- gsub("-","_", actlist)
colnames(all_data) <- c("subject", "activity", actlist)

##Tep 5: From the data set in step 4, creates a second, independent tidy 
##data set with the average of each variable for each activity and each subject.
library(dplyr)
summ_data <- group_by(all_data, activity, subject)
summ_data <- summarise_each(summ_data, funs(mean))
