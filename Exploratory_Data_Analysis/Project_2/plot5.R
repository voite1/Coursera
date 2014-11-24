# Question 5:
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 

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

# Isolate emissions from cars in baltimore
bc.onroad <- subset(NEI, type=="ON-ROAD" & fips=="24510")

# Aggregate emissions
em <- aggregate(bc.onroad[, "Emissions"], by=list(bc.onroad$year), sum)

# Assign column names
colnames(em) <- c("Year", "Emissions")

# Generate graphics
png("plot5.png", width=480, height=480)
library(ggplot2)
graphics <- ggplot(em, aes(x=Year, y=Emissions)) +
  ggtitle("Total" ~ PM[2.5] ~ "Emissions from Vehicles in Baltimore, MD") +
  ylab(expression(paste(PM[2.5] ~ "(tons)"))) +
  geom_smooth(alpha=.5, size=0.7, method="loess") + 
  geom_point(alpha=1) +
  geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=2)) +
  theme(legend.position='none')
suppressWarnings(print(graphics))
dev.off()
