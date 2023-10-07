# Load the Shiny library
library(shiny)
library(httr)

# Define the UI (User Interface)
ui <- fluidPage(
  titlePanel("Actor Movie Selector"),
  sidebarLayout(
    sidebarPanel(
      selectInput("actor", "Select an actor:", choices = c("Frodo", "Gandalf", "Actor 3")),
      br(),
      textOutput("selected_movies")
    ),
    mainPanel()
  )
)

server <- function(input, output) {
  output$selected_movies <- renderText({
    selected_actor <- input$actor
    
    # Define the API endpoint and API key
    api_url <- "https://the-one-api.dev/v2/movie"
    api_key <- ""
    
    # Set up headers with API key
    headers <- add_headers("Authorization" = paste("Bearer", api_key))
    
    
    # Make a GET request to the API
    response <- GET(api_url, headers = headers)
    
    # Check if the request was successful
    if (http_status(response)$status == 200) {
      # Parse the JSON response
      movie_data <- content(response, "parsed")
      
      # Print the structure of the movie_data object for debugging
      print(str(movie_data))
      
      # Check if the selected actor is in the API response
      if (selected_actor %in% movie_data$data$actors) {
        # Filter movies by the selected actor
        actor_movies <- movie_data$data[movie_data$data$actors == selected_actor, "name"]
        
        if (length(actor_movies) == 0) {
          return(paste("No movies found for", selected_actor))
        } else {
          return(paste("Movies for", selected_actor, ":", paste(actor_movies, collapse = ", ")))
        }
      } else {
        return(paste("Actor", selected_actor, "not found in the API data"))
      }
    } else {
      return(paste("Error: Unable to fetch movie data from the API. Status code:", http_status(response)$status))
    }
  })
}

# Create and run the Shiny app
shinyApp(ui, server)
