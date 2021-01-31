#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(plotly)

data_file = "sc_cases_by_zipcode.csv"
if (!file.exists(data_file)) {
    download.file('https://data.sccgov.org/api/views/hifm-rdvw/rows.csv?accessType=DOWNLOAD', data_file)
}
d <- read.csv(data_file)
d2 <- d[d$zcta == 95035, ]
d2$time_period = max(d2$time_period) - d2$time_period
plot_ly(d2, x=d2$time_period, y=d2$case.count, type="bar")

shinyServer(function(input, output) {
    x <- reactive({
        d2 <- d[d$zcta == input$zipcode, ]
        max(d2$time_period) - d2$time_period
    })
    y <- reactive({
        d2 <- d[d$zcta == input$zipcode, ]
        d2$case.count
    })
    t1 <- reactive({
        d2 <- d[d$zcta == input$zipcode, ]
        d2$start.date
    })
    output$casePlot <- renderPlotly(
        plot1 <- plot_ly(
            x = x(),
            y = y(), 
            text = t1(),
            type = 'bar')
    )
})
