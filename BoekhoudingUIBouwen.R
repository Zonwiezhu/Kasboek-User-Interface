library(shiny)
library(readxl)
library(shinyWidgets)

# Define UI for app that input accountancy ----
ui <- fluidPage(
  # App title ----
  titlePanel(h3("Kasboek Yang Sheng Guang", align = "center")),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(align = "center",
                h4(textOutput("bericht")),
                div(style = "height:10px"),

                h4(textOutput("bericht2")),
                div(style = "height:10px"),

                h4(textOutput("bericht3")),
                div(style = "height:10px"),

                h4("Voer hier alle gegevens in:"),
                div(style = "height:10px"),

                selectInput(
                  inputId = "Dagen",
                  label = "Dagen",
                  choices = 1:31,
                ),
                div(style = "height:5px"),
                selectInput(
                  inputId = "Omschrijvingen", 
                  label = "Omschrijving:",
                  choices = c("Acupuntuur","Benzine","OV","Kruiden","Overmaken voor acupuntuur","Invoer"),
                ),
                div(style = "height:5px"),
                currencyInput(
                  inputId = "Inkomsten",
                  label = "Voer hier uw inkomsten in:",
                  value = "0",
                  format = "euro",
                ),
                div(style = "height:5px"),
                currencyInput(
                  inputId = "Uitgaven",
                  label = "Voer hier uw uitgaven in:",
                  value = "0",
                  format = "euro",
                ),
                div(style = "height:5px"),
                 actionButton("submit", "Uitvoeren")),
                
    # Main panel for displaying outputs ----
    mainPanel(
      modalDialog(
           title = "Kasboek Yang Sheng Guang",
           size = "m",
           easyClose = FALSE,
           align = "center",
           footer = modalButton("Opslaan"),
          selectInput(
            inputId =  "date_from_year", 
            label = "Selecteer jaar:", 
            choices = 2023:2100),
          selectInput(
            inputId =  "date_from_month", 
            label = "Selecteer maand:", 
            choices = 1:12),
          currencyInput(
            inputId = "Begin_saldo",
            label = "Begin saldo:",
            value = "0",
            format = "euro",
          )),

      column(12,tableOutput('table'))
    ),
  )
)

# Define server logic required ----
server <- function(input, output, session) {
  
  df <- reactiveVal(data.frame(Dagen = integer(),
                               Omschrijvingen = character(),
                               Inkomsten = integer(),
                               Uitgaven = integer()))
  
  observeEvent(input$submit, {
    
    # Create new data frame and update reactive value
    new_dat <- rbind(df(), data.frame(Dagen =input$Dagen, 
                                      Omschrijvingen = input$Omschrijvingen, 
                                      Inkomsten = input$Inkomsten, 
                                      Uitgaven = input$Uitgaven))
   
    df(new_dat)

    # Clear input fields
    updateTextInput(session, "Dagen", value = "")
    updateTextInput(session, "Omschrijving", value = "")
    updateTextInput(session, "Inkomsten", value = "€ ")
    updateTextInput(session, "Uitgaven", value = "€ ")
  })

  output$bericht <- renderText({
    paste("Jaar:", input$date_from_year)
  })

  output$bericht2 <- renderText({
    paste("Maand:", input$date_from_month)
  })

  output$bericht3 <- renderText({
    paste("Begin saldo: €", input$Begin_saldo)
  })

  output$table <- renderTable({
    df()   
  })
}


# Run the app ----
shinyApp(ui = ui, server = server)
