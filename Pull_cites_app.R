# Load R packages
library(shiny)
library(shinythemes)
library(dplyr)
library(stringr)
library(readtext)
library(XML)
library(data.table)

# Define UI
ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage(
                  theme = "cerulean",  # <--- To use a theme, uncomment this
                  "Extracting in-text citations app", #app title
                  tabPanel("",      # tab title
                           sidebarPanel(
                             # Input: Select a file ----
                             fileInput(inputId ="text1", "Choose File",
                                       multiple = FALSE,
                                       accept = c("text/plain",".doc",".docx",".pdf")),
                             p("Accepted Files: .doc, .docx, .pdf, text/plain"),
                             # Input: Select quotes ----
                             radioButtons("Sort", "Sort Method",
                                          choices = c("Alphabetical" = "Alphabetical",
                                                      "Chronological" = "Chronological"),
                                          selected = '"'),
                            ), # sidebarPanel
                                  mainPanel(
                                        h1("Output"),
                             
                                        h4("List of Citations"),
                                        verbatimTextOutput("txtout"),
                             
                                  ) # mainPanel
                         
                  ), # Navbar 1, tabPanel
                ) # navbarPage
) # fluidPage

#Define Server:
server<- function (input,output){
  
  output$txtout<-renderPrint({
    if (input$Sort == "Alphabetical"){
    file<-input$text1
    wordtest<-readtext(file$datapath)
    text2<-wordtest$text
  rx <- "(?:\\b(\\p{Lu}\\w*(?:\\s+\\p{Lu}\\w*)*(?:\\s+et\\s+al\\.)?)?)\\s*\\(([^()]*\\d{4})\\)"
  res <- str_match_all(text2, rx)
  result <- lapply(res, function(z) {ifelse(!is.na(z[,2]) & str_detect(z[,3],"^\\d+$"), paste(trimws(z[,2]),  trimws(z[,3])), z[,3])})    
  sort(unique(unlist(sapply(result, function(z) strsplit(paste(z, collapse=";"), "\\s*;\\s*")))))
    } else {
      file<-input$text1
      wordtest<-readtext(file$datapath)
      text2<-wordtest$text
      rx <- "(?:\\b(\\p{Lu}\\w*(?:\\s+\\p{Lu}\\w*)*(?:\\s+et\\s+al\\.)?)?)\\s*\\(([^()]*\\d{4})\\)"
      res <- str_match_all(text2, rx)
      result <- lapply(res, function(z) {ifelse(!is.na(z[,2]) & str_detect(z[,3],"^\\d+$"), paste(trimws(z[,2]),  trimws(z[,3])), z[,3])})    
      unique(unlist(sapply(result, function(z) strsplit(paste(z, collapse=";"), "\\s*;\\s*"))))   
    }
  
  })
}


# Create Shiny object
shinyApp(ui = ui, server = server)