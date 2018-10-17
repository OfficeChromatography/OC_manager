import gcodes as GCODES
import print_head_config
import numpy as np

class SampleApplicationDriver:

    
    def __init__(self, communication, driver_config):
        self.communication = communication
        self.driver_config = driver_config

    def calculate_band_steps(self, start, sample_config):
        gap = sample_config['gap']
        bands = len(sample_config['band_config'])
        return np.arange(start, bands * gap, gap)
        
    def generate_gcode(self, sample_config):
        """
        sample_config: dict({ 
        'speed': number,
        'gap': number,
        'plateX': number,
        'plateY': number,
        'numberOfFire': number,
        'pulseDelay': number,
        'bandLength': number,
        'distY': number,
        'distX': number,
        }, band_config: [ # TODO!!
        
          {
             number_of_band_applications: number,
             nozzleIndex: number,
          }, # how often should the printer apply per band

        ])

        """
        print (sample_config)
        ## deal with plate dimension
        calibrated_dist_x = self.driver_config['xlevel'] + \
                            sample_config['distX'] + 50 - \
                            sample_config['plateX']/2

        calibrated_dist_y = self.driver_config['ylevel'] + \
                            sample_config['distY'] + 50 - \
                            sample_config['plateY']/2

        start = GCODES.start(sample_config['speed'], calibrated_dist_x)
        end = GCODES.END
        
        # volume for each single band application
        vol_band= sample_config['bandLength'] / \
                  sample_config['reso'] * \
                  sample_config['numberOfFire'] * \
                  self.driver_config['drop_vol'] / 1000
        np.arange(0.1, 10 * 0.1 , 0.1)
        # begin of bands
        band_start = self.calculate_band_steps(calibrated_dist_y, sample_config)
        band_end= self.calculate_band_steps(calibrated_dist_y + sample_config['gap'], sample_config)
        number_of_bands = len(sample_config['band_config'])
        for i in range(number_of_bands):
            selected_nozzle = [0] * 12

#  #course
#  nozzle= step$appli_table$nozzle
#  repSpray=step$appli_table$Vol_real/Vol_band
#  
#  gcode=c()
#  #gcode creator
#  for (j in seq(nbr_band))
#  {
#    # calculate each nozzle as binary Code because of the gcode 
#    #S= 3 -> 000000000011 -> nozzle 1 and 2 fire
#    # nozzle 3 -> 000000000100 -> S= 4
#    S = rep(0,12)
#    for(l in seq(12)){if(l %in% as.numeric(nozzle[j])){S[l] = 1}};
#    S=sum(2^(which(S== 1)-1))
#    
#    # shift because of selected nozzle
#    shift = round((1 - nozzle[j])*reso,3)
#    # gcode per band
#    number_of_steps= band_length/reso
#    gcode_band= c()
#    for (i in seq(from=band_start[j]+shift, by=reso, length.out = number_of_steps))
#    {
#    gcode_band=c(gcode_band,paste0("G1 Y",i),                    # go in Position
#                                  "M400",                        # wait until fire
#                            paste0("M700 P0 I",I," L",L," S",S), # fire 
#				  "M400")			 # wait
#    }
#    # repeat gcode per band to applie Vol_wish
#    n=as.integer(repSpray[j])
#    gcode=c(gcode,rep(gcode_band,n))
#  }
##########
