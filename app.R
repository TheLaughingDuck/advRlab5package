# Load the Shiny library
library(shiny)
library(thenerdyclient)

# Define the UI (User Interface)
ui <- fluidPage(
  titlePanel("View quotes filtered by character and movie in the Lord of the Rings universe"),
  sidebarLayout(
    sidebarPanel(
      textInput("character", "Specify a character:", value="Frodo Baggins"),
      textInput("movie", "Specify a movie:", value="Return")
    ),
    mainPanel(tableOutput("filtered_quotes"))
  )
)

server <- function(input, output) {
  output$filtered_quotes <- renderTable({
    thenerdyclient::get_quote_data(input$character, input$movie)
  })
}

# Create and run the Shiny app
shinyApp(ui, server)
