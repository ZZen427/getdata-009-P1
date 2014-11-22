# PROJECT STEPS:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for
#    each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
#
# ACTUAL STEPS:
# The implementation switches step 1 & 2 to selectively read columns required
# by the step 2, thus improve memory usage and speed.
# The implementation switches step 3 & 4 b/c step 3 only involves merging once
# all the columns are named properly.
# =============================================================================

## Helper Functions
# Read all files w/ names defined by prefixes in a sepcific directory and read
# feature-vector file with columns sepecified in argument "col.classes".
# Note: dir must only be a char vector of length 1, this is a helper function
# to be used in a lapply loop.
DirToDF <- function(path = "", dir = "", prefixes = "", extension  = "",
                    col.classes) {
  check <- c(path, dir, prefixes, extension)
  # if there's empty input, stop the program
  if (sum(check != "") < length(check)) stop("invalid file path elements")
  # read all files defined by prefixes in directory dir
  df.list <- lapply(prefixes,
                    function(x) {
                      file <- paste(path, dir, "/", x, dir, extension, sep = "")
                      if (x == "X_") {
                        read.table(file, colClasses = col.classes)
                      } else {
                        read.table(file, colClasses = "numeric")
                      }
                    }
                    )
  return(do.call(cbind, df.list))
}

# ================================
# 0. Define constant variables specific to this data set:
library(data.table)

feat.file <- "./UCI HAR Dataset/features.txt"
activity.file <- "./UCI HAR Dataset/activity_labels.txt"
path <- "./UCI HAR Dataset/"
dirs <- c("test", "train")
file.prefixes <- c("subject_", "y_", "X_") # this's also the order of columns
file.extension <- ".txt"

# Data directory check, only unzip if file has not been unzipped yet.
if (!file.exists("UCI HAR Dataset/")) {
  unzip("getdata-projectfiles-UCI HAR Dataset.zip")  
}


# 1.1 Find the mean and standard deviation measurements in "features.txt" and
##    convert these feature names to descriptive variable(column) names for
##    later.
#
# Read all feature names into a dataframe.
feat <- read.table(feat.file, colClasses = c("integer", "character"))
# Slected feature names containing "-mean()" & "-std()" w/ regular expression.
feat.chosen <- grepl("(\\-mean\\(\\))|(\\-std\\(\\))", feat[[2]], perl = TRUE)
col.classes <- feat.chosen  # make a copy of feat.chosen
# columns marked "NULL" (not chosen in features) will be skipped when reading
# the data w/ read.table()
col.classes[col.classes == TRUE] <- "numeric"
col.classes[col.classes != "numeric"] <- "NULL"

# 1.2 Appropriately labels the data set with descriptive variable names. 
##    Remove "()" & substitute all "-" or "," w/ "." to fully take adavantage
##    of data.table's feature that all column names are treated as variables
##    for selecting columns intuitively and reliably.
##    see data.table Beginner FAQs 1.1 for more info:
##     http://datatable.r-forge.r-project.org/datatable-faq.pdf
#
# Convert column names (feature names) to descriptive & data.table friendly
# names w/ regular expression: 
# Remove "()" in variable feat.chosen
col.names <- feat[[2]][feat.chosen]
col.names <- gsub("\\(\\)", "", col.names, perl = TRUE)
# Substitute all "-" or "," with "."
col.names <- gsub("[-,]", ".", col.names, perl = TRUE)
# Substitue duplicating "." with a single "." (unlikely but just to make sure)
col.names <- gsub("(\\.+)", "\\.", col.names, perl = TRUE)
# Add subject & activity.id to match raw data set columns
col.names <- c("subject", "activity.id", col.names)

# 1.3 Merges the training and the test sets to create one data set.
df.list <- lapply(dirs,
                  function(x) DirToDF(path, x, file.prefixes, file.extension,
                                      col.classes))
# rbindlist() does the same as rbind() but much faster and returns a data.table
data.raw <- rbindlist(df.list)  

# 2. Appropriately labels the data set with descriptive variable names. 
setnames(data.raw, col.names)  # set raw data column names to descriptive names

# 3. Uses descriptive activity names to name the activities in the data set:
##   This is done by joining the raw data.table with a data.table containing
##   activity name and corresponding ID numbers.
#
# Read activity labels & create a dataframe for merge later
# Use fread{data.table} here because it'll be merged w/ a data.table later
activity.lab <- fread(activity.file)
setnames(activity.lab, c("activity.id", "activity.name"))
setkey(activity.lab, activity.id)  # sort the activity labs by its id
setkey(data.raw, subject)  # sort raw data by subject
data.new <- merge(data.raw, activity.lab, by = "activity.id")

# 4. Move activity.name column from the last to 3rd place, next to activity.id
col.names.old <- colnames(data.new)
col.names.new <- c(col.names.old[2:1], col.names.old[length(col.names.old)], 
                   col.names.old[c(-1:-2, -length(col.names.old))])
setcolorder(data.new, col.names.new)

# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
setkey(data.new, subject) # sort data set by subject
# Using data.table's powerful method to get the mean of each variables and
# arrange the result by subject then by activity.
data.mean <- data.new[, lapply(.SD, mean), by = list(subject, activity.id,
                                                     activity.name)]

# Export clean datatable to a text file
write.table(data.mean, file = "./data_mean.txt", row.names = F, col.names = T,
            sep = "\t", quote = F)
# Export column names to .txt file for use in codebook.md
write.table(colnames(data.new), file  = "./feature_variables.txt", row.names = F,
            col.names = F, quote = F, sep = "\n")
