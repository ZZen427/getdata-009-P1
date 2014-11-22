##Variables
1. `subject`: a single `1:30` integer that represent human subject in the expriment.   
2. `activity.id`: a single `1:6` integer that corresponds to `activity.name` respectively, see below.
3. `activity.name`: one of six activity names "`WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, `LAYING`".   
4. `{Feature Variables}`: a collection of 66 feature variables extracted from the original _'features.txt'_. See **Feature Variables** section below.

##`{Feature Variables}`
All 66 feature variables contained in *'data\_mean.txt'* is a subset of feature variables from the original data set in _'features.txt'_, modified to work properly with `{data.table}`: 
- all `-` or `,` are replaced with `.`.
- `()` removed.

---
**Signal names**: These signals were used to estimate variables of the feature vector for each pattern. `.XYZ` is used to denote 3-axial signals in the X, Y and Z directions.

```
tBodyAcc.XYZ  
tGravityAcc.XYZ  
tBodyAccJerk.XYZ  
tBodyGyro.XYZ  
tBodyGyroJerk.XYZ  
tBodyAccMag  
tGravityAccMag  
tBodyAccJerkMag  
tBodyGyroMag  
tBodyGyroJerkMag  
fBodyAcc.XYZ  
fBodyAccJerk.XYZ  
fBodyGyro.XYZ  
fBodyAccMag  
fBodyAccJerkMag  
fBodyGyroMag  
fBodyGyroJerkMag  
```
**Estimation Variables**: variables that were estimated from these signals are: 
```
mean: Mean value
std: Standard deviation
```
A **feature name** is a combination of **signal names** with **estimation variables** connected with `.`.

Example **feature variables**:
```
tBodyGyroJerk.std.Y  
fBodyBodyGyroMag.mean  
tGravityAccMag.std   
```
A complete list of feature variables is available in 'feature_variables.txt'.