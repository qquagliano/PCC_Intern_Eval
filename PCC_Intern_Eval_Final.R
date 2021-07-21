library(shiny)
library(DT)
library(tidyverse)
library(readxl)
library(knitr)

ui <- fluidPage(
    br(),
    img(src='image.png'),
    titlePanel('PCC Intern Evaluation'),
    actionButton("General_Information", "Information: Please Read" ),
    br(),
    br(),
    sidebarLayout(
        sidebarPanel(
            h3("Input"),
            actionButton("Client_Log_Instructions", "Instructions on Uploading Client Log"),
            br(),
            br(),
            div(HTML("<em> Upload the client log excel file (.xlsx format) </em>")),
            fileInput('client_log', 
                      div(HTML('<b>Client Log</b>'))),
            div(HTML("<em> Input psychometrist/interns' initials in capital letters (e.g. QQ) </em>")),
            textInput('psychometrist', 
                      div(HTML('<b>Psychometrist/Interns Initials</b>'))),
            div(HTML("<em> Input psychometrist/interns' hours worked (e.g. 130) </em>")),
            numericInput('hours', 
                         div(HTML('<b>Psychometrist/Interns Hours Worked</b>')), NULL)
        ),
        mainPanel(
            tabsetPanel(type = "tabs",
            tabPanel("Summary Statistics", br(),
                div(HTML("<b>Total Patients Taken</b>")),
                textOutput('patients'), br(),                
                div(HTML("<b>Total Hours Worked</b>")),
                textOutput('hours'), br(),                
                div(HTML("<b>Patients per Hour Worked</b>")),
                textOutput('patientsperhours'), br(),
                div(HTML("<b>Patient Age Mean</b>")),
                textOutput('Agestatmean'), br(),
                div(HTML("<b>Patient Age Standard Deviation</b>")),
                textOutput('Agestatsd')),
            tabPanel("Patient List", br(),
                dataTableOutput('Datatable')),
            tabPanel("Age Plot", br(),
                plotOutput('Agehist'))
        ))
    )
)

server <- function(input, output){
    
    data <- reactive({
        req(input$client_log)
        read_xlsx(input$client_log$datapath, col_names = c("DOS", "Age", "Psychometrist"), col_types = c("date", "numeric", "text")) %>%
            filter(Psychometrist == input$psychometrist)
    })
    
    observeEvent(input$General_Information, {
        showModal(modalDialog(
            title = "General Information", div(HTML(
            'This web app was designed by PCC intern Quinton Quagliano in the summer of 2020 to help interns, psychometrists, and supervisors at the PCC calculate and visualise some data
            to quantify experiences. The web app currently displays some summary statistics, a data table of patients taken, and a histogram of patient ages taken. The information
            displayed on this web app should not be used for research without approval from an IRB. This web app is designed with instructions to only use deidentified data. No data inputed into this program is saved.
            
            <ul>
                <li>All code for this web app can be found at <a href="https://github.com/qquagliano/PCC_Intern_Eval/blob/main/PCC_Intern_Eval_Final.R">Github (Raw Code)</a></li>
                <li>Version history can also be found at <a href="https://github.com/qquagliano/PCC_Intern_Eval/commits/main/PCC_Intern_Eval_Final.R">Github (Version History)</a></li>
                <li>Contact: Quinton.Quagliano@protonmail.com with questions, concerns, or comments</li>
            </ul>')),
            easyClose = TRUE
        ))
    })
    
    observeEvent(input$Client_Log_Instructions, {
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
    
    output$Datatable <- renderDataTable({
        data()
    })
    
    output$Agehist <- renderPlot({ggplot(data(),aes(x = Age)) +
            geom_histogram(
                fill = "#758F45", boundary = 0, pad = TRUE, color = "black", binwidth = 10) +
            scale_x_continuous(
                breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)) +
            scale_y_continuous(
                breaks = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 
                           14, 15, 16, 17, 18, 19, 20)) +
            theme_bw() +
            labs (title = "Age Distribution", x = "Age", y = "# of Patients")
    })
    
    output$Agestatmean <- renderText(mean(data()$Age))
    
    output$Agestatsd <- renderText(sd(data()$Age))
    
    output$patients <- renderText(as.numeric(count(data())))
    
    output$hours <-  renderText(input$hours)
    
    output$patientsperhours <- renderText(as.numeric(count(data()) / input$hours))
}

shinyApp(ui = ui, server = server)
