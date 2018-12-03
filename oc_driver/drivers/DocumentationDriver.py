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
        number_of_pictures = int(self.PICTURE_CONFIG_DEFAULT['number_of_pictures'])
        self.pictures = PictureConfig(self.PICTURE_CONFIG_DEFAULT,number_of_pictures)
        self.preview  = PictureConfig(self.PICTURE_CONFIG_DEFAULT,1)

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
        return "/home/pi/OC_manager/www/Preview.jpg"

    def get_picture_list(self):
        return self.pictures.to_list()

    def get_preview_list(self):
        return self.preview.to_list()

    def make_preview(self):
        LED_gcode = self.preview.to_gcode()
        self.communication.send([
            GCODES.SET_ABSOLUTE_POS,
            GCODES.GO_TO_FOTO_POSITION,
            GCODES.CURR_MOVEMENT_FIN,
            LED_gcode])
        Path = self.get_Preview_Path()
        sleep(1)
        self.take_a_picture(Path)
        self.communication.send([
            GCODES.LED_OFF])

    def update_number_of_pictures(self, number_of_pictures):
        return self.pictures.create_conf_to_picture_list(self.PICTURE_CONFIG_DEFAULT,
                                                  int (number_of_pictures))
    def update_preview(self, preview_config):
        self.preview.build_pictures_from_picture_list([preview_config]) 
        
