#Sonja Silvennoinen"
date()
#Mon Nov 21 18:59:35 2022
#A script for reading in and combining 2 data sets of Student performance in secondary education mathematics and portugese of two Portuguese schools.
#Data sets can be accessed here: https://archive.ics.uci.edu/ml/datasets/Student+Performance

library(tidyverse)
library(dplyr)

# Read the 2 data sets into memory
math <- read.table("data/student-mat.csv", sep=";", header=TRUE)
por <- read.table("data/student-por.csv", sep=";", header=TRUE)

# Look at the dimensions of the data sets
dim(math)
# the math data frame has a total of 395 observations (rows) and 33  variables (columns).
dim(por)
# the portugese data frame has a total of 649 rows and  33 columns

# Look at the structure of the data sets
# structure gives the variable types of each column and the first 10 values on that column
str(math) 
str(por)
# Both data frames have 16 variables stores as integers (number) and 17 variables stored as character

# Combining the data sets by defining the combining variables used as student identifiers

# Define the columns that vary in the data sets as a vector:
free_cols <- c("failures","paid","absences","G1","G2","G3")
# Define the rest of the columns as common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)
# Combine the data sets into a single data frame 
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))
# Create a new data frame with only the joined columns so only the students present in both data sets are kept
alc <- select(math_por, all_of(join_cols))

#Explore the structure and dimensions of the joined data
dim(alc)
str(alc)

# the combined data frame has a total of 370 observations and  27 variables
# the combined data frame has 11 variables stores as integers (number) and 16 variables stored as character


# Get rid of the duplicate records in the joined data set by taking the rounded average of numerical variables 
# and otherwise saving only the first answer
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

# Define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
# Define a new logical column 'high_use' when alc_use is higher than 2
alc <- mutate(alc, high_use = alc_use > 2)

# Making sure everything is in order
glimpse(alc)

# The alcohol use dataset has now 370 rows and 35 columns consisting of numerical and character data 
# as well as 1 logical variable (high alcohol use  = TRUE/FALSE)
# the numerical records that got combined are now stored as double, other numerical records are stored as integer

# Saving the created, combined dataset in the data folder as a .csv
write.csv(alc, "data/alc.csv", row.names = FALSE)
