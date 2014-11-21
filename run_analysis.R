# STEPS:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for
#    each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
# =============================================================================

## Helper Functions
# Read all files w/ names defined by prefixes in a sepcific directory.
# Note: dir must only be a char vector of length 1, this is a helper function to be used in a lapply loop.
DirToDF <- function(path = "", dir = "", prefixes = "", extension  = "") {
  check <- c(path, dir, prefixes, extension)
  # if there's empty input, stop the program
  if (sum(check != "") < length(check)) stop("invalid file path elements")
  filenames <- paste(path, dir, "/", prefixes, dir, extension, sep = "")
  # read all files defined by prefixes in directory dir
  df.list <- lapply(filenames,
                    function(x) read.table(x, colClasses = "character"))
  return(do.call(cbind, df.list))
}


# extrac target 
#grepl("\\-mean\\(\\)|\\-std\\(\\)", x)


# 0. Define constant variables specific to this data set:
library(data.table)

path <- "./UCI HAR Dataset/"
dirs <- c("test", "train")
file.prefixes <- c("subject_", "X_", "y_")
file.extension <- ".txt"

# 1. Merges the training and the test sets to create one data set.
df.list <- lapply(dirs,
                  function(x) DirToDF(path, x, file.prefixes, file.extension))
# rbindlist() does what rbind() does but much faster
data.raw <- rbindlist(df.list)  

# 2. Extracts only the measurements on the mean and standard deviation for
#    each measurement. 

#  Read activity labels & create a dataframe for merge later
#activity.lab <- read.table()
