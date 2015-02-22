## Merge the training and the test sets to create one data set.
The script begins by reading the test and train data and combining them into one data frame. The same is done for the test and training activity data. The activity labels are then read and then applied to the activity data. The feautures file is then read and then used for the training data column names.
## Extract only the measurements on the mean and standard deviation for 
## each measurement.
The training data columns names are then scanned for the presence of std and mean and a subset of columns created. From these names a subset of the training data is created based on the standard deviation and mean data.

The test and training subject data is then read in and merged into one data set. This data set is in turn combined with a merge of the subject and activity data and the first two columns appropriately renamed.

## Appropriately label the data set with descriptive variable names.
The column names then through a series of transformations to make them more readable. The make.names function is used to provide a preliminary clean up. The column names are then split on full stops and spaces inserted and subsequent trailing spaces removed. The initial letters of the resultant strings that make up the column names are then capitalised. The t and f abbreviations are then replaced with Time and Frequency respectively.

Finally a tidy data set is created using ddply on the basis of the Activity and Subject columns.