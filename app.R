# Pocket dictionary

# prepare environment
quickcode::clean()
quickcode::libraryAll(shiny, nextGenShinyApps, shinyjs, shinyStorePlus, r2dictionary, clear = FALSE)

# app.version
app.version <- 0.1

# A simple lookup function
lookup <- function(word) {
  return(define(word,printResult=F))
}

# application UI object

ui <- fluidPage(
  # Theme: Select color style from 1-13
  style = "7",

  # add custom background
  # custom.bg.color = "brown",

  # add scripts
  tags$head(
    tags$script(src = "script.js"),
    tags$link(rel = "stylesheet", href = "style.css")
  ),

  # Header: Insert header content using titlePanel ------------
  header = titlePanel(left = paste0("Shiny English Pocket Dictionary v",app.version), right = "@obinnaObianom"),
  useShinyjs(), #use shiny js
  initStore(), #use shinyStorePlus

    column(
      width = 12,

      card(
        title = "Word to define",
        textInput("word", "Enter a word to define:", "food"),
        ),
      card(
        title = "Meaning",
        verbatimTextOutput("meaning")
      ),br(),
      downloadButton("downloadData", "Download", style="background-color: #666!important; color: white; padding: 14px!important; border-width: 1px; border-radius: 0px; background: unset;"),

    )
)





# application Server function

server <- function(input, output, session) {
  # Declare variable to hold results
  resultsVar <- reactiveVal("Nothing to define.")



  # look up word
  output$meaning <- renderText({

    # Get the input word
    word <- input$word
    if(not.null(word)){
      res <- lookup(word)
      resultsVar(res)

      res
    }

  })


  # download it
  output$downloadData <- downloadHandler(
    filename = function() {
      # Use the selected dataset as the suggested file name
      paste0("definition_",Sys.Date(), "_data.doc")
    },
    content = function(file) {
      # Write the dataset to the `file` that will be downloaded
      writeLines(resultsVar(), file)
    }
  )

  #insert at the bottom  !!!IMPORTANT
  appid = "definesentence1app"
  setupStorage(appId = appid,inputs = TRUE)

}



shinyApp(ui, server)
