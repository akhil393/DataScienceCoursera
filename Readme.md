Human Activity Recognition Using Smartphones Tidy Data Set
========================================================
### Author Akhil Vangala
### Date: 08/23/2015
This documents describes steps taken to extrac and Clean,Tidy the data set as part of course project for getting and cleaning data
Please run run_analysis.R to perform the Tidy of dataset
--------------------------------------------------------
Instructions in running run_analysis.R.
Once Github repository is downloaded extract UCI data set zip file in same location.
Open R set the work space to downloded location
run
`````{r}
source("run_analysis.R")
`````
Note: this process is verified in windows environment
--------------
## About Data Set 
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.


#### No of Data Sets 

 1)Training 
 2)Test
 
 
#### load Train Data set and Test data

Use read.table method to load dataset

`````{r}
x_test <- read.table(file.path(getwd(),"test","X_test.txt"))
x_train <- read.table(file.path(getwd(),"train","X_train.txt"))
````
#### verify no of varibales before merging
`````{r}
ncol(x_test)
ncol(x_train)
`````
#### Merge train and test dataset
`````{r}
x<-rbind(x_test,x_train)
`````
#### 

#### load features data set column names 
````{r}
features <- read.table("features.txt")
````
#### Assign colnames from features data frame 
`````{r}
names(x) <-features$V2
```
#### Extracts only the measurements on the mean and standard deviation for each measurement
````{r}
xmeanstd<-grep(paste(c("mean","std"),collapse="|"),names(x)) 
``````
#### subset data based on indexes
``````{r}
x <- x[,xmeanstd]
`````
#### Use descriptive activity names to name the activities in the data set
#### load acitivity data set 
``````{r}
y_test<-read.table(file.path(getwd(),"test","Y_test.txt"))
y_train<-read.table(file.path(getwd(),"train","Y_train.txt"))
y <-rbind(y_test,y_train)
``````

#### et activity lables 
``````{r}
activity <- read.table("activity_labels.txt")
`````
#### Join activity with y data set to get lable info
`````````{r}
y_labels <- merge(y,activity,by.x="V1",by.y="V1",all=FALSE)
names(y_labels) <-c("labelid","label")
x<-cbind(y_labels$label,x)
`````````
#### Get Sbject info 
`````````{r}
subj_test<-read.table(file.path(getwd(),"test","subject_test.txt"))
subj_train<-read.table(file.path(getwd(),"train","subject_train.txt"))
subj<-rbind(subj_test,subj_train)
`````````
#### Merge Subj data to main dataset 
`````````{r}
xsubj<-rbind(subj_test,subj_train)
x<-cbind(xsubj,x)
`````````

#### Descriptive variable names
```````````````````````````{r}
names(x)[1:2] <- c("Subject","Activity")
``````````````````
#### Calculate mean
``````````````````{r}
x<-x %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
``````````````````
#### reshape data by adding additional variables and transforming existing variables 
#### so a vairiable only represents one value
``````````````````{r}
x<-melt(x,id=names(x[1:2]),measure.vars = names(x)[3:length(x)])
``````````````````
#### reshape the data add variables
#### If variable starts with t then Time else frequency
``````````````````{r}
x<-mutate(x,Domain = ifelse(substr(variable,1,1)=="t","Time","Frequency"))
``````````````````
#### if variable name contains body then its body acceleration signal else gravity
``````````````````{r}
x<-mutate(x,AccelarationSignal = ifelse(grepl("Body",variable)==TRUE,"Body","Gravity"))
x<-mutate(x,Sensor = ifelse(grepl("Acc",variable)==TRUE,"Accelerometer","Gyroscope"))
x<-mutate(x,JerkSignal = ifelse(grepl("Jerk",variable)==TRUE,TRUE,FALSE))
x<-mutate(x,Axis = ifelse(grepl("X",variable)==TRUE,"X",ifelse(grepl("Y",variable)==TRUE,"Y",ifelse(grepl("Z",variable)==TRUE,"Z","XYZ"))))
x<-mutate(x,MagnitudeSignal = ifelse(grepl("Mag",variable)==TRUE,TRUE,FALSE))
x<-mutate(x,Measure = ifelse(grepl("Freq",variable)==TRUE,"Weighted Average",ifelse(grepl("std()",variable)==TRUE,"Standard Deviation",ifelse(grepl("mean",variable)==TRUE,"Average","NA"))))
``````````````````
####remove colums we dont need 
``````````````````{r}
x<- x[-(3)]
``````````````````
#### rename columns
``````````````````
names(x)[3]<-c("AvgSensorValue")
``````````````````{r}
#### disaplay sample of final dataset
``````````````````
x<-arrange(x,Subject,Activity,AccelarationSignal,Sensor,JerkSignal,Axis,MagnitudeSignal,Measure)
#### Write the tidy data set to local disk 
```{r}
write.table("TidyUCHAR.txt",row.name=FALSE)
print(paste("Tidy Dataset is written to local disk",getwd()))
`````
head(x)

