# Question 2:
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.

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

# Aggregating emissions by year
em <- aggregate(bc[, "Emissions"], by=list(bc$year), FUN=sum)

# Assign names to colums of aggregated data
colnames(em) <- c("Year", "Total")

# Generate the grphics. Using expression() to generate subscript font for y-axis
png("plot2.png", width=480, height=480)
plot(em, type="l", ylab=expression("Total" ~ PM[2.5] ~ "Emissions in Tons"),
     main=expression("Total Baltimore" ~ PM[2.5] ~ "Emissions Annualized"))
dev.off()
