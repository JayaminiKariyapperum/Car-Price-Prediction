library(shiny)
library(caret)
library(ggplot2)

# Load the dataset
data <- read.csv("used_cars.csv", TRUE, stringsAsFactors = FALSE)

# Preprocess the dataset
data$price <- as.numeric(gsub(",", "", data$price))
data$kilometers_driven <- as.numeric(gsub(",", "", data$kilometers_driven))
data$company <- as.factor(data$brand)

ui <- fluidPage(
  titlePanel(""),
  tags$head(
    tags$style(HTML("
                    .container {
                      width: 800px;
                      margin: auto;
                      padding: 10px;
                      box-shadow: 0px 0px 10px #000000;
                    }
                    .title {
                      text-align: center;
                      font-size: 24px;
                      font-weight: bold;
                      padding: 10px;
                    }
                    .sidebar {
                      padding: 10px;
                      background-color: #f0f0f0;
                      border-radius: 5px;
                      background-color: #f4b943;
                    }
                    .main-panel {
                      padding: 10px;
                      background-color: #f0f0f0;
                      border-radius: 5px;
                      font-size: 24px;
                      font-weight: bold;
                      padding: 10px;
                      text-align: center;
                      font-family: Arial, sans-serif !important;
                      color: red;
                    }
                    .error-message {
                      color: red;
                      font-weight: bold;
                    }
                    .plot-title {
                      text-align: center;
                      font-size: 18px;
                      font-weight: bold;
                      padding: 10px;
                    }
                    "))
  ),
  div(class = "container",
      div(class = "title", "Used Car Price Prediction"),
      div(class = "sidebar",
          selectInput("company", "Company", choices = unique(data$company)),
          uiOutput("mode_select"),
          numericInput("year", "Year", value = 2010, min = 1990, max = 2024),
          numericInput("kms_driven", "Kms Driven", value = 10000, min = 0),
          selectInput("fuel_type", "Fuel Type", choices = unique(data$fuel_type)),
          textOutput("error_message"),
          actionButton("predict", "Predict Price")
      ),
      div(class = "main-panel",
          textOutput("prediction_text"),
          plotOutput("price_fluctuation_plot") # Add plot output
      )
  )
)

server <- function(input, output, session) {
  # Train the model
  model <- train(price ~ mode + company + year + kilometers_driven + fuel_type, data = data, method = "lm")
  
  # Error message when model and company do not match
  model_company_match <- reactive({
    !is.null(data[data$mode == input$mode & data$company == input$company, ])
  })
  
  observeEvent(input$company, {
    relevant_modes <- unique(data$mode[data$company == input$company])
    output$mode_select <- renderUI({
      selectInput("mode", "Model", choices = relevant_modes)
    })
  })
  
  observeEvent(model_company_match(), {
    if (!model_company_match()) {
      output$error_message <- renderText("Error: The car model and company do not match any records in the dataset.")
    } else {
      output$error_message <- renderText("")
    }
  })
  
  # Make predictions 
  
  output$prediction_text <- renderText({
    
    if (input$predict > 0 && model_company_match()) {
      
      new_data <- data.frame(mode = input$mode, company = input$company, year = input$year, kilometers_driven = input$kms_driven, fuel_type = input$fuel_type)
      
      prediction <- predict(model, newdata = new_data)
      
      exchange_rate <- 0.27  # Define exchange rate here
      
      prediction_in_lkr <- prediction / exchange_rate
      
      paste("Predicted Price : ", round(prediction_in_lkr, 2), " Lakhs")
      
    }
    
  })
  
  # Generate plot for price fluctuation
  output$price_fluctuation_plot <- renderPlot({
    if (!is.null(input$mode)) {
      mode_data <- data[data$mode == input$mode, ]
      ggplot(mode_data, aes(x = year, y = price)) +
        geom_line() +
        labs(title = "Price Fluctuation of Selected Car Model", x = "Year", y = "Price (in Lakhs)") +
        theme(plot.title = element_text(size = 18, face = "bold"))
    }
  })
}

shinyApp(ui, server)