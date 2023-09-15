
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
              destfile = './hw4_data.zip', method = 'curl', quiet = T)
unzip(zipfile = 'hw4_data.zip')

# Read in label files
actLab <- read.table('./UCI HAR Dataset/activity_labels.txt', 
                     col.names = c('activityLabels', 'activityName'), quote = "")
# Links the class labels with their activity name
features <- read.table('./UCI HAR Dataset/features.txt', 
                       col.names = c('featureLabels', 'featureName'), quote = "")

# Read in test data
subTest <- read.table('./UCI HAR Dataset/test/subject_test.txt', col.names = c('subjectId'))
  #Each row identifies the subject who performed the activity for each window sample. 
  #Its range is from 1 to 30.
XTest <- read.table('./UCI HAR Dataset/test/X_test.txt')
  #Mesurements for the test data (features)
yTest <- read.table('./UCI HAR Dataset/test/y_test.txt')
  #Result for the test data (outcomes)

# Combine all test data and give column names
colnames(XTest) <- features$featureName
colnames(yTest) <- c('activityLabels')
testData <- cbind(subTest, XTest, yTest)

# Read in training data
subTrain <- read.table('./UCI HAR Dataset/train/subject_train.txt', col.names = c('subjectId'))
XTrain <- read.table('./UCI HAR Dataset/train/X_train.txt')
yTrain <- read.table('./UCI HAR Dataset/train/y_train.txt')

# Combine all training data and give column names
colnames(XTrain) <- features$featureName
colnames(yTrain) <- c('activityLabels')
trainData <- cbind(subTrain, XTrain, yTrain)

allData <- rbind(trainData, testData)


meanSdData <- allData[, c(1, grep(pattern = 'mean\\(\\)|std\\(\\)', x = names(allData)), 563)]

meanSdData$subjectId <- as.factor(meanSdData$subjectId)
meanSdData$activity <- factor(meanSdData$activityLabels,
                              levels = actLab$activityLabels,
                              labels = actLab$activityName)
  #make a new column that considers the activityLabels column a factor of 6 levels, 
  #with the label the same as the activity name
meanSdData <- meanSdData[, -68]
  #remove the activity labels column to tidy up the data
names(meanSdData)

colnames(meanSdData) <- gsub(pattern = '\\(\\)', replacement = "", x = names(meanSdData))
  #remove the () for the mean and std in the measurements
meanSdData <- meanSdData[, c(1, 68, 2:67)]
  #move the activity column to the second column
write.table(meanSdData, file = 'tidyData.txt', row.names = F, quote = F, sep = "\t")

library(dplyr)
meanSdDataByIdAct <- group_by(meanSdData, subjectId, activity) %>% summarise_all(funs(mean))
write.table(meanSdDataByIdAct, file = 'tidyDataMean.txt', row.names = F, quote = F, sep = "\t")
