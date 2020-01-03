
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Probability of Comfortable Weather"),
  
  sidebarLayout(
     sidebarPanel(
          h5("Select a city and the month/day you want to visit. Then, input your range of temperatures you feel comfortable. The output will be the probability that you experience a comfortable temperature for the chosen month and day based on historical data."
          ),
          selectInput("city", "Select city:",
                      choices = c("New York","Los Angeles","Chicago","Miami","Philadelphia","Boston","Dallas","Houston","Washington","Atlanta")),
          selectInput("month", "Select month:", choices=1:12),
          selectInput("day", "Select day:", choices=1:31),
          numericInput("tempHigh", "Upper Limit on Comfortable Average Temperature (deg F):", 70),
          numericInput("tempLow", "Lower Limit on Comfortable Average Temperature (deg F):", 60)
     ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       h6("Red and blue lines represent input high and low temperatures defining the comfortable range. Boxplot shows distribution of average temperature for selected month and day from last 30 years.")
    )
  )
))
