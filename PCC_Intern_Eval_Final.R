# load libraries
library(shiny)
library(DT)
library(tidyverse)
library(readxl)
library(knitr)

# define ui
ui <- fluidPage(
    br(),
    img(src='image.png'), # add PR logo
    titlePanel('PCC Intern Evaluation'), # create title
    actionButton("General_Information", 
                 "Information: Please Read"), # create pop-up button
    br(),
    br(),
    sidebarLayout( # create sidebar layout
        sidebarPanel( # define sidebar panel
            h3("Input"), # create large header
            actionButton("Client_Log_Instructions", 
                         "Instructions on Uploading Client Log"), # create pop-up button
            br(),
            br(),
            div(HTML("<em> Upload the client log excel file (.xlsx format) </em>")), # text prefacing uploading client log
            fileInput('client_log', 
                      div(HTML('<b>Client Log</b>'))), # file input for client log
            div(HTML("<em> Input psychometrist/interns' initials in capital letters (e.g. QQ) </em>")), # text prefacing entering intern initials
            textInput('psychometrist', 
                      div(HTML('<b>Psychometrist/Interns Initials</b>'))), # text input for psychometrist initials
            div(HTML("<em> Input psychometrist/interns' hours worked (e.g. 130) </em>")), # text prefacing entering intern hours
            numericInput('hours', 
                         div(HTML('<b>Psychometrist/Interns Hours Worked</b>')), NULL) # numeric input for psychometrist hours
        ),
        mainPanel( # define main panel
            tabsetPanel(type = "tabs", # create tabbed layout
            tabPanel("Summary Statistics", # define first tab
                     br(), 
                div(HTML("<b>Total Patients Taken</b>")), # create patients taken heading
                textOutput('patients'), # patients taken output
                br(),                
                div(HTML("<b>Total Hours Worked</b>")), # create hours worked heading
                textOutput('hours'), # hours worked output
                br(),                
                div(HTML("<b>Patients per Hour Worked</b>")), # create patients per hour worked heading
                textOutput('patientsperhours'), # patients per hour output
                br(),
                div(HTML("<b>Patient Age Mean</b>")), # create patient age mean heading
                textOutput('Agestatmean'), # patient age mean output
                br(),
                div(HTML("<b>Patient Age Standard Deviation</b>")), # create patient age sd heading
                textOutput('Agestatsd')), # patient age sd output
            tabPanel("Patient List", # define second tab
                     br(), 
                dataTableOutput('Datatable')), # create datatable output
            tabPanel("Age Plot", br(), # define third tab
                plotOutput('Agehist')) # create age histogram output
        ))
    )
)
# define server logic
server <- function(input, output){

    data <- reactive({
        req(input$client_log) # require file input for client log
        read_xlsx(input$client_log$datapath, # read excle file
                  col_names = c("DOS", "Age", "Psychometrist"), # define column names
                  col_types = c("date", "numeric", "text")) # define column import types
    })
    
    data1 <- reactive({
                filter(data(), # filter data by psychometrist
                       Psychometrist == input$psychometrist)})
    
    observeEvent(input$General_Information,{ # define modal text for general information
        showModal(modalDialog(
            title = "General Information", div(HTML(
            'This web app was designed by PCC intern Quinton Quagliano in the summer of 2020 to help interns, psychometrists, and supervisors at the PCC calculate and visualise some data
            to quantify experiences. The web app currently displays some summary statistics, a data table of patients taken, and a histogram of patient ages taken. The information
            displayed on this web app should not be used for research without approval from an IRB. This web app is designed with instructions to only use deidentified data. No data inputed into this program is saved.
            
            <ul>
                <li>All code for this web app can be found at <a href="https://github.com/qquagliano/PCC_Intern_Eval/blob/main/PCC_Intern_Eval_Final.R">Github (Raw Code)</a></li>
                <li>Version history can also be found at <a href="https://github.com/qquagliano/PCC_Intern_Eval/commits/main/PCC_Intern_Eval_Final.R">Github (Version History)</a></li>
                <li>Contact: <a href="mailto:Quinton.Quagliano@protonmail.com">Quinton.Quagliano@protonmail.com</a> with questions, concerns, or comments</li>
            </ul>')),
            easyClose = TRUE
        ))
    })
    
    observeEvent(input$Client_Log_Instructions, { # define modal text for client log instructions
        showModal(modalDialog(
            title = "Instructions on Uploading Client Log",
            div(HTML("<ol>
                        <li><b>PLEASE READ EACH INSTRUCTION FULLY AND CAREFULLY BEFORE DOING ANYTHING, THESE INSTRUCTIONS FULLY EXPLAIN EVERYTHING YOU NEED TO DO</b>
                        </li>
                        <li>Open a new tab in the browser, and go to <a href='https://pinerest.sharepoint.com/PPG/Clinics/PCC/SitePages/Home.aspx'>PCC Sharepoint</a>
                        </li>
                        <li>Under 'Documents' on the right side of the screen, navigate through ADD Intership -> Client Logs
                        </li>
                        <li>For the  client log excel file (of the current year), Right click on the currrent client log and select 'download'
                        </li>
                        <li>Open the download client log in the lower left hand corner of chrome
                        </li>
                        <li><b>DOUBLE CHECK YOU ARE WORKING ON AN OFFLINE COPY OF THE CLIENT LOG - DO NOT MAKE CHANGES TO THE ONLINE CLIENT LOG</B>
                        </li>
                        <li>Delete all columns except for DATE, Age, and Psychometrist. You can do this by right clicking the column letter and select 'delete' on the desired columns. Make sure that you delete the entire column, not just the values inside the column.
                        </li>
                        <li>Save the file after editing it and exit the file
                        </li>
                        <li>On this page exit this message, and press the 'Browse...' button and upload the excel file. It should be in the 'Downloads' folder 
                        </li>
                      </ol> ")),
            easyClose = TRUE
        ))
    })
    
    output$Datatable <- renderDataTable({ # render patient data table
        data1()
    })
    
    output$Agehist <- renderPlot({ggplot(data1(), # render age plot
                                  aes(x = Age)) +
                      geom_histogram(
                         fill = "#758F45", boundary = 0, pad = TRUE, color = "black", binwidth = 10) +
                      scale_x_continuous(
                         breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)) +
                      scale_y_continuous(
                         breaks = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 
                           14, 15, 16, 17, 18, 19, 20)) +
                      theme_bw() +
                      labs (title = "Age Distribution", 
                            x = "Age", 
                            y = "# of Patients")
    })
    
    output$Agestatmean <- renderText(mean(data1()$Age)) # render patient age mean
    
    output$Agestatsd <- renderText(sd(data1()$Age)) # render patient age sd
    
    output$patients <- renderText(as.numeric(count(data1()))) # render number of patients
    
    output$hours <-  renderText(input$hours) # render number of hours worked
    
    output$patientsperhours <- renderText(as.numeric(count(data1()) / input$hours)) # render patients per hour
}

shinyApp(ui = ui, server = server) # run web app
