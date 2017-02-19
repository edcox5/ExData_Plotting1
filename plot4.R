# Creates the fourth plot and saves it as a PNG file to the working directory

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
png(file = "plot4.png", bg = "white", width = 480, height = 480)

# Set option to combine multiple plots into a single graph
par(mfrow = c(2,2))

# Create the top left plot, which will be sent to the active (PNG) device
plot(d$DateTime, d$Global_active_power, type = "l", xlab="", ylab = "Global Active Power")

# Create the top right plot, which will be sent to the active (PNG) device
plot(d$DateTime, d$Voltage, type = "l", xlab="datetime", ylab = "Voltage")

# Create the bottom left plot, which will be sent to the active (PNG) device
plot(d$DateTime, d$Sub_metering_1, type = "l", xlab="", ylab = "Energy sub metering", col = "black")

# Overlay Sub_metering_2 and Sub_metering_3 lines
points(d$DateTime, d$Sub_metering_2, type = "l", col = "red")
points(d$DateTime, d$Sub_metering_3, type = "l", col = "blue")

# Add the legend
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = c(1, 1, 1),
       col = c("black", "red", "blue"))


# Create the bottom right plot, which will be sent to the active (PNG) device
plot(d$DateTime, d$Global_reactive_power, type = "l", xlab="datetime", ylab = "Global_reactive_power")

# Close PNG device
dev.off()
