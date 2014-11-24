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

# copy resulting graphics to the png device
png("plot1.png", width=480, height=480)

# build a histogram with appropriate labels and colors for data$Global_active_power variable
hist(data$Global_active_power, main="Global Active Power",
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

# close the png device
dev.off()

# remove data variable from memory
rm(data)