import drivers.gcodes as GCODES
from config.picture_config import PictureConfig 
from picamera import PiCamera

class DocumentationDriver():

    PICTURE_CONFIG_DEFAULT = {
        "label": "Picture",
        "white":"white",
        "red":"red",
        "green":"green",
        "blue":"blue",
        "number_of_pictures":3
        }

    LED_LIST = ["WHITE","RED","GREEN","BLUE"] 
        
    PATH = "/home/pi/OC_manager/GUI/method/methods/documentation/pictures/"
    
    def __init__(self, communication):
        self.communication = communication
        self.pictures_config = PictureConfig(self.PICTURE_CONFIG_DEFAULT)

    def LED_OFF(self):
        self.communication.send([
            GCODES.LED_OFF])

    def LEDs(self, white, red, green, blue):
        self.communication.send([
            GCODES.LEDs(white,red,green,blue)])

    def take_a_picture(self, Path):
        self.camera = PiCamera()
        self.camera.start_preview()
        ## Camera warm-up time
        sleep(2)
        self.camera.capture(Path)
        self.canera.end_preview
        
    def get_LED_list(self):
        return self.LED_LIST

    def get_Preview_Path(self):
        return self.PATH + "Preview.jpg"

    def get_picture_list(self):
        return self.pictures_config.to_picture_list()


            
        
