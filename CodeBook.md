Peer Assessment For Getting and Cleaning Data - Codebook
========================================================

## Background

The assignment description can be found at [this Coursera page](https://class.coursera.org/getdata-010/human_grading/view/courses/973497/assessments/3/submissions).
The data comes from [this UCI machine learning dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Output data

### tidyData

Running the included R script will produce a data frame called 'tidyData'.
This data frame will also be written to the file 'tidyData.txt' in the
working directory. This is the dataset of *step 4* of the assignment.

The data frame contains variables:
* subject.id is a factor variable (labelled as ints) indexing
  who was wearing the monitor.
* activity is a factor variable (labelled as text) indicating
  what activity the subject was performing at that time.
* 66 numeric variables.

The 66 numeric variables have descriptive names, which take the general
form of (regular expression notaion):
(t/f)Name.(mean/std).(X/Y/Z)

t/f indicates whether the variable is in the time or frequency domain:
* The variables beginning with 't' form a timeseries with readings at
1.28 second intervals (see README.txt of original raw data: 2.56s 
window with 50% overlap).
* The varaibles beginning with 'f' are result from taking the FFT of
the corresponding 't' variable.

Name indicates what the variable actually records:
* 'BodyAcc' - the component of linear acceleration attributed to
  the movement of the human.
* 'GravityAcc' - the component of linear acceleration attributed
  to gravity (from passing accelaration through a low pass filter).
* 'BodyAccJerk' - the time derivative of 'BodyAcc'.
* 'BodyGyro' - angular velocity in radians / second. 
* 'BodyGyroJerk' - time derivative of 'BodyGyro'
* The suffix 'Mag' on a name indicates the Euclidean norm of a
  vector variable.

The mean/std part of the name indicated whether this is the mean or the
standard deviation.

The .(X/Y/Z) indicates the axis along / around which the linear / angular
acceleration is occurring. This is not present for the 'Mag' variables.

### averagedTidyData

The R script will also produce a variable called 'averagedTidyData'.
This is the result of, for each subject and activity, averaging each
variable over all of the records for that subject and activity.
That is, the submission for part 5 of the assignment.
The function call acheiving this is
```{r}
averagedTidyData <- aggregate(. ~ subject.id + activity, data = tidyData, mean)
```

This data frame still has the same variables names as above, but the
last 66 variables ('tBodyAcc.mean.X' through to 'fBodyBodyGyroJerkMag.std')
are now averages. See the above subsection for that meaning of these
variable names.

## Notes

Using the data.table format instead of data.frame might have been faster,
but on my system this persistently crashed when trying to read in the
raw data. This may be realted to the presence of leading spaces in the
data file. See this thread: https://github.com/Rdatatable/data.table/issues/956

The variable names are taken from the 'features.txt' file, but hyphens are
replaced with periods and parentheses removed.

The data did not contain any missing values, so no scheme to handle NAs
has been implemented.

The subject.id variable is converted from int to factor to discourage
the user from attributing any meaning to the numerical values.

The raw accelerometer data in the 'Inertial Signals' directories is not used.
Only the means and standard deviations (in the X_test.txt and X_train.txt
files) are used.
