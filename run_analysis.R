#Extract data
features <- read.csv('D:/UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

train.x <- read.table('D:/UCI HAR Dataset/train/X_train.txt')
train.activity <- read.csv('D:/UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
train.subject <- read.csv('D:/UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')

train <-  data.frame(train.subject, train.activity, train.x)
names(train) <- c(c('subject', 'activity'), features)

test.x <- read.table('D:/UCI HAR Dataset/test/X_test.txt')
test.activity <- read.csv('D:/UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
test.subject <- read.csv('D:/UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

test <-  data.frame(test.subject, test.activity, test.x)
names(test) <- c(c('subject', 'activity'), features)

head(train)
names(train)
dim(train)

#1 Merges the training and the test sets to create one data set.
df<-rbind(train,test)
#2 Extracts only the measurements on the mean and standard deviation for each measurement.
df2<-grep('mean|std', features)
df3 <- df[,c(1,2,df2)]
names(df3)
#3 Uses descriptive activity names to name the activities in the data set
df3$activity<-as.factor(df3$activity)
df3$activity<-revalue(df3$activity,c("1"="Walking","2"="Walkig_up","3"="walking_down","4"="sitting","5"="standing","6"="laying"))
head(df)
#4 Appropriately labels the data set with descriptive variable names.
nn <- names(df3)
nn <- gsub("[(][)]", "", nn)
nn <- gsub("^t", "TimeDomain_", nn)
nn <- gsub("^f", "FrequencyDomain_", nn)
nn <- gsub("Acc", "Accelerometer", nn)
nn<- gsub("Gyro", "Gyroscope", nn)
nn <- gsub("Mag", "Magnitude", nn)
nn <- gsub("-mean-", "_Mean_", nn)
nn <- gsub("-std-", "_StandardDeviation_", nn)
nn <- gsub("-", "_", nn)
names(sub) <- nn
head(df3)
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
num_act<-group_by(df3,subject,activity)
new<-aggregate(df3,by=list(df3$activity,df3$subject),mean)
str(new)
dim(new)
write.table(x = new, file = "new.txt", row.names = FALSE)
