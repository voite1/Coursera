# Question 6:
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
# sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes 
# over time in motor vehicle emissions?

# If you are to run this script, make sure ggplot2, grid, and gridExtra packages are installed.

# Check if data directory exists
if (file.exists("./data")) {
  print ("./data Directory Exists")
} else {
  dir.create(file.path(".", "data"))
  print ("Created ./data directory")
}

# Check if data files already downloaded
if (file.exists("data/summarySCC_PM25.rds") & file.exists("data/Source_Classification_Code.rds")) {
  print ("Using existing summarySCC_PM25.rds and Source_Classification_Code.rds")
} else {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url, "./data/temp.zip")
  # Unzipping file
  unzip("./data/temp.zip")
  # Movile files to the data directory
  file.copy(c("Source_Classification_Code.rds","summarySCC_PM25.rds"), "./data")
  file.remove(c("Source_Classification_Code.rds","summarySCC_PM25.rds"))
  print ("Downloaded and unzipped the summarySCC_PM25.rds and Source_Classification_Code.rds files")
}

# Reading the data files
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Isolate emissions per city
ba.em <- subset(NEI, fips=="24510" & type=="ON-ROAD")
la.em <- subset(NEI, fips=="06037" & type=="ON-ROAD")

# Aggregate data per city
ba <- aggregate(ba.em[, "Emissions"], by=list(ba.em$year), sum)
la <- aggregate(la.em[, "Emissions"], by=list(la.em$year), sum)

# Change columng names
colnames(ba) <- c("Year", "Emissions")
colnames(la) <- c("Year", "Emissions")

# load graphing libraries
library(ggplot2)
library(grid)
library(gridExtra)

# Plot multiple graphics with ggplot2 using grid.arrange function
png("plot6.png", width=960, height=480)
# Create a plot for Baltimore
graphics1 <- ggplot(ba, aes(x=Year, y=Emissions)) +
  geom_smooth(alpha=.2, size=0.7, method="loess") + 
  geom_point(alpha=1) +
  ylab(expression(paste(PM[2.5] ~ "(tons)"))) +
  ggtitle("Total Baltimore" ~ PM[2.5] ~ "Emissions")
# Create a plot for Lost angeles
graphics2 <- ggplot(la, aes(x=Year, y=Emissions)) +
  geom_smooth(alpha=.2, size=0.7, method="loess") + 
  geom_point(alpha=1) +
  ylab(expression(paste(PM[2.5] ~ "(tons)"))) +
  ggtitle("Total Los Angeles" ~ PM[2.5] ~ "Emissions")
# Printing plots side by side using grid.arrange() function
grid.arrange(graphics1, graphics2, ncol=2, main="Comparison of Baltimore and Los Angeles")
dev.off()

