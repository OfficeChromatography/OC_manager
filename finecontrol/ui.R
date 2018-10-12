output$ink_test_control_1 = renderUI({
  tagList(
  fluidPage(
  column(6, 
      fluidRow(
      box(title = "Motor Control", width = "50 %", heigth ="50 %",solidHeader = TRUE,status = "primary",
      fluidRow(
      column(6,
      fluidRow(
          column(2,"X :"),
          column(2,offset=1,actionButton("xleft","",icon=icon("arrow-left"))),
          column(2,actionButton("xhome","",icon=icon("home"))),
          column(2,actionButton("xright","",icon=icon("arrow-right")))
           ),

      fluidRow(
          column(2,"Y :"),
          column(2,offset=1,actionButton("yup","",icon=icon("arrow-up"))),
          column(2,actionButton("yhome","",icon=icon("home"))),
          column(2,actionButton("ydown","",icon=icon("arrow-down")))
           )),

      column(4,
           actionButton("stop","Disable Motors")
           )),
      fluidRow(
        column(8,
            textInput("test_ink_cmd","Command","G1 X10", width = "100%"),
           actionButton("test_ink_cmd_button","Launch GCODE")
          )
        )
      )),
     fluidRow( 
     box(title = "Gcode upload", width = "50 %", heigth ="50 %", solidHeader = TRUE,status = "primary",
                    fileInput("test_ink_gcode_file","Upload a GCODE file"),
                    actionButton("test_ink_gcode_file_action","Launch the GCODE file")
       )),
     fluidRow(
     box(title = "Documentation", width = "50 %", heigth ="50 %", solidHeader = TRUE,status = "primary",
                    actionButton("test_ink_visu_position","Go in position"),
                    actionButton("test_ink_ring_on","ring on"),
                    actionButton("test_ink_ring_off","ring off")
       ))
     
  ),
  column(6,
         box(title = "Inkjet", width = "50 %", heigth ="50 %", solidHeader = TRUE,status = "primary",
           numericInput("test_ink_n","Number of fire (repetition)",10),
           numericInput("test_ink_n_bis","Number of fire bis (I)",2),
           numericInput("test_ink_L","Pulse length",5),
           checkboxGroupInput("test_ink_S","Nozzles to fire",choices = seq(12),inline = T,selected = seq(12)),
           # numericInput("test_ink_S","S",4095),
           actionButton("test_ink_action",label = "Fire selected nozzles"),
           actionButton("test_ink_nozzle_test",label = "Nozzle testing process")
    )
  )
  )
  )
})
