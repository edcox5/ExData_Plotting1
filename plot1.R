# Creates the first plot and saves it as a PNG file to the working directory

# Install (if necessary) and load the SQL Dataframe package
if (!require(sqldf)) install.packages('sqldf')
library(sqldf)

# Read all rows where Date = Feb 1 or Feb 2, 2007.  Note the column format is d/m/yyyy.
d <- read.csv.sql("household_power_consumption.txt", 
                  sep = ";",
                  header = TRUE, 
                  stringsAsFactors = FALSE,
                  sql = 'SELECT * FROM file WHERE Date = "1/2/2007" OR Date = "2/2/2007"')
# Close the SQL connection
closeAllConnections()

# Open a PNG device
png(file = "plot1.png", bg = "white", width = 480, height = 480)

# Create the plot, which will be sent to the active (PNG) device
hist(d$Global_active_power, 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency",
     col = "Red")

# Close PNG device
dev.off()
