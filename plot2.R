# Creates the second plot and saves it as a PNG file to the working directory

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

# Add new col DateTime that combines Date and Time cols and converts to POSIXlt
d$DateTime <- apply(d[,c("Date", "Time")], 1, function(r) {paste(r['Date'], r['Time'], sep = " ")})
d$DateTime <- strptime(d$DateTime, format = "%d/%m/%Y %H:%M:%S")

# Open a PNG device
png(file = "plot2.png", bg = "white", width = 480, height = 480)

# Create the plot, which will be sent to the active (PNG) device
plot(d$DateTime, d$Global_active_power, type = "l", xlab="", ylab = "Global Active Power (kilowatts)")

# Close PNG device
dev.off()
