if (!getwd() == "C:/Users/Aleksey/Documents/GitHub/Exploratory_Data_Analysis/Week_1") {
  setwd("C:/Users/Aleksey/Documents/GitHub/Exploratory_Data_Analysis/Week_1")
}

# Download zipped source file from the url specified
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              "temp.zip")

# Unzip the file
unzip("temp.zip")

# read the file in the memory with header, separator, na.strings, and stringsAsFactors set up
temp <- read.csv("household_power_consumption.txt", header=T, sep=';', na.strings="?", stringsAsFactors=F, )

# remove the text file
file.remove("household_power_consumption.txt")

# set temp$Date column as date data type
temp$Date <- as.Date(temp$Date, format="%d/%m/%Y")

# subset only three days needed into data variable
data <- subset(temp, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))

# remove original file from memory
rm(temp)

# Create a variable called Datetime and add it to the 'data' data frame
dtime <- paste(data$Date, data$Time)
data$Datetime <- as.POSIXct(dtime)

# remove temporary vector
rm(dtime)

# copy resulting graphics to the png device
png("plot4.png", width=480, height=480)

# build graphics with 4 different graphs in it, giving each graph exactly the same
# lables, colors, and appearance as of those sample files provided
par(mfrow=c(2,2), mar=c(4,4,2,2))
with(data, {
    plot(Global_active_power~Datetime, type="l", ylab="Global Active Power", xlab="")
    plot(Voltage~Datetime, type="l", ylab="Voltage", xlab="")
    plot(Sub_metering_1~Datetime, type="l", ylab="Global sub metring", xlab="")
    lines(Sub_metering_2~Datetime,col='red')
    lines(Sub_metering_3~Datetime,col='blue')
    legend("topright", col=c("black", "red", "blue"), lty=1, 
           lwd=2, bty="n", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(Global_reactive_power~Datetime, type="l", ylab="Global_rective_power",xlab="")
})

# close png device
dev.off()

# remove 'data' data frame from memory
rm(data)