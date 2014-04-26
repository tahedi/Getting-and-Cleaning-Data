
##Load required packages.
* Package for join operation ("plyr").
* Package for accelerate reading big fixed length files (X_train.txt,Y_train.txt) ("LaF"). 
* Package for rechaping Data ("reshape").

#Unzip the Samsung data in your working directory..

##Part1 : Reading files.
----------------------------------------------------------------------
* Read (X_train.txt,X_test.txt) files using LaF function (laf_open_fwf).
* Convert laf objects to data frames.
* Read (y_train.txt,y_test.txt).
* Read subjects(subject_train.txt,subject_test.txt).
* Read features file (features.txt) and give names to columns.
* Read labels file (activity_labels.txt) and give names to columns.


##Part2 : Merges the training and the test sets to create one data set.
-----------------------------------------------------------------------
* Merges the training and the test sets to create one data set (X). 
* Give columns names according to features list. 
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Merges the training and the test sets to create one data set (Y).  
* Merge training and test subjects and give columns names according to features list.
* Combine X_train and y_train in one dataframe.
* Join with labels in order to adding activity names.
* Remove id of activity from data Frame. 

##Part3 : average of each variable for each activity and each subject.
-----------------------------------------------------------------------
* Convert Data to long format
* Calculate average grouped by (activityName,Subject,variable)  

