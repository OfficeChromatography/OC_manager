import drivers.gcodes as GCODES
from picamera import PiCamera

class DocumentationDriver():

    PICTURE_CONFIG_DEFAULT = {
        "label": "Picture",
        "white":0,
        "red":0,
        "green":0,
        "blue":0,
        "number_of_pictures":1
        }

    PATH = "/home/pi/OC_manager/GUI/method/methods/documentation/pictures/"
    
    def __init__(self, communication):
        self.communication = communication
        self.camera = PiCamera()

    def LED_OFF(self):
        self.communication.send([
            GCODES.LED_OFF])

    def LEDs(self, white, red, green, blue):
        self.communication.send([
            GCODES.LEDs(white,red,green,blue)

    def take_a_picture(self):
        self.camera.start_preview()
        camera.start_preview()
        ## Camera warm-up time
        sleep(2)
        camera.capture(self.PATH +'Preview.jpg'))
        
        
