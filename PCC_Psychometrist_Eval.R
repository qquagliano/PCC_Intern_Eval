# load libraries
library(shiny)
library(DT)
library(tidyverse)
library(readxl)
library(shinyBS)
library(bslib)

# define Javascript for General Information modal
javaGenInfo <- '$(document).ready(function(){
  $("a[data-value=\'General Information\']").attr({
    "href":"#", 
    "data-toggle":"modal",
    "data-target":"#GenInfo"
  });
})
'
# define Javascript for FAQ modal
javaFAQ <- '$(document).ready(function(){
  $("a[data-value=\'FAQ\']").attr({
    "href":"#", 
    "data-toggle":"modal",
    "data-target":"#FAQ"
  });
})
'
# define Javascript for Contact Information modal
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
  
    # call Javascript for General Information modal
    tags$head(
      tags$script(
        HTML(
          javaGenInfo))),
    
    # call Javascript for FAQ modal
    tags$head(
      tags$script(
        HTML(
          javaFAQ))),
    
    # call Javascript for Contact Information modal
    tags$head(
      tags$script(
        HTML(
          javaContact))),
    
    # define theme for web app
    theme = bs_theme(
      version = 4, 
      bootswatch = "sandstone"),
    
    # define navbar page format
    navbarPage("PCC Psychometrist Evaluation",
      
      # define Main Application tab on navbar                  
      tabPanel("Main Application",
        
        # create sidebar layout              
        sidebarLayout( 
          
          # define sidebar panel
          sidebarPanel( 
              
            # create modal button for Instructions for Uploading Client Log 
              actionButton("Client_Log_Instructions", 
                           "Instructions on Uploading Client Log"), 
              
              br(),
              br(),
              
              # client log file input block
              div(
                HTML("<em> Upload the client log excel file (.xlsx format) 
                     </em>")), 
              fileInput('client_log', 
                        div(
                          HTML('<b>Client Log</b>'))), 
              
              # psychometrist initials block
              div(
                HTML("<em> Input Psychometrists' Initials in capital 
                     letters (e.g. QQ) </em>")), 
              textInput('psychometrist', 
                        div(
                          HTML("<b>Psychometrists' Initials</b>"))), 
              
              #psychometrist hours block
              div(
                HTML("<em> Input Psychometrists' Hours Worked 
                     (e.g. 130) </em>")), 
              numericInput('hours', 
                            div(
                              HTML("<b>Psychometrists' Hours Worked</b>")), 
                            NULL)), 
          
          # define main panel
          mainPanel( 
            
              # create tabbed layout
              tabsetPanel(type = "tabs", 
                
                # define first tab
                tabPanel("Summary Statistics", 
                         
                  br(), 
                  
                  # patients taken block
                  div(
                    HTML("<b>Total Patients Taken</b>")), 
                  textOutput('patients'), 
                 
                  br(), 
                  
                  # hours worked block
                  div(
                    HTML("<b>Total Hours Worked</b>")), 
                  textOutput('hours'), 
                  
                  br(),  
                  
                  # patients per hour block
                  div(
                    HTML("<b>Patients per Hour Worked</b>")), 
                  textOutput('patientsperhours'), 
                  
                  br(),
                  
                  # patient age mean block
                  div(
                    HTML("<b>Patient Age Mean</b>")),
                  textOutput('Agestatmean'),
                  
                  br(),
                  
                  # patient age sd block
                  div(
                    HTML("<b>Patient Age Standard Deviation</b>")), 
                  textOutput('Agestatsd')), 
                
                # define second tab
                tabPanel("Patient List", 
                         
                  br(), 
                  
                  # display data table
                  dataTableOutput('Datatable')), 
                
                # define third tab
                tabPanel("Plots", br(), 
                         
                  # display age histogram       
                  plotOutput('Agehist'),
      
                  # display gender plot
                  plotOutput('GenderPlot')))))),

    # define second drop-down navbar tab
    navbarMenu("Information",
        
        # define General Information option in drop-down       
        tabPanel("General Information"),
        
        # define FAQ option in drop-down
        tabPanel("FAQ"),
        
        # define Contact Information option in drop-down
        tabPanel("Contact Information"))),
    
    # create General Information modal
    bsModal("GenInfo", 
            "", 
            "moda", 
            size = "large", 
            div(
              HTML('<p> This web app was designed by PCC Intern Quinton 
              Quagliano in the summer of 2020 to help psychometrists, interns, 
              and supervisors at the PCC calculate and visualise some data
                    to quantify experiences. The web app currently displays 
                    some summary statistics, a data table of patients taken, 
                    and a histogram of patient ages taken. The information
                    displayed on this web app should not be used for research 
                    without approval from an IRB. This web app is designed 
                    with instructions to only use de-identified data. No data 
                    inputed into this program is saved.
                    <br>
                    <ul>
                        <li>All code for this web app can be found at 
                        <a href="https://github.com/qquagliano/PCC_Psychometrist_Eval/
                        blob/main/PCC_Psychometrist_Eval.R">Github (Raw Code)
                        </a></li>
                        <li>Version history can also be found at 
                        <a href="https://github.com/qquagliano/PCC_Psychometrist_Eval/
                        commits/main/PCC_Psychometrist_Eval">Github 
                        (Version History)</a></li>
                    </ul></p>'))),

    # create FAQ modal
    bsModal("FAQ", 
            "", 
            "moda", 
            size = "large", 
            div(
              HTML('<p> 
                    <b> What is this app? </b> <br>
                    See the General Information page. <br> <br>
                    <b> Why did you make this? </b> <br>
                    Its a fun side project during my internship and a good way 
                    for me to learn and practice coding. I also thought that 
                    other psychometrists and interns might be interested in 
                    information about the 
                    patients they took and some statistics about their time at 
                    the PCC. <br> <br>
                    <b> How did you make this? </b> <br>
                    I used a coding language called 
                    <a href ="https://www.r-project.org/">R</a> and an add-in 
                    for R called <a href="https://shiny.rstudio.com/">Shiny</a>. 
                    R is a programming language (like Python) mainly desinged 
                    for staticians and data scientists. Shiny is an add-in that 
                    allows you to create interactive web pages with R code. I 
                    also used a very small amount of Javascript and HTML for 
                    certain features and text. <br> <br>
                    <b> How long did this take? </b> <br>
                    I probably spent around 5 hours typing code and 8 hours 
                    troubleshooting over the course a month or so. Im basically 
                    learning as I go, so I tend to take a while to fix issues 
                    and figure out what to write. <br> <br>
                    <b> How did you learn how to do this? </b> <br>
                    I taught myself using some free online books. I also used 
                    some code and instructions provided by people on 
                    StackOverflow for certain features. If you want to learn R, 
                    go <a href = "https://psyteachr.github.io/books/">here</a>. 
                    If you want to learn Shiny go <a href = 
                    "https://shiny.rstudio.com/tutorial/">here</a> <br> <br>
                    <b> Are you still updating this app? </b> <br>
                    Check the <a href="https://github.com/qquagliano/
                    PCC_Psychometrist_Eval/blob/main/PCC_Psychometrist_Eval_Final.R">Github</a> 
                    and see if there have been any recent changes. I intend to 
                    provide a few more aesthetic updates, but currently, there 
                    s not much more that can be added. <br> <br>
                    <b> Can I access previous versions of this app? </b> <br>
                    You can access the code of any of my revisions. However, I 
                    only host the most recent version of the code. 
                    Check the <a href="https://github.com/qquagliano/
                    PCC_Psychometrist_Eval/commits/main/PCC_Psychometrist_Eval_Final.R">
                    Version History</a> on Github and you can see all my 
                    revisions and versions. <br> <br>
                    <b> Can you add [insert feature/improvement here]? </b> <br>
                    Maybe - it depends on the request. One major limitation is 
                    that this web app can only use information present in the 
                    client log (stored in the PCC). If we start 
                    adding additional information to the client log, I can add 
                    new features. <br> <br>
                    <b> Any other questions? </b> <br>
                    Send me an email or go to my Github page by going to 
                    Information -> Contact Information on this app!
                    </p>'))),

    # create Contact Information modal
    bsModal("ContactInformation", 
            "", 
            "moda", 
            size = "large", 
            div(
              HTML('<b>Github</b>: <a href="https://github.com/qquagliano">
              https://github.com/qquagliano</a> <br> <br>
                    <b>Email</b>: <a href="
                   mailto:Quinton.Quagliano@protonmail.com">
                   Quinton.Quagliano@protonmail.com</a>'))))

# define server logic
server <- function(input, 
                   output){

    # import excel file logic
    data <- reactive({
              req(input$client_log) 
              read_xlsx(input$client_log$datapath, 
                  col_names = c("DOS", 
                                "Age",
                                "Gender",
                                "Psychometrist"), 
                  col_types = c("date", 
                                "numeric", 
                                "text",
                                "text")) %>%
              filter(Psychometrist == input$psychometrist)})
    
    # create modal for client log instructions
    observeEvent(input$Client_Log_Instructions, { 
        showModal(
          modalDialog(
            title = "",
            size = "l",
            div(
              HTML("<ol>
                    <li><b>PLEASE READ EACH INSTRUCTION FULLY AND CAREFULLY 
                    BEFORE DOING ANYTHING, THESE INSTRUCTIONS FULLY EXPLAIN 
                    EVERYTHING YOU NEED TO DO</b>
                    </li>
                    <li>Open a new tab in the browser, and go to <a href='
                    https://pinerest.sharepoint.com/PPG/Clinics/PCC/SitePages/
                    Home.aspx'>PCC Sharepoint</a>
                    </li>
                    <li>Under 'Documents' on the right side of the screen, 
                    navigate through ADD Intership -> Client Logs
                    </li>
                    <li>For the  client log excel file (of the current year), 
                    Right click on the currrent client log and select 'download'
                    </li>
                    <li>Open the download client log in the lower left hand 
                    corner of chrome
                    </li>
                    <li><b>DOUBLE CHECK YOU ARE WORKING ON AN OFFLINE COPY OF 
                    THE CLIENT LOG - DO NOT MAKE CHANGES TO THE ONLINE CLIENT 
                    LOG</B>
                    </li>
                    <li>Delete all columns except for DATE, Age, Gender, and 
                    Psychometrist. You can do this by right clicking the column 
                    letter and select 'delete' on the desired columns. Make 
                    sure that you delete the entire column, not just the values 
                    inside the column.
                    </li>
                    <li>Save the file after editing it and exit the file
                    </li>
                    <li>On this page exit this message, and press the 'Browse...'
                    button and upload the excel file. It should be in the 
                    'Downloads' folder 
                    </li>
                    </ol> ")),
            easyClose = TRUE))})
    
    # render patient data table
    output$Datatable <- renderDataTable({ 
                          data()})
    
    # render age plot
    output$Agehist <- renderPlot({
                        ggplot(data(), 
                               aes(x = Age)) +
                        geom_histogram(fill = "#758F45", 
                                       boundary = 0, 
                                       pad = TRUE, 
                                       color = "black", 
                                       binwidth = 10) +
                        scale_x_continuous(breaks = c(0, 10, 20, 30, 40, 50, 60, 
                                                      70, 80, 90, 100)) +
                        scale_y_continuous(breaks = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 
                                                      9, 10, 11, 12, 13, 
                                                      14, 15, 16, 17, 18, 19, 
                                                      20)) +
                        theme_bw() +
                        labs (title = "Age Distribution", 
                              x = "Age", 
                              y = "# of Patients")})
    
    # render gender plot
    output$GenderPlot <- renderPlot({
                          ggplot(data(),
                                 aes(x = data()$Gender)) +
                          geom_bar(color = "black", fill = "#758F45") +
                          scale_fill_brewer(palette = "Greens") +
                          labs (title = "Gender Distribution", 
                                x = "Gender", 
                                y = "# of Patients") +
                          scale_y_continuous(breaks = c(5, 10, 15, 20, 25, 30,
                                                        35, 40)) +
                          theme_bw()})
    
    # render patient age mean
    output$Agestatmean <- renderText(
      mean(
        data()$Age)) 
    
    # render patient age sd
    output$Agestatsd <- renderText(
      sd(
        data()$Age)) 
    
    # render number of patients
    output$patients <- renderText(
      as.numeric(
        count(
          data()))) 
    
    # render number of hours worked
    output$hours <-  renderText(input$hours) 
    
    # render patients per hour
    output$patientsperhours <- renderText(
      as.numeric(
        count(data()) / input$hours))} 

# run web app
shinyApp(ui = ui, 
         server = server) 
