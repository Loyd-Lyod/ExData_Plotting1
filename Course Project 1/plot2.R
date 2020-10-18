library(dplyr)
library(lubridate)
currentdir <- "./data"
if(!dir.exists("./data")) dir.create("./data")
setwd(currentdir)

downloadurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfile <- "household_power_consumption.zip"
download.file(downloadurl, zipfile)

if(file.exists(zipfile)) unzip(zipfile)

hpcfile = "household_power_consumption.txt"
sapply(hpcfile, function(f) if(!file.exists(f)) stop(paste("Needed file ", f, " doesn't exist. Exitting ...", sep="")))

##Reading Table
hpc <- read.table(hpcfile, header=TRUE, sep=";", na.strings = "?", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))
##Setting Date column as Date Class
hpc$Date <- dmy(hpc$Date)
hpcmain <- subset(hpc,Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))
hpcmain <- hpcmain[complete.cases(hpcmain),]

##Combining Date and Time Column for easier 
dateTime <- paste(hpcmain$Date, hpcmain$Time)
dateTime <- setNames(dateTime, "DateTime")
hpcmain <- hpcmain[ ,!(names(hpcmain) %in% c("Date","Time"))]
hpcmain <- cbind(dateTime, hpcmain)
hpcmain$dateTime <- as.POSIXct(dateTime)

### Plot 2
plot(hpcmain$Global_active_power~hpcmain$dateTime, type="l", ylab="Global Active Power (kilowatts)", xlab="")

##Saving to plot2.png
dev.copy(png,"plot2.png", width=480, height=480)
dev.off()