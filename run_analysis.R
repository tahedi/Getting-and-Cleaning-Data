##Function for check for installed R packages before running install.packages()
pkgTest <- function(x)
  {
    if (!require(x,character.only = TRUE))
    {
      install.packages(x,dep=TRUE)
        if(!require(x,character.only = TRUE)) stop("Package not found")
    }
  }
#Required packages.
##Package for join operation.
pkgTest("plyr")
##Package for accelerate reading big fixed length files (X_train.txt,Y_train.txt). 
pkgTest("LaF")
##Package for rechaping Data.
pkgTest("reshape")

folder <- dirname(sys.frame(1)$ofile)
setwd(folder)
##Unzip the Samsung data in your working directory..
unzip("getdata_projectfiles_UCI HAR Dataset.zip")
#Part1 : Reading files.

##Read (X_train.txt,X_test.txt) files using LaF function (laf_open_fwf).
dataTrainX <-laf_open_fwf(filename="UCI HAR Dataset/train/X_train.txt",column_types=rep("numeric",561),column_widths=rep(16,561),dec=".")
dataTestX <- laf_open_fwf(filename="UCI HAR Dataset/test/X_test.txt",column_types=rep("numeric",561),column_widths=rep(16,561),dec=".")
###Convert laf objects to data frames.
dataTrainX <-dataTrainX[,]
dataTestX <-dataTestX[,]
##Read (y_train.txt,y_test.txt).
trainY <- read.csv(file="UCI HAR Dataset/train/y_train.txt",header=F)
testY <- read.csv(file="UCI HAR Dataset/test/y_test.txt",header=F)
##Read subjects(subject_train.txt,subject_test.txt).
subjectTrain <- read.csv(file="UCI HAR Dataset/train/subject_train.txt",header=F)
subjectTest <- read.csv(file="UCI HAR Dataset/test/subject_test.txt",header=F)
##Read features file (features.txt) and give names to columns.
features <- read.csv(file="UCI HAR Dataset/features.txt",header=F,sep=" ",stringsAsFactors=FALSE)
colnames(features)<-c("idFeature","featureName")
##Read labels file (activity_labels.txt) and give names to columns.
labels <-read.csv(file="UCI HAR Dataset/activity_labels.txt",header=F,sep=" ",stringsAsFactors=FALSE)
colnames(labels) <- c("IdActivity","activityName")

#Part2 : Merges the training and the test sets to create one data set.

##Merges the training and the test sets to create one data set (X). 
##Give columns names according to features list. 
mergeX <- rbind(dataTrainX,dataTestX)
colnames(mergeX)<-features[,2]
##Extracts only the measurements on the mean and standard deviation for each measurement. 
selectedFeatures <- grep("mean\\(\\)|std\\(\\)",features[,2])
mergeX <- mergeX[,selectedFeatures]
##Merges the training and the test sets to create one data set (Y).  
mergeY <- rbind(trainY ,testY)
colnames(mergeY)<-"IdActivity"
##Free memory from removing unnecessary objects.
remove(trainY ,testY,dataTrainX,dataTestX)
##Merge training and test subjects and give columns names according to features list.
mergeSubject <- rbind(subjectTrain,subjectTest)
colnames(mergeSubject) <- "Subject"
remove(subjectTrain,subjectTest)
##Combine X and y in one dataframe.
newDataSet1 <- cbind(mergeX,mergeY)
##Join with labels inorder to adding activity names.
newDataSet1<- join(newDataSet1,labels)
##Free memory from removing unnecessary objects.
remove(mergeX,mergeY,labels,features)
##Remove id of activity from data Frame. 
newDataSet1$IdActivity <- NULL

#Part3 : average of each variable for each activity and each subject.
newDataSet2 <- cbind(newDataSet1,mergeSubject)
remove(mergeSubject)
##Convert Data to long format
temp <- melt(newDataSet2,c("activityName","Subject"))
##Calculate average grouped by (activityName,Subject,variable)  
newDataSet2 <- ddply(temp,.(activityName,Subject,variable),summarize,mean=mean(value))
write.csv(newDataSet2,"tidyDataSet.txt")
##Remove unnecessary object temp
remove(temp)
