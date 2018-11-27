import drivers.gcodes as GCODES
from config.picture_config import PictureConfig 
from picamera import PiCamera
from time import sleep

class DocumentationDriver():

    PICTURE_CONFIG_DEFAULT = {
        "label": "Picture",
        "white":255,
        "red":255,
        "green":255,
        "blue":255,
        "number_of_pictures":2 
        }
    
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

    def go_to_foto_position (self):
        self.communication.send([
            GCODES.GO_TO_FOTO_POSITION])

    def go_to_origin(self):
        self.communication.send([
            GCODES.GO_TO_ORIGIN ])
        
    def take_a_picture(self, Path):
        my_file = open(Path,'r+')
        camera = PiCamera()
        ## Camera warm-up time
        sleep(2)
        camera.capture(my_file)
        my_file.close()
        camera.close()

    def get_Preview_Path(self):
        return self.PATH + "Preview.jpg"

    def get_picture_list(self):
        return self.pictures_config.to_picture_list()

    def get_preview_list(self):
        return self.pictures_config.to_previw_list()

    def preview(self):
        self.go_to_foto_position()
        LED_gcode = self.pictures_config.preview_to_gcode()
        self.communication.send([
            LED_gcode])
        Path = self.get_Preview_Path()
        self.take_a_picture(Path)
        self.LED_OFF()
        self.go_to_origin()
        
