## This script requires the "sqldf" package which can be
## installed using the command: > install.packages("sqldf")

## Check that the required package has been loaded
require("sqldf")

## Package contains an updated read.csv() function that
## allows filtering of the imported data va an SQL statement
sqlFilter <- "SELECT * FROM file WHERE Date='1/2/2007' OR Date='2/2/2007'"

## Set the classes of the imported data to reduce load times
## Date and Time fields imported as 'character' becuase the date
## is not one of the default formats
fieldClass <- c(rep("character", 2), rep("numeric", 7))

## Import the data using the SQL filter to limit the rows
## that are kept. Note that read.csv2.sql() did not work
## under Win7 (tested on 2 machines), so I used the standard
## read.csv.sql() version instead
powerData <- read.csv.sql("household_power_consumption.txt", sql = sqlFilter,
                          colClasses = fieldClass, sep = ";")
powerData$Date <- as.Date(powerData$Date, format = "%d/%m/%Y")
powerData$DateTime <- strptime(paste(powerData$Date, powerData$Time),
                               format = "%Y-%m-%d %H:%M:%S")

## Create a png image and output the plot to it
png("plot2.png", height = 480, width = 480)
par(bg = NA)
plot(powerData$DateTime, powerData$Global_active_power, type ="l",
     main = "", xlab = "", ylab = "Gloabl Active Power (kilowatts)")
dev.off()