
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinydashboard)
library(shinyBS)
dbHeader <- dashboardHeader(title = "OC_manager")
# dbHeader$children[[2]]$children <-  tags$a(href='http://oc-lab.com',
#                                            tags$img(src='www/OCLAB-logo-pattern-alb.png',height='60',width='200'))


dashboardPage(
  dbHeader,
  dashboardSidebar(
    sidebarMenu(
                menuItem("Connection", tabName = "Connect",icon=icon("home")),
                menuItem("Method", tabName = "Method",icon=icon("tasks")),
                # menuItem("Layer_printing", tabName = "LP",icon=icon("map")),
                # menuItem("Sample_application", tabName = "SA",icon=icon("ellipsis-h")),
                menuItem("Fine control", tabName = "test_ink",icon=icon("wrench")),
                # menuItem("Development",tabName = "Dev",icon=icon("navicon")),
                # menuItem("Derivatization",tabName = "Deriv",icon=icon("crosshairs")),
                menuItem("Visualization",tabName = "Visu",icon=icon("camera")),
                menuItem("TLC-MS",tabName = "TLC_MS",icon=icon("spoon")),
                menuItem("Log",tabName = "Log",icon=icon("newspaper-o")),
                menuItem("Report",tabName = "Report",icon=icon("print")),
                menuItem("About",tabName = "About",icon=icon("info"))
    )
  ),
  
  dashboardBody(
    tags$script(HTML("$('body').addClass('sidebar-mini');")),
    tabItems(
      tabItem(
        # tags$head(tags$style(type="text/css", ".btn {border-radius: 20px; font-size: 30px;}")),
        
        tags$head(tags$style(type="text/css", "tfoot {display: table-header-group}")),
        tags$head(tags$style(HTML(".shiny-output-error-validation {color: red;font-size: 24px}"))),
        tags$head(tags$style(type="text/css", ".shiny-progress .progress {position: absolute;width: 100%;top: 100px;height: 10px;margin: 0px;}")),
        tags$head(tags$style(type="text/css", ".shiny-progress .progress-text {position: absolute;border-style: solid;
                                     border-width: 2px;right: 10px;height: 36px;width: 50%;background-color: #EEF8FF;margin: 0px;padding: 2px 3px;opacity: 1;}"))
        # tags$head(tags$style(HTML('.skin-blue .main-sidebar {background-color: #f4b943;}')))
      ),
      # First tab content
      tabItem(tabName = "Connect",
              column(4,
                     h4("Login"),
                     uiOutput("Login"),
                     textInput("Plate","Plate info: project, id or whatever","test")
              ),
              column(4,
                     h4("Board"),
                     actionButton("Serial_port_refresh","refresh serial port",icon=icon("refresh")),
                     checkboxInput("Serial_windows","Windows ??",F),
                     uiOutput("Serial_port"), # show the /dev directory
                     uiOutput("Serial_port_connect") # show an actionButton only if connect$login is TRUE and set connect$board to TRUE
              ),
              fileInput("Chrom_upload","Chromatograms upload (jpg)"),
              actionButton("Shutdown","Shutdown"),
              actionButton("Reboot","Reboot"),
              actionButton("Serial_port_disconnect_bis","disconnect the board bis")
              
              ),
      # First tab content
      tabItem(tabName = "test_ink",
              uiOutput("ink_test_control_1")
      ),
      tabItem(tabName = "Method",
              uiOutput("Method_control_1")
              
      ),
      tabItem(tabName = "LP",
              column(4,
                     column(6,
                            uiOutput("LP_control_1"),
                            uiOutput("LP_control_3")
                            ),
                     column(6,
                            uiOutput("LP_control_2")
                            )
                     ),
              column(8,
                     plotOutput('LP_plot')
                     ),
              column(3,
                     numericInput("LP_first_appli","first application position in mm (often the first two tracks will be bad)",4.75),
                     numericInput("LP_bottom_dist","Distance from bottom",2),
                     numericInput("LP_Y_length","Y length",70),
                     numericInput("LP_gap","gap between sample in mm",5),
                     numericInput("LP_nbr_track","number of tracks",19)
              ),
              column(3,
                     numericInput("LP_nbr_path","number of paths per track",4),
                     numericInput("LP_gap_path","gap between paths in one track",0.5),
                     numericInput("LP_microL_per_dm","microL per dm",10) ## work with 40 tracks, 30% of 4 mL
                     ),
              column(3,
                     numericInput("LP_Z_offset","Z_offset (use a gap of 90 and 2 tracks to test the system and adjust the offset accordingly)",0),
                     numericInput("LP_speed","speed mm/s",60)
              ),
              column(3,
                     numericInput("LP_temp","Temperature in degree celcius, better let 0 to disable and do it from pronterface",0),
                     numericInput("LP_syringe_ratio","mm/mL in the syringe, 5 for the 10 mL syringe, 57 for the 1 mL syringe",5),
                     h6("todo: multi layer, boustrophédon, gradient in speed and feed, syringe type")
                     ),
              br(),
              dataTableOutput("LP_gcode")
      ),
      tabItem(tabName = "SA",
              column(4,
                     uiOutput("SA_control_1"),#,#filename, launch, nozzles fired, position fired
                     tableOutput("SA_options")
                     ),
              column(4,
                     tableOutput("SA_appli")
                     ),
              column(4,
                     plotOutput("SA_plot")
                     ),
              br(),
              br(),
              br(),br(),br(),br(),br(),
              dataTableOutput("SA_gcode")
      ),
      tabItem(tabName = "Dev",
              column(4,
                     uiOutput("Dev_control_1"),#,#filename, launch, nozzles fired, position fired
                     tableOutput("Dev_options")
              ),
              column(4,
                     plotOutput("Dev_plot")
              ),
              br(),
              br(),
              br(),br(),br(),br(),br(),
              dataTableOutput("Dev_gcode")
      ),
      tabItem(tabName = "Deriv",
              column(4,
                     uiOutput("Deriv_control_1"),#,#filename, launch, nozzles fired, position fired
                     tableOutput("Deriv_options")
              ),
              column(4,
                     plotOutput("Deriv_plot")
              ),
              br(),
              br(),
              br(),br(),br(),br(),br(),
              dataTableOutput("Deriv_gcode")
      ),
      tabItem(tabName = "Visu",
              uiOutput("Visu_control_1")
      ),
      tabItem(tabName = "TLC_MS",
              uiOutput("TLC_MS_control_1")
      ),
      # tabItem(tabName = "Visu",
      #         tabsetPanel(
      #           tabPanel("Capture",
      #                    column(3,
      #                           # numericInput("Visu_width","Set image width",1000),
      #                           # numericInput("Visu_height","Set image height",1000),
      #                           # numericInput("Visu_timeout","Time (in ms) before takes picture and shuts down",5000),
      #                           numericInput("Visu_shutter","Sets the shutter speed to the specified value (in ms).",100),
      #                           # numericInput("Visu_sharpness","Set image sharpness (-100 to 100)",0),
      #                           # numericInput("Visu_contrast","Set image contrast (-100 to 100)",0),
      #                           # numericInput("Visu_brightness","Set image brightness (0 to 100)",50),
      #                           # numericInput("Visu_saturation","Set image saturation (-100 to 100)",0),
      #                           numericInput("Visu_ISO","Set ISO (100 - 800) ",100)
      #                           # selectizeInput("Visu_exposure","Set exposure mode (see Notes)",
      #                                          # choices = c('off','auto','night','nightpreview','backlight','spotlight','sports','snow','beach','verylong','fixedfps','antishake','fireworks'),selected = "auto"),
      #                           # selectizeInput("Visu_AWB","Set AWB mode (see Notes)",choices = c('off','auto','sun','cloud','shade','tungsten','fluorescent','incandescent','flash','horizon'),selected="auto")
      #                           
      #                    ),
      #                    column(9,
      #                           uiOutput("Visu_control_1"),
      #                           plotOutput("Visu_plot")
      #                    )
      #                    ),
      #           tabPanel("Explore",
      #                    uiOutput("Visu_explore_select"),
      #                    plotOutput("Visu_explore_plot"),
      #                    uiOutput("Visu_explore_plot_bis")
      #                    )
      #         )
      #         
      #         
      # ),
      tabItem(tabName = "Log",
              actionButton("Log_refresh","refresh"),
              dataTableOutput("Log")
      ),
      tabItem("Report",
              # radioButtons('format', 'Document format', c('PDF', 'HTML', 'Word'),inline = TRUE),
              # downloadButton("Report")
              p("incoming")
      ),
      tabItem("About",
              tabsetPanel(
                tabPanel("Steps",
                         tableOutput("About_table_inventory")
                         )
              )
              # includeMarkdown("README.md")
      )
    )
  )
)