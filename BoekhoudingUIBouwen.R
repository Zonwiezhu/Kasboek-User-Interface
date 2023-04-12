library(shiny)
library(readxl)

# Define UI for app that input accountancy ----
ui <- fluidPage(
  # App title ----
  titlePanel(h3("Kasboek", align = "center")),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(h4("Voer hier alle gegevens in:", align = "center"),
                 textInput("datum", h4("Voer hier uw datum in", align = "center"), value = "12-04-2023"),
                 #textInput("omschrijving", h4("Voer hier uw omschrijving in", align = "center"), value = "Acapuntuur"),
                 #textInput("inkomsten", h4("Voer hier uw inkomsten in", align = "center"), value = "€ 0"),
                 #textInput("uitgaven", h4("Voer hier uw uitgaven in", align = "center"), value = "€ 0"),
                 actionButton("submit", "Uitvoeren")),
                
    # Main panel for displaying outputs ----
    mainPanel(column(12,
                     tableOutput('table'))
    ),
  )
)

# Define server logic required ----
server <- function(input, output, session) {
  # Read the file.
  df <- reactiveVal(data.frame(Datum = character(),
                               Omschrijving = character(),
                               Inkomsten = integer(),
                               Uitgaven = integer()))
  
  observeEvent(input$submit, {
    
    # Create new data frame and update reactive value
    new_dat <- rbind(df(), data.frame(Datum =input$datum, 
                                      Omschrijving = input$omschrijving, 
                                      Inkomsten = input$inkomsten, 
                                      Uitgaven = input$uitgaven))
   
    df(new_dat)

    # Clear input fields
    updateTextInput(session, "datum", value = "")
    updateTextInput(session, "omschrijving", value = "")
    updateTextInput(session, "inkomsten", value = "€ ")
    updateTextInput(session, "uitgaven", value = "€ ")
  })
  
  output$table <- renderTable({
    df()   
  })
}
# Run the app ----
shinyApp(ui = ui, server = server)
