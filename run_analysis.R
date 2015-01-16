#### Define lots of filenames ####
workingDir <- getwd()
dataDir <- paste(workingDir, "data", sep = "/")
zippedData <- paste(dataDir, "rawData.zip", sep = "/")
dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDirUnzipped <- paste(dataDir, "UCI HAR Dataset", sep = "/");
labelsKeyFile <- paste(dataDirUnzipped, "activity_labels.txt", sep = "/")
featuresFile <- paste(dataDirUnzipped, "features.txt", sep = "/")
testSetFile <- paste(dataDirUnzipped, "test/X_test.txt", sep = "/")
testSubjectFile <- paste(dataDirUnzipped, "test/subject_test.txt", sep = "/")
testLabelsFile <- paste(dataDirUnzipped, "test/y_test.txt", sep = "/")
trainingSetFile <- paste(dataDirUnzipped, "train/X_train.txt", sep = "/")
trainingSubjectFile <- paste(dataDirUnzipped, "train/subject_train.txt", sep = "/")
trainingLabelsFile <- paste(dataDirUnzipped, "train/y_train.txt", sep = "/")

allOutputFilename <- paste(workingDir, "tidyData.txt", sep = "/")
averagedOutputFilename <- paste(workingDir, "averagedTidyData.txt", sep = "/")

#### Get the data ####

# Check the data directory exists
if(!file.exists(dataDir)){
	dir.create(dataDir)
}

# Do the unzipped data exist?
if(!file.exists(dataDirUnzipped)){
	# Does the unzipped file at least exist?
	if(!file.exists(zippedData)){
		download.file(url = dataURL, destfile = zippedData, method = "curl")
	}
	unzip(zippedData, exdir = dataDir)
}

# Read the data into memory
# We're not using fread() since it seems to have trouble with with
# leading spaces on lines and with multiple spaces between entries.
#
# See the bug report at https://github.com/Rdatatable/data.table/issues/956

# Label keys
labelsKey <- read.table(labelsKeyFile, header = F)
features <- read.table(featuresFile, header = F)

# Work out which elements of the 561-element vector we actually want to use
# Note that just grep-ing for "mean" or "[Mm]ean" does not get us what
# we want, since it includes other stuff FIXME - elaborate
meanIndices <- grep("mean\\(\\)", features$V2)
stdIndices <- grep("std\\(\\)", features$V2)

#### Begin processing test data ####

# Read in the test data
testSet <- read.table(testSetFile, header = F)
testLabels <- read.table(testLabelsFile, header = F)
testSubjects <- read.table(testSubjectFile, header = F)

# We'll build up the dataset using the testSubjects data frame
names(testSubjects) <- c("subject.id")
# Convert the int representation of the activities into a factor
testSubjects$activity <- factor(testLabels$V1, levels = as.character(labelsKey$V1), labels = labelsKey$V2)

# Loop over the means in the dataset, adding them to our tidy data frame
for(i in meanIndices){
	# $-access friendly variable names
	tempName <- gsub("[\\(\\)]", "", gsub("-", ".", features$V2[i]))
	testSubjects[,tempName] <- testSet[,i]
}

# Loop over the stds in the dataset, adding them to our tidy data frame
for(i in stdIndices){
	# $-access friendly variable names
	tempName <- gsub("[\\(\\)]", "", gsub("-", ".", features$V2[i]))
	testSubjects[,tempName] <- testSet[,i]
}

#### Begin processing training data ####

# Read in the training data
trainingSet <- read.table(trainingSetFile, header = F)
trainingLabels <- read.table(trainingLabelsFile, header = F)
trainingSubjects <- read.table(trainingSubjectFile, header = F)

# We'll build up the dataset using the trainingSubjects data frame
names(trainingSubjects) <- c("subject.id")
# Convert the int representation of the activities into a factor
trainingSubjects$activity <- factor(trainingLabels$V1, levels = as.character(labelsKey$V1), labels = labelsKey$V2)

# Loop over the means in the dataset, adding them to our tidy data frame
for(i in meanIndices){
	# $-access friendly variable names
	tempName <- gsub("[\\(\\)]", "", gsub("-", ".", features$V2[i]))
	trainingSubjects[,tempName] <- trainingSet[,i]
}

# Loop over the stds in the dataset, adding them to our tidy data frame
for(i in stdIndices){
	# $-access friendly variable names
	tempName <- gsub("[\\(\\)]", "", gsub("-", ".", features$V2[i]))
	trainingSubjects[,tempName] <- trainingSet[,i]
}

#### Build and output the tidy dataset ####

tidyData <- rbind(testSubjects, trainingSubjects)
# The subject.id has no numeric meaning, so a factor variable is more appropriate
tidyData$subject.id <- factor(tidyData$subject.id)

write.table(tidyData, file = allOutputFilename, row.names = FALSE, col.names = TRUE) 

#### Average each variable for each activity and subject ####
averagedTidyData <- aggregate(. ~ subject.id + activity, data = tidyData, mean)
write.table(averagedTidyData, file = averagedOutputFilename, row.names = FALSE, col.names = TRUE) 
