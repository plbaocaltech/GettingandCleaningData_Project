
library('plyr')

# Read Data from train set and test set

xtrain <- read.table('./UCI HAR Dataset/train/X_train.txt');
ytrain <- read.table('./UCI HAR Dataset/train/Y_train.txt');
subjecttrain <- read.table('./UCI HAR Dataset/train/subject_train.txt');

xtest <- read.table('./UCI HAR Dataset/test/X_test.txt');
ytest <- read.table('./UCI HAR Dataset/test/Y_test.txt');
subjecttest <- read.table('./UCI HAR Dataset/test/subject_test.txt');


# Combine Data
xdata <- rbind(xtrain, xtest);
ydata <- rbind(ytrain, ytest);
subjectdata <- rbind(subjecttrain, subjecttest);

# Read Feature and Labels
features <- read.table('./UCI HAR Dataset/features.txt');
labels <- read.table('./UCI HAR Dataset/activity_labels.txt');

# Extract wanted features (mean or std) and apply it to xdata.
useful_features <- grep('*mean*|*std*',features$V2);
xdata <- xdata[,useful_features];
names(xdata) <- features$V2[useful_features];

# Fix ydata
ydata$V1 <- labels$V2[ydata$V1];
names(ydata)<- 'activity';

# Fix subject data
names(subjectdata)<- 'subject';

# Combine all data
alldata <- cbind(xdata, ydata, subjectdata)

#  averaging data for activity and subject
averagesdata <- ddply(alldata, .(subject, activity), function(x) colMeans(x[, 1:66]))

# write tabel
write.table(averagesdata,'averagedata.txt', row.name=FALSE)
