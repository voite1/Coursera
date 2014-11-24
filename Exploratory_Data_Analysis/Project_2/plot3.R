# Question 3:
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make 
# a plot answer this question.

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

# Isolating Baltimore
bc <- subset(NEI, fips == "24510")

# Aggregating by year and type
bc_1 <- aggregate(bc[, "Emissions"], list(year = bc$year, type = bc$type), sum)

# Assign column Names to bc_1
colnames(bc_1) <- c("Year", "Type", "Emissions")

# Load ggplot2 library
library(ggplot2)

# generating graph with ggplot2
png("plot3.png", width=480, height=480)
graphics <- ggplot(bc_1, aes(x=Year, y=Emissions, colour=Type)) +
  geom_smooth(alpha=.2, size=0.7, method="loess") + 
  geom_point(alpha=1) +
  ylab(expression(paste(PM[2.5] ~ "(tons)"))) +
  ggtitle("Total Baltimore" ~ PM[2.5] ~ "Emissions Annualized by Type")
suppressWarnings(print(graphics))
dev.off()

