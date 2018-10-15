import gcodes as GCODES 
import OCDriver.OCDriver

class FineControlDriver:

    def __init__(OCDriver):

    def goXLeft(self):
        OCDriver.send( [
            GCODES.SET_REFERENCE,
            GCODES.goXMinus()
        ])
        

    def goXRight(self):
        OCDriver.send( [
            GCODES.SET_REFERENCE,
            GCODES.goXPlus()
        ])
        

    def customCommand(self, command):
        OCDriver.send([command])

    def goHome(self):
        OCDriver.send([
            GCODES.GO_TO_ORIGIN,
            GCODES.SET_ABSOLUTE_POS
        ])

    def goYUp(self):
        OCDriver.send( [
            GCODES.SET_REFERENCE,
            GCODES.goYPlus()
        ])
        
    def goYDown(self):
        OCDriver.send( [
            GCODES.SET_REFERENCE,
            GCODES.goYMinus()
        ])

    def stop(self):
        return OCDriver.send([GCODES.DISABLE_STEPPER_MOTORS])
        

    
   #  self.printer = printer 
    
    # structure( class = "FineControlDriver",
              
    #           list (
    #               send = function(code) {
    #                   printer$send(code)
                      
    #               },

    #               goXLeft = function() {
    #                   send(gcodeCommands$setReference())
    #                   send(gcodeCommands$goXMinus())
    #                   printer$Print()
    #               },
                  
    #               goXRight = function() {
    #                   send(gcodeCommands$setReference())
    #                   send(gcodeCommands$goXPlus())
    #                   printer$Print()
    #               },
                  
                  
    #               customCommand = function(code) {
    #                   send(gcodeCommands.customGCode(code))
    #                   printer$Print()
    #               },
                  
                  
    #               xHome = function(){
    #                   send(gcodeCommands$home())
    #                   send(gcodeCommands$goXRight("0"))
    #                   send(gcodeCommands$setAbsolutePos())
    #                   printer$Print()
    #               },
                  
                  
                  
    #               goYUp = function () {
    #                   send(gcodeCommands$setReference())
    #                   send(gcodeCommands$goPlus())
    #                   printer$Print()
    #               },
                  
    #               yHome = function () {
    #                   send(gcodeCommands$home())
    #                   send(printer$send("G28 Y0\nG90"))
    #                   printer$Print()
    #               },
    #               goYDown = function () {
    #                   send(gcodeCommands$setReference())
    #                   send(gcodeCommands$goYMinus())
    #                   printer$Print()
    #               },
    #               stop = function () {
    #                   send(printer$send("M18"))
    #                   printer$Print()
    #               },
                  
    #               applyCommands = function(commandList) {
                      
    #                   concatCommands = ommandList.map(command){
    #                       return pacte0(send(command), '\n')
    #                   }
    #                   send(printer$Print)
    #               }
    



