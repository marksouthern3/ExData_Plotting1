# download, extract, and load the data
if (!file.exists("household_power_consumption.txt")) 
{
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "data.zip", method = "curl")
  unzip("data.zip")
  file.remove("data.zip")
}

powerData <- read.table("household_power_consumption.txt", sep = ";", header = TRUE)
powerData <- subset(powerData, powerData$Date == "1/2/2007" | powerData$Date == "2/2/2007")
powerData <- transform(powerData, datetime = paste(powerData$Date, powerData$Time))
powerData$datetime <- strptime(powerData$datetime, "%d/%m/%Y %H:%M:%S")
powerData$Time <- NULL
powerData$Date <- NULL
powerData <- transform(powerData, 
                       Global_active_power = as.numeric(powerData$Global_active_power),
                       Global_reactive_power = as.numeric(powerData$Global_reactive_power),
                       Voltage = as.numeric(powerData$Voltage),
                       Global_intensity = as.numeric(powerData$Global_intensity),
                       Sub_metering_1 = as.numeric(powerData$Sub_metering_1),
                       Sub_metering_2 = as.numeric(powerData$Sub_metering_2),
                       Sub_metering_3 = as.numeric(powerData$Sub_metering_3))

# create plots
png(filename = "plot4.png", height = 480, width = 480)
par(mfrow = c(2, 2))

#1
plot(powerData$datetime, powerData$Global_active_power, ylab = "Global Active Power", xlab = "", main = "", type = "n")
lines(powerData$datetime, powerData$Global_active_power)

#2
plot(powerData$datetime, powerData$Voltage, xlab = "datetime", ylab = "Voltage", main = "", type = "n")
lines(powerData$datetime, powerData$Voltage)

#3
plot(powerData$datetime, powerData$Sub_metering_1, ylab = "Energy sub metering", xlab = "", main = "", type = "n")
lines(powerData$datetime, powerData$Sub_metering_1)
lines(powerData$datetime, powerData$Sub_metering_2, col = "red")
lines(powerData$datetime, powerData$Sub_metering_3, col = "blue")
legend("topright", bty = "n", legend = c("sub_metering_1", "sub_metering_2", "sub_metering_3"), col = c("black", "red", "blue"), lty = c(1, 1))

#4
with(powerData, plot(datetime, Global_reactive_power, main = "", type = "n"))
lines(powerData$datetime, powerData$Global_reactive_power)

dev.off()