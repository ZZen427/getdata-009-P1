##Files
run\_analysis.R script
README.md markdown document
codebook.md Codebook markdown document
A tidy data text file (this last goes on Coursera)

##Reading Data Strategy
Since this project (step 2) only interested in extracting "measurements on the mean and standard deviation for each measurement", which are inside the 561-feature vector. Therefore all the raw signals inside "Inertial Signals" directory can be skipped when creating the dataset. 

To let the R script run properly, run\_analysis.R script must be in the same directory as the data file. The name of the .zip data file must be "getdata-projectfiles-UCI HAR Dataset.zip" and the unzipped directory name must remain to be "UCI HAR Dataset". The script would look for these names when reading in the data.

##File Details:
The "test" or "train" directories contains:  
**Note:** \* is wildcard character that can be either "test" or "train" strings.  
- "Inertial Signals" directory:  
  It contains all the raw signals: Triaxial acceleration from the accelerometer (total acceleration); the estimated body acceleration; Triaxial Angular velocity from the gyroscope.
- subject\_\*.txt:  
  An identifier of the subject who carried out the experiment.
- X\_\*.txt:  
  A 561-feature vector with time and frequency domain variables.
- y\_\*.txt:  
  activity labels corresponding to each row in X\_\*.txt  



The X\_test.txt or X\_train.txt contains the 561-feature vector

##code for reading the file back into R
