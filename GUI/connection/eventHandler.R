Connect_with_the_board  <<- function(){
    ocDriver$connect()
    connected <<- ocDriver$is_connected()
    if (!connected){
         shinyalert("Oops!", "Can't connect the Board please try again", type = "error")
   }
}


observeEvent(input$Serial_port_connect,{
     if(nchar(input$Serial_port) == 0){
         shinyalert("Oops!", "No board selected", type = "error")
     }else{
         Connect_with_the_board()
     }
  })

observeEvent(input$Serial_port_disconnect,{
        ocDriver$disconnect()
    })

Connect_with_the_board()

