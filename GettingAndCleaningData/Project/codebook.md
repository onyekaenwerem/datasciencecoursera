---
title: "CodeBook"
author: "Onyeka Enwerem"
date: "December 23, 2016"
output: html_document
---

Codebook
========
Codebook was generated on 2016-12-25 15:47:14 

Variable list and descriptions
------------------------------

Variable name  | Description
----------------|------------
subject        | ID of the subject who performed the activity for each window sample. Its range is from 1 to 30.
activity       | Activity name
domain         | Feature: Time domain signal or frequency domain signal (Time or Freq)
instrument     | Feature: Measuring instrument (Accelerometer or Gyroscope)
acceleration   | Feature: Acceleration signal (Body or Gravity)
variable       | Feature: Variable (Mean or SD)
jerk           | Feature: Jerk signal
magnitude      | Feature: Magnitude of the signals calculated using the Euclidean norm
axis           | Feature: 3-axial signals in the X, Y and Z directions (X, Y, or Z)
count          | Feature: Count of data points used to compute `average`
average        | Feature: Average of each variable for each activity and each subject

Dataset structure
-----------------

```r
library(knitr)
```



```r
str(dtTidy)
```

```
## Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	11880 obs. of  11 variables:
##  $ subject     : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity    : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ domain      : Factor w/ 2 levels "time","freq": 1 1 1 1 1 1 1 1 1 1 ...
##  $ acceleration: Factor w/ 3 levels NA,"body","gravity": 1 1 1 1 1 1 1 1 1 1 ...
##  $ instrument  : Factor w/ 2 levels "accelerometer",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ jerk        : Factor w/ 2 levels NA,"jerk": 1 1 1 1 1 1 1 1 2 2 ...
##  $ magnitude   : Factor w/ 2 levels NA,"magnitude": 1 1 1 1 1 1 2 2 1 1 ...
##  $ variable    : Factor w/ 2 levels "mean","sd": 1 1 1 2 2 2 1 2 1 1 ...
##  $ axis        : Factor w/ 4 levels NA,"x","y","z": 2 3 4 2 3 4 1 1 2 3 ...
##  $ count       : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ average     : num  -0.0166 -0.0645 0.1487 -0.8735 -0.9511 ...
##  - attr(*, ".internal.selfref")=<externalptr> 
##  - attr(*, "sorted")= chr  "subject" "activity" "domain" "acceleration" ...
##  - attr(*, "vars")=List of 8
##   ..$ : symbol subject
##   ..$ : symbol activity
##   ..$ : symbol domain
##   ..$ : symbol acceleration
##   ..$ : symbol instrument
##   ..$ : symbol jerk
##   ..$ : symbol magnitude
##   ..$ : symbol variable
##  - attr(*, "drop")= logi TRUE
```

List the key variables in the data table
----------------------------------------


```r
key(dtTidy)
```

```
## [1] "subject"      "activity"     "domain"       "acceleration"
## [5] "instrument"   "jerk"         "magnitude"    "variable"    
## [9] "axis"
```

Show a few rows of the dataset
------------------------------


```r
dtTidy
```

```
## Source: local data frame [11,880 x 11]
## Groups: subject, activity, domain, acceleration, instrument, jerk, magnitude, variable [?]
## 
##    subject activity domain acceleration instrument   jerk magnitude
##      <int>   <fctr> <fctr>       <fctr>     <fctr> <fctr>    <fctr>
## 1        1   LAYING   time           NA  gyroscope     NA        NA
## 2        1   LAYING   time           NA  gyroscope     NA        NA
## 3        1   LAYING   time           NA  gyroscope     NA        NA
## 4        1   LAYING   time           NA  gyroscope     NA        NA
## 5        1   LAYING   time           NA  gyroscope     NA        NA
## 6        1   LAYING   time           NA  gyroscope     NA        NA
## 7        1   LAYING   time           NA  gyroscope     NA magnitude
## 8        1   LAYING   time           NA  gyroscope     NA magnitude
## 9        1   LAYING   time           NA  gyroscope   jerk        NA
## 10       1   LAYING   time           NA  gyroscope   jerk        NA
## # ... with 11,870 more rows, and 4 more variables: variable <fctr>,
## #   axis <fctr>, count <int>, average <dbl>
```


Summary of variables
--------------------


```r
summary(dtTidy)
```

```
##     subject                   activity     domain      acceleration 
##  Min.   : 1.0   LAYING            :1980   time:7200   NA     :4680  
##  1st Qu.: 8.0   SITTING           :1980   freq:4680   body   :5760  
##  Median :15.5   STANDING          :1980               gravity:1440  
##  Mean   :15.5   WALKING           :1980                             
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1980                             
##  Max.   :30.0   WALKING_UPSTAIRS  :1980                             
##          instrument     jerk          magnitude    variable    axis     
##  accelerometer:7200   NA  :7200   NA       :8640   mean:5940   NA:3240  
##  gyroscope    :4680   jerk:4680   magnitude:3240   sd  :5940   x :2880  
##                                                                y :2880  
##                                                                z :2880  
##                                                                         
##                                                                         
##      count          average        
##  Min.   :36.00   Min.   :-0.99767  
##  1st Qu.:49.00   1st Qu.:-0.96205  
##  Median :54.50   Median :-0.46989  
##  Mean   :57.22   Mean   :-0.48436  
##  3rd Qu.:63.25   3rd Qu.:-0.07836  
##  Max.   :95.00   Max.   : 0.97451
```


