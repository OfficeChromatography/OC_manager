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

        
    def take_a_picture(self, Path):
        my_file = open(Path,'w+')
        camera = PiCamera()
        ## Camera warm-up time
        sleep(2)
        camera.capture(my_file)
        my_file.close()
        camera.close()

    def LEDs_on(self, LED_gcode):
        self.communication.send([
            GCODES.SET_ABSOLUTE_POS,
            GCODES.GO_TO_FOTO_POSITION,
            GCODES.CURR_MOVEMENT_FIN,
            LED_gcode])
        sleep(1)

    def LEDs_off(self):
        self.communication.send([
            GCODES.LED_OFF])
        
    def documentation_end(self):
        self.communication.send([
            GCODES.LED_OFF,
            GCODES.GO_TO_ORIGIN_Y])
        
    def get_Preview_Path(self):
        return "/home/pi/OC_manager/www/Preview.jpg"

    def get_picture_list(self):
        return self.pictures.to_list()

    def get_preview_list(self):
        return self.preview.to_list()

    def create_picture_list(self, number_of_pictures):
        return self.pictures.create_conf_to_picture_list(self.PICTURE_CONFIG_DEFAULT,
                                                  int (number_of_pictures))
    def update_preview(self, preview_config):
        self.preview.build_pictures_from_picture_list([preview_config])

    def update_pictures(self, pictures_config):
        self.pictures.build_pictures_from_picture_list(pictures_config)

    def update_settings(self, pictures_list, number_of_pictures):
        pictures_list = self.add_or_remove_Pictures(number_of_pictures, pictures_list)
        self.update_pictures(pictures_list)
        return pictures_list
        
    def make_preview(self, preview_list):
        self.update_preview(preview_list)
        LED_gcode = self.preview.config[0].to_LEDs_gcode()
        Path = self.get_Preview_Path()
        self.LEDs_on(LED_gcode)
        self.take_a_picture(Path)
        self.LEDs_off()

    def make_pictures_for_documentation(self, pictures_list):
        self.update_pictures(pictures_list)
        for picture in self.pictures.config:
            LED_gcode = picture.to_LEDs_gcode()
            label = picture.get_label()
            Path = self.PATH + label + ".jpg"
            self.LEDs_on(LED_gcode)
            self.take_a_picture(Path)
        self.documentation_end()

    def add_or_remove_Pictures(self, number_of_pictures, old_picture_config):
        difference = int (int (number_of_pictures) - len (old_picture_config))
        new_picture_config = old_picture_config
        if difference > 0 :
            new_picture_config = self.add_Pictures(old_picture_config, difference)
        elif difference < 0:
            new_picture_config = self.remove_Pictures(old_picture_config, int (number_of_pictures) )
        return new_picture_config

    def add_Pictures(self, old_picture_config, number_of_pictures_to_add):
        new_pictures = self.create_picture_list(number_of_pictures_to_add)
        new_picture_config = old_picture_config + new_pictures
        return new_picture_config

    def remove_Pictures(self, old_picture_config, number_of_pictures):
        new_picture_config = old_picture_config[0:number_of_pictures]
        return new_picture_config

    def go_home(self):
        self.communication.send([GCODES.GO_TO_ORIGIN_Y])
