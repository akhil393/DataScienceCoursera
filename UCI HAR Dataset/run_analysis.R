##Author: Akhil Vangala
##Date:08/23/2015
##Comment: Script to create tidy data set from original data set for further processing 
##Note please read code book to understand different variables 
#Load Tran data set into R

library(dplyr)
library(reshape2)
x_test <- read.table(file.path(getwd(),"test","X_test.txt"))
x_train <- read.table(file.path(getwd(),"train","X_train.txt"))
#verify no of varibales before merging
ncol(x_test)
ncol(x_train)
#Merge train and test dataset
x<-rbind(x_test,x_train)
#load features data set column names 
features <- read.table("features.txt")
#Assign colnames from features data frame 
names(x) <-features$V2
#Extracts only the measurements on the mean and standard deviation for each measurement
xmeanstd<-grep(paste(c("mean","std"),collapse="|"),names(x)) 
#subset data based on indexes
x <- x[,xmeanstd]
#Use descriptive activity names to name the activities in the data set
#load acitivity data set 
y_test<-read.table(file.path(getwd(),"test","Y_test.txt"))
y_train<-read.table(file.path(getwd(),"train","Y_train.txt"))
y <-rbind(y_test,y_train)
#Get activity lables 
activity <- read.table("activity_labels.txt")
# Join activity with y data set to get lable info
y_labels <- merge(y,activity,by.x="V1",by.y="V1",all=FALSE)
names(y_labels) <-c("labelid","label")
x<-cbind(y_labels$label,x)
#Get Sbject info 
subj_test<-read.table(file.path(getwd(),"test","subject_test.txt"))
subj_train<-read.table(file.path(getwd(),"train","subject_train.txt"))
subj<-rbind(subj_test,subj_train)
#Merge Subj data to main dataset 
xsubj<-rbind(subj_test,subj_train)
x<-cbind(xsubj,x)
#Descriptive variable names
names(x)[1:2] <- c("Subject","Activity")
#Calculate mean
x<-x %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
#reshape data by adding additional variables and transforming existing variables 
#so a vairiable only represents one value
x<-melt(x,id=names(x[1:2]),measure.vars = names(x)[3:length(x)])
#reshape the data add variables
x<-mutate(x,Domain = ifelse(substr(variable,1,1)=="t","Time","Frequency"))
x<-mutate(x,AccelarationSignal = ifelse(grepl("Body",variable)==TRUE,"Body","Gravity"))
x<-mutate(x,Sensor = ifelse(grepl("Acc",variable)==TRUE,"Accelerometer","Gyroscope"))
x<-mutate(x,JerkSignal = ifelse(grepl("Jerk",variable)==TRUE,TRUE,FALSE))
x<-mutate(x,Axis = ifelse(grepl("X",variable)==TRUE,"X",ifelse(grepl("Y",variable)==TRUE,"Y",ifelse(grepl("Z",variable)==TRUE,"Z","XYZ"))))
x<-mutate(x,MagnitudeSignal = ifelse(grepl("Mag",variable)==TRUE,TRUE,FALSE))
x<-mutate(x,Measure = ifelse(grepl("Freq",variable)==TRUE,"Weighted Average",ifelse(grepl("std()",variable)==TRUE,"Standard Deviation",ifelse(grepl("mean",variable)==TRUE,"Average","NA"))))
#remove colums we dont need 
x<- x[-(3)]
#re name columns
names(x)[3]<-c("AvgSensorValue")
x<-arrange(x,Subject,Activity,Domain,AccelarationSignal,Sensor,JerkSignal,Axis,MagnitudeSignal,Measure  )
#Extract data to local dir 
write.table(x,"TidyUCIHAR.txt",row.name=FALSE)
##disaplay sample of final dataset
head(x)
print(x)
print(paste("tiday data set TidyUCIHAR.txt is written to " ,getwd()))


