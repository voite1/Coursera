# Question 4:
# Across the United States, how have emissions from coal combustion-related sources changed 
# from 1999-2008?

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

# Find subset of valuse containing 'coal' and stroring results in the data.frame
tmp <- grep("coal", SCC$Short.Name, ignore.case=T)
COAL <- SCC[tmp,]

# Merge NEI and COAL by SCC column
m <- merge(x=NEI, y=COAL, by="SCC")

# Aggregating emmissues by year for coal sources
em <- aggregate(m[, "Emissions"], by=list(m$year), sum)

# Assign column names
colnames(em) <- c("Year", "Emissions")

# Generate graphics
library(ggplot2)
png("plot4.png", width=480, height=480)
graphics <- ggplot(em, aes(x=Year, y=Emissions)) +
  ggtitle("Total" ~ PM[2.5] ~ "Coal Burning Emissions in the US") +
  ylab(expression(paste(PM[2.5] ~ "(tons)"))) +
  geom_smooth(alpha=.5, size=0.7, method="loess") + 
  geom_point(alpha=1) +
  geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=2)) +
  theme(legend.position='none')
suppressWarnings(print(graphics))
dev.off()

