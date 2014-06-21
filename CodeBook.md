# Intro

`run_analysis.R` does the following:
- gets the data from the repository
  [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.html)
- merges training and test sets into one
- the measurements are extracted according to the mean and standard deviation
- changes `activity` values in the initial dataset into descriptive activity names
- labels the columns with the proper names
- creates a tidy dataset with the mean for each variable within each activity and
  subject. It means that the tidy data set has only averaged measurement for the
  particular subject and activity. The result is exported in csv
  
# The R script

It is supposed that you have `plyr` library installed in advance. The script is divided into parts (i.e. functions) to provide each of the features above. To perform cleaning on the whole call `cleanAll` function.

# The initial dataset

The initial dataset consists of two: training and test ones (70% and 30%,
correspondently). Each part includes three files with the following:
- measurements from accelerometer and gyroscope
- activity label
- identifier of the subject

# Getting and cleaning data

If there is no data in the `data` folder, it is downloaded
from the repository (as described in Intro section).

The first thing to do is to merge training and test
sets. These sets together contain 10,299 instances each with 561 features 
(i.e. subject identifier, and the measurements are the rest). After
the merge is done, the obtained dataset has 562 columns (correspondingly, the 
subject identifier, all the measurements and activity label).

As soon as the merge is complete, it is possible to extract the mean and standard
deviation which are necessary for the further processing. After this operation we
get the following as a result: the data frame with subject identifier, activity
label and the appropriate means and standard deviations (33 each).

Then it is the right time to change the activity labels into more human readable ones (those from `activity_labels.txt` in the initial data catalogue).

The last step is to create the tidy dataset. It has the mean for each variable
within each activity and subject. All samples are broken into 180 groups, mean and
standard deviation are calculated for each one.
The resulting dataset is exported to `tidy_UCI.csv`. The column names are in the
first row, the header.