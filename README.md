Getting and Cleaning Data: Peer Assignment
==========================================

Harry Braviner

This github repository is my submission for the Coursera assignment
that can be found at:
https://class.coursera.org/getdata-010/human_grading/view/courses/973497/assessments/3/submissions

## Scripts

This repository contains the following scripts:

* run_analysis.R

This script downloads the human activity monitoring dataset and unzips
it (unless the working directory already contains a directory
'data/UCI HAR Dataset').
It then form the data frames tidyData and averagedTidyData, as described
in the file 'Codebook.md'.
These are saved to the files 'tidyData.txt' and 'averagedTidyData.txt'
in CSV format.

## Data

This repository also contains the raw, zipped data

* data/rawData.zip

to reduce the load on the UCI server.
The files

* tidyData.txt
* averagedTidyData.txt

generated by running the run_analysis.R script on my machine are also
included.
