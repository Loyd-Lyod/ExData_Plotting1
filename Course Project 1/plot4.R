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

### Plot 4
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(hpcmain, {
  plot(Global_active_power~dateTime, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="")
  plot(Voltage~dateTime, type="l", 
       ylab="Voltage (volt)", xlab="")
  plot(Sub_metering_1~dateTime, type="l", 
       ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~dateTime,col='Red')
  lines(Sub_metering_3~dateTime,col='Blue')
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), y.intersp=1)
  plot(Global_reactive_power~dateTime, type="l", 
       ylab="Global Rective Power (kilowatts)",xlab="")
})

##Saving to plot4.png
dev.copy(png,"plot4.png", width=480, height=480)
dev.off()