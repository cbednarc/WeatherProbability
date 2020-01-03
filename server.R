
library(shiny)

library(data.table)

inputFile = "weatherData_slim.csv"
stationNamesFile = "stationNames.csv"
wxdata = fread(inputFile)
stations = fread(stationNamesFile, sep=",")
# Change TAVG to be average of TMAX and TMIN
wxdata[,TAVG:=(TMIN+TMAX)/2]
# Assign city to each entry
for (i in 1:nrow(stations)) {
     wxdata[STATION==stations$STATION[i],City:=stations$CITY[i]]
}
# Format Date and create Month and Day fields
wxdata[,Date:=as.Date(DATE)]
wxdata[,`:=`(Month=as.integer(format(Date,"%m")),Day=as.integer(format(Date,"%d")))]
# Only keep specific columns
wxdata = wxdata[,.(City,Month,Day,TAVG)]
# Remove rows with NAs for TAVG
wxdata = wxdata[!is.na(TAVG),]

ymin = 10
ymax = 95

shinyServer(function(input, output) {
     
  output$distPlot <- renderPlot({
     x = wxdata[City==input$city & Month==input$month & Day==input$day,TAVG]
     if (length(x) > 0 & input$tempLow < input$tempHigh) {
          boxplot(x, ylim=c(ymin,ymax), ylab="Average Temperature (deg F)", main=paste0("Distribution of Average Temperature\nMonth ",input$month," , Day ",input$day,", ",input$city))
          abline(h=input$tempLow, col="blue", lwd=3)
          text(0.5, input$tempLow-5, input$tempLow, col="blue", adj=0)
          abline(h=input$tempHigh, col="red", lwd=3)
          text(0.5, input$tempHigh+5, input$tempHigh, col="red", adj=0)
          probComfort = round(100*sum(x>=input$tempLow & x<=input$tempHigh)/length(x), 0)
          text(0.5, ymax, paste0("Probability of\nBeing Comfortable: ",probComfort,"%"), adj=c(0,1))
     }
  })
  
})
