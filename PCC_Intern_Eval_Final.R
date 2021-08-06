# load libraries
library(shiny)
library(DT)
library(tidyverse)
library(readxl)
library(shinyBS)
library(bslib)

javaGenInfo <- '$(document).ready(function(){
  $("a[data-value=\'General Information\']").attr({
    "href":"#", 
    "data-toggle":"modal",
    "data-target":"#GenInfo"
  });
})
'

javaFAQ <- '$(document).ready(function(){
  $("a[data-value=\'FAQ\']").attr({
    "href":"#", 
    "data-toggle":"modal",
    "data-target":"#FAQ"
  });
})
'

javaContact <- '$(document).ready(function(){
  $("a[data-value=\'Contact Information\']").attr({
    "href":"#", 
    "data-toggle":"modal",
    "data-target":"#ContactInformation"
  });
})
'

# define ui
ui <-  fluidPage(
    tags$head(
      tags$script(
        HTML(
          javaGenInfo))),
    
    tags$head(
      tags$script(
        HTML(
          javaFAQ))),
    
    tags$head(
      tags$script(
        HTML(
          javaContact))),
    
    theme = bs_theme(
      version = 4, 
      bootswatch = "sandstone"),
    
    navbarPage("PCC Intern Evaluation",
               
      tabPanel("Main Application",
               
        sidebarLayout( # create sidebar layout
          
          sidebarPanel( # define sidebar panel
            
              actionButton("Client_Log_Instructions", 
                           "Instructions on Uploading Client Log"), # create pop-up button
              
              br(),
              br(),
              
              div(
                HTML("<em> Upload the client log excel file (.xlsx format) </em>")), # text prefacing uploading client log
              fileInput('client_log', 
                        div(
                          HTML('<b>Client Log</b>'))), # file input for client log
              
              div(
                HTML("<em> Input psychometrist/interns' initials in capital letters (e.g. QQ) </em>")), # text prefacing entering intern initials
              textInput('psychometrist', 
                        div(
                          HTML('<b>Psychometrist/Interns Initials</b>'))), # text input for psychometrist initials
              
              div(
                HTML("<em> Input psychometrist/interns' hours worked (e.g. 130) </em>")), # text prefacing entering intern hours
              numericInput('hours', 
                        div(
                          HTML('<b>Psychometrist/Interns Hours Worked</b>')), NULL)), # numeric input for psychometrist hours
          
          mainPanel( # define main panel
            
              tabsetPanel(type = "tabs", # create tabbed layout
                
                tabPanel("Summary Statistics", # define first tab
                         
                  br(), 
                  
                  div(
                    HTML("<b>Total Patients Taken</b>")), # create patients taken heading
                  textOutput('patients'), # patients taken output
                 
                  br(), 
                  
                  div(
                    HTML("<b>Total Hours Worked</b>")), # create hours worked heading
                  textOutput('hours'), # hours worked output
                  
                  br(),  
                  
                  div(
                    HTML("<b>Patients per Hour Worked</b>")), # create patients per hour worked heading
                  textOutput('patientsperhours'), # patients per hour output
                  
                  br(),
                  
                  div(
                    HTML("<b>Patient Age Mean</b>")), # create patient age mean heading
                  textOutput('Agestatmean'), # patient age mean output
                  
                  br(),
                  
                  div(
                    HTML("<b>Patient Age Standard Deviation</b>")), # create patient age sd heading
                  textOutput('Agestatsd')), # patient age sd output
                
                tabPanel("Patient List", # define second tab
                         
                  br(), 
                  
                  dataTableOutput('Datatable')), # create datatable output
                
                tabPanel("Age Plot", br(), # define third tab
                  plotOutput('Agehist')))))), # create age histogram output

    navbarMenu("Information",
        tabPanel("General Information"),
        
        tabPanel("FAQ"),
        
        tabPanel("Contact Information"))),

    bsModal("GenInfo", 
            "", 
            "moda", 
            size = "large", 
            div(
              HTML('<p> This web app was designed by PCC intern Quinton Quagliano in the summer of 2020 to help interns, psychometrists, and supervisors at the PCC calculate and visualise some data
                    to quantify experiences. The web app currently displays some summary statistics, a data table of patients taken, and a histogram of patient ages taken. The information
                    displayed on this web app should not be used for research without approval from an IRB. This web app is designed with instructions to only use de-identified data. No data inputed into this program is saved.
                    <br>
                    <ul>
                        <li>All code for this web app can be found at <a href="https://github.com/qquagliano/PCC_Intern_Eval/blob/main/PCC_Intern_Eval_Final.R">Github (Raw Code)</a></li>
                        <li>Version history can also be found at <a href="https://github.com/qquagliano/PCC_Intern_Eval/commits/main/PCC_Intern_Eval_Final.R">Github (Version History)</a></li>
                    </ul></p>'))),

    bsModal("FAQ", 
            "", 
            "moda", 
            size = "large", 
            div(
              HTML('<p> 
                    <b> What is this app? </b> <br>
                    See the General Information page. <br> <br>
                    <b> Why did you make this? </b> <br>
                    Its a fun side project during my internship and a good way for me to learn and practice coding. I also thought that other interns might be interested in information about the patients they took and some statistics about their time at the PCC. <br> <br>
                    <b> How did you make this? </b> <br>
                    I used a coding language called <a href ="https://www.r-project.org/">R</a> and an add-in for R called <a href="https://shiny.rstudio.com/">Shiny</a>. R is a programming language (like Python) mainly desinged for staticians and data scientists. Shiny is an add-in that allows you to create interactive web pages with R code. I also used a very small amount of Javascript and HTML for certain features and text. <br> <br>
                    <b> How long did this take? </b> <br>
                    I probably spent around 5 hours typing code and 8 hours troubleshooting over the course a month or so. Im basically learning as I go, so I tend to take a while to fix issues and figure out what to write. <br> <br>
                    <b> How did you learn how to do this? </b> <br>
                    I taught myself using some free online books. I also used some code and instructions provided by people on StackOverflow for certain features. If you want to learn R, go <a href = "https://psyteachr.github.io/books/">here</a>. If you want to learn Shiny go <a href = "https://shiny.rstudio.com/tutorial/">here</a> <br> <br>
                    <b> Are you still updating this app? </b> <br>
                    Check the <a href="https://github.com/qquagliano/PCC_Intern_Eval/blob/main/PCC_Intern_Eval_Final.R">Github</a> and see if there have been any recent changes. I intend to provide a few more aesthetic updates, but currently, there is not much more that can be added. <br> <br>
                    <b> Can I access previous versions of this app? </b> <br>
                    You can access the code of any of my revisions. However, I only host the most recent version of the code. Check the <a href="https://github.com/qquagliano/PCC_Intern_Eval/commits/main/PCC_Intern_Eval_Final.R">Version History</a> on Github and you can see all my revisions and versions. <br> <br>
                    <b> Can you add [insert feature/improvement here]? </b> <br>
                    Maybe - it depends on the request. One major limitation is that this web app can only use information present in the client log (stored in the PCC). For example, Id love to add a pie chart for gender, but we dont record that on the client log, so I have no access to that data. If we start adding additional information to the client log, I can add new features. <br> <br>
                    <b> Any other questions? </b> <br>
                    Send me an email or go to my Github page by going to Information -> Contact Information on this app!
                    </p>'))),

    bsModal("ContactInformation", 
            "", 
            "moda", 
            size = "large", 
            div(
              HTML('<b>Github</b>: <a href="https://github.com/qquagliano">https://github.com/qquagliano</a> <br> <br>
                    <b>Email</b>: <a href="mailto:Quinton.Quagliano@protonmail.com">Quinton.Quagliano@protonmail.com</a>'))))

# define server logic
server <- function(input, 
                   output){

    data <- reactive({
              req(input$client_log) # require file input for client log
              read_xlsx(input$client_log$datapath, # read excle file
                  col_names = c("DOS", 
                                "Age", 
                                "Psychometrist"), # define column names
                  col_types = c("date", 
                                "numeric", 
                                "text")) %>%
              filter(Psychometrist == input$psychometrist)})
    
    observeEvent(input$Client_Log_Instructions, { # define modal text for client log instructions
        showModal(
          modalDialog(
            title = "",
            size = "l",
            div(
              HTML("<ol>
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
            easyClose = TRUE))})
    
    output$Datatable <- renderDataTable({ # render patient data table
                          data()})
    
    output$Agehist <- renderPlot({
                        ggplot(
                          data(), # render age plot
                          aes(x = Age)) +
                        geom_histogram(
                          fill = "#758F45", 
                          boundary = 0, 
                          pad = TRUE, 
                          color = "black", 
                          binwidth = 10) +
                        scale_x_continuous(
                          breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)) +
                        scale_y_continuous(
                          breaks = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 
                           14, 15, 16, 17, 18, 19, 20)) +
                        theme_bw() +
                        labs (title = "Age Distribution", 
                              x = "Age", 
                              y = "# of Patients")})
    
    output$Agestatmean <- renderText(
      mean(
        data()$Age)) # render patient age mean
    
    output$Agestatsd <- renderText(
      sd(
        data()$Age)) # render patient age sd
    
    output$patients <- renderText(
      as.numeric(
        count(
          data()))) # render number of patients
    
    output$hours <-  renderText(input$hours) # render number of hours worked
    
    output$patientsperhours <- renderText(
      as.numeric(
        count(data()) / input$hours))} # render patients per hour

shinyApp(ui = ui, 
         server = server) # run web app
