import drivers.gcodes as GCODES 
import numpy as np

class Picture:
    def __init__(self, label, white, red, green,  \
                 blue):
        self.label = label
        self.white = white
        self.red = red
        self.green = green
        self.blue = blue
 
    def get_label(self):
        return self.label

    def get_white(self):
        return self.white
    
    def get_red(self):
        return self.red

    def get_green(self):
        return self.green

    def get_blue(self):
        return self.blue

    def to_dict(self):
        return {'label' : self.label , 'white' : self.white , 'red' : self.red , \
                'green' : self.green , 'blue' : self.blue}
    
    
class PictureConfig:
    
    def __init__(self, PICTURE_CONFIG_DEFAULT, number_of_pictures):
        pictures_list = self.create_conf_to_picture_list(PICTURE_CONFIG_DEFAULT,number_of_pictures)
        self.build_pictures_from_picture_list(pictures_list)
        
    def build_pictures_from_picture_list(self, picture_list):
        "initializes all pictures given by a pictures configuration"
        if len(picture_list) <= 0:
            return 
        pictures = []
        for picture_config in picture_list:
            label = picture_config.get('label')
            white = picture_config.get('white')
            red = picture_config.get('red')
            green = picture_config.get('green')
            blue = picture_config.get('blue')
            # add new picture
            pictures.append(Picture(label, white, red, green,  \
                 blue))      
        self.config = pictures
        
    def create_conf_to_picture_list(self, create_config, number_of_pictures):
        'Transforms the create_config into a pictures list'
        pictures = []
        number_of_pictures = number_of_pictures
        for i in range(number_of_pictures):
            pictures.append({
                'label' : create_config['label'],
                'white' : create_config['white'],
                'red' : create_config['red'],
                'green': create_config['green'],
                'blue': create_config['blue']
            })
        return pictures

    def to_list(self):
        picture_list = []
        for picture in self.config:
            picture_list.append(picture.to_dict())
        return picture_list
        
    def to_gcode(self):
        gcode = ""
        for picture in self.config:
            white = picture.get_white() 
            red = picture.get_red()
            green = picture.get_green()
            blue = picture.get_blue()
            gcode = gcode + GCODES.LEDs(white,red,green,blue)          
        return gcode


