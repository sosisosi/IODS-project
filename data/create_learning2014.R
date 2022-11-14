"Sonja Silvennoinen"
date()
"Mon Nov 14 20:13:02 2022"
"1st data wrangling assignment"

library(tidyverse)

# Read the full learning2014 data
# read the data into memory
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Look at the dimensions of the data
dim(lrn14)
# dimensions gives the number of observations (rows) and variables (columns) of a data frame
# the learning2014 data frame has a total of 183 rows and  60 columns

# Look at the structure of the data
str(lrn14)
# structure gives the variable types of each column and the first 10 values on that column
# the learning2014 data frame has all other column data stored as integers (number), and the gender column data stored as character

#scaling the attitude combination variable to the original scale
lrn14$attitude <- lrn14$Attitude / 10

# picking the deep questions and adding them to a object
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")

#creating a combination variable from the mean of the deep questions, adding it to the data frame 
lrn14$deep <- rowMeans(lrn14[, deep_questions])

# same thing for surface and strategic questions
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
lrn14$surf <- rowMeans(lrn14[, surface_questions])
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
lrn14$stra <- rowMeans(lrn14[, strategic_questions])

#create a new dataset for analysis with only selected variables, modifying the variable names to match
learning2014 <- lrn14[, c("gender","Age","attitude", "deep", "stra", "surf", "Points")]
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

# select rows where points is greater than zero
learning2014 <- filter(learning2014, points > 0)

#storing the created, filtered dataset in the data folder as a .csv
write.csv(learning2014, "data/learning2014.csv", row.names = FALSE)

#reading in the created .csv to check everything went ok
checklearning2014 <- read.csv("data/learning2014.csv")

# making sure the structure is right
str(checklearning2014)
# the created learning2014.csv file includes 166 observations (rows) and 7 variables (columns), 
#gender stored as character, age and points stored as integer, the rest stored as numbers

# making sure the structure is right
head(checklearning2014)
# checking the header and first 6 rows of the data frame, all seems to be fine

