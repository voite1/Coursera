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

# save resulting graphics to the png device
png("plot3.png", width=480, height=480)

# plot the graph for Sub_metering_1~Datetime and add two lines to the graphics
with(data, { plot(Sub_metering_1~Datetime, type="l", ylab="Enerty sub metering", xlab="")
             lines(Sub_metering_2~Datetime,col='red')
             lines(Sub_metering_3~Datetime,col='blue')
})

# put the legend for the three variables graphed
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2,
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# close png device
dev.off()

# remove 'data' data frame from memory
rm(data)