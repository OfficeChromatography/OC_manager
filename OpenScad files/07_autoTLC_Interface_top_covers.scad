// TLC interface automatisation for CAMAG interface
// autoTLC-MS Interface; top and rear covers
// 2018 September

use <02_autoTLC_Interface_base.scad>

////////////////////// 

module stamp_cover(){
     difference(){
     hull(){
     translate([ 34,-22,116])cylinder(h=7, r=7,center=true,$fn=60); 
     translate([-34,-22,116])cylinder(h=7, r=7,center=true,$fn=60); 
     translate([ 40,104,116])cylinder(h=7, r=1,center=true,$fn=60); 
     translate([-40,104,116])cylinder(h=7, r=1,center=true,$fn=60);      
     }
    stamp_stage_negative();
    translate([0,105,114.5]) rotate([-25,0,0]) cube([100,10,10],center=true); 
    monitor_mount_neg2(); 
    }}


module stamp_cover_neg(){   
     hull(){
     translate([ 34,-22,116])cylinder(h=7, r=7,center=true,$fn=60); 
     translate([-34,-22,116])cylinder(h=7, r=7,center=true,$fn=60); 
     translate([ 40,104,116])cylinder(h=7, r=1,center=true,$fn=60); 
     translate([-40,104,116])cylinder(h=7, r=1,center=true,$fn=60);      
     }
     }
module stamp_cover_back(){
     difference(){
     union(){ 
          ////base
          hull(){
            translate([ 40,295.5,116])cylinder(h=7, r=1,center=true,$fn=60); 
            translate([-40,295.5,116])cylinder(h=7, r=1,center=true,$fn=60); 
            translate([ 40,96,116])cylinder(h=7, r=1,center=true,$fn=60); 
            translate([-40,96,116])cylinder(h=7, r=1,center=true,$fn=60);}       
          ////pneumatic_valves
            translate([-34,114,76]) cube([6,13,41]);
            translate([28,114,93]) cube([6,13,24]);            
            translate([-8,114,93]) cube([16,13,24]);        
          ////gas_inlet
            translate([-11,260,111])cylinder(h=2,r=20,$fn=60);
          ////corner box   
           //  translate([18.8,278.5,101.5]) cube([15,10,12]);      
             
            }  
        ////cutouts
            //rheodyne
            translate([0,199.75,106])cylinder(h=15,r=1.5,$fn=60);      
            translate([0,150.25,106])cylinder(h=15,r=1.5,$fn=60);    
            translate([0,175.00,106])cylinder(h=15,r=17,$fn=60);
                hull(){
                    translate([0,199.75,109])cylinder(h=6,r=6,$fn=60);      
                    translate([0,150.25,109])cylinder(h=6,r=6,$fn=60);
                    translate([0,175.00,109])cylinder(h=6,r=26,$fn=60);         
                    }      
   
            //gas_to Rheodyne
                    translate([0,135,108.9])cylinder(h=20,r=2,$fn=60);
            
            //gas controller 
                translate([-11,260,108.9])cylinder(h=20,r=14.8,$fn=60);
                translate([-11,260,114])cylinder(h=10,r=20,$fn=60);
          
            //pneumatic_valve_cutout
                ////valve1
                translate([-28.5,111,71.5]) cube([10.5,19,46]);       
                translate([-36.5,120,81]) rotate([90,30,0]) cylinder(h=16,r=5,$fn=6,center=true);    
                translate([-26,120,84]) rotate([90,30,0]) cylinder(h=16,r=4,$fn=6,center=true); 
                
                ////valve2               
                translate([-16,112.5,71.5]) cube([10.3,16,46]);
                
                translate([-10.85,145,110])rotate([90,0,0])cylinder(h=30,r=5.15,$fn=60);                   
                
                difference(){
                translate([0.8,120,98]) rotate([90,30,0]) cylinder(h=16,r=4,$fn=6,center=true); 
                    hull(){
                    translate([0.8,120,120]) rotate([90,30,0]) cylinder(h=16,r=2,$fn=6,center=true); 
                    translate([0.8,120,80]) rotate([90,30,0]) cylinder(h=16,r=2,$fn=6,center=true); }
                    }
                              
                translate([-8.2,120.5,109.9]) rotate([90,30,0]) cylinder(h=13.01,r=4,$fn=6,center=true);
               
                ////valve3/4
                translate([17.7,112.5,71.5]) cube([10.3,16,46]);   
                translate([7.5,112.5,71.5]) cube([10.3,16,46]);
                
                translate([22.85,145,110])rotate([90,0,0])cylinder(h=30,r=5.15,$fn=60);       
                translate([12.75,145,110])rotate([90,0,0])cylinder(h=30,r=5.15,$fn=60);   
                
         
                translate([36.5,120,98]) rotate([90,30,0]) cylinder(h=16,r=5,$fn=6,center=true); 
                translate([9.9,120.5,103]) rotate([90,30,0]) cylinder(h=13.1,r=4,$fn=6,center=true);
                translate([25.6,120.5,109.9]) rotate([90,30,0]) cylinder(h=13.01,r=4,$fn=6,center=true);
                      
            stamp_stage_negative();
            translate([0,96,118.5]) rotate([-25,0,0]) cube([100,10,20],center=true); 
            ////coner box screw
            translate([26,284,106.5]) rotate([90,0,0]) cylinder(h=10, r=1.4,center=true,$fn=60);      
            }    
            
        }


module electronic_port(){ 
    difference(){ 
        union(){
            ////base
            hull(){
                translate([ 40.5,292.5,112]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60); 
                translate([-40.5,292.5,112]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60);    
                translate([ 40.5,292.5, -20]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60); 
                translate([-40.5,292.5, -20]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60);
            }       
            color("orange") translate([26.75,272,7.5]) rotate([90,0,0]) all_ports();   
        }          
        stamp_stage_negative();  
        translate([11.5,293.51,27.5]) sb25Port();  
        hull(){
                translate([0,292.5,-10]) rotate([90,0,0]) cylinder(h=10, r=3.5,center=true,$fn=60); 
                translate([0,292.5,-25]) rotate([90,0,0]) cylinder(h=10, r=5,center=true,$fn=60);}
                translate([-15,292.5,10]) rotate([90,0,0]) cylinder(h=10, r=3.7,center=true,$fn=60);
                 translate([-15,299,10]) rotate([90,0,0]) cylinder(h=10, r=5.1,center=true,$fn=60);
        }   
}

module sb25Port(){         
            ////screws
            translate([0,3.5,-23.5]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);       
            translate([0,3.5, 23.5]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);   
            hull(){
                translate([ 3,3.5, 19]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
                translate([-3,3.5, 18]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
                translate([ 3,3.5,-19]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
                translate([-3,3.5,-18]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);}    
            ////outcut    
            hull(){
                translate([-7.5,-5,-28]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);       
                translate([ 7.5,-5,-28]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);       
                translate([-7.5,-5, 28]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);       
                translate([ 7.5,-5, 28]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);       
                }                        
            }               
module elektronic_port_old(){ 
    color("red") difference(){ 
    union(){
    ////base
         hull(){
            translate([ 40.5,292.5,112]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60); 
            translate([-40.5,292.5,112]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60); 
            //translate([ 40.5,292.5,  36.5]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60); 
            //translate([-40.5,292.5,  36.5]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60);      
            translate([ 40.5,292.5, -20]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60); 
            translate([-40.5,292.5, -20]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60);
              }       
        translate([26.75,272,7]) rotate([90,0,0]) all_ports();   
        }
        ////outcuts
         //screws back
        //hull(){
            //translate([ 18,292.5,99]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            //translate([-30.5,292.5,99]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);   
            //translate([ 18,292.5,70]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            //translate([-30.5,292.5,70]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);}
        hull(){
            translate([ 16,292.5,50]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            translate([-16,292.5,50]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60); 
            translate([ 6.5,292.5,33]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            translate([-6.5,292.5,33]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);}
            
      hull(){
            translate([ 6.75,292.5,39]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            translate([-6.75,292.5,39]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60); 
            translate([ 5,292.5,20]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            translate([-5,292.5,20]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);}      
            
            
            
        ////Sb25 Port
        hull(){
            translate([ 18.5,292.5,50]) rotate([90,0,0]) cylinder(h=10, r=2.6,center=true,$fn=60);       
            translate([-18.5,292.5,50]) rotate([90,0,0]) cylinder(h=10, r=2.6,center=true,$fn=60); 
            translate([ 17.5,292.5,44]) rotate([90,0,0]) cylinder(h=10, r=2.6,center=true,$fn=60);       
            translate([-17.5,292.5,44]) rotate([90,0,0]) cylinder(h=10, r=2.6,center=true,$fn=60);} 
            ////mountin screws 0,8 for tinscrew
            translate([ 23.5,292.5,47]) rotate([90,0,0]) cylinder(h=10, r=0.9,center=true,$fn=60);       
            translate([-23.5,292.5,47]) rotate([90,0,0]) cylinder(h=10, r=0.9,center=true,$fn=60);
            
        hull(){
            translate([ 25.2,294.51,51.8]) rotate([90,0,0]) cylinder(h=4, r=1.7,center=true,$fn=60);       
            translate([-25.2,294.51,51.8]) rotate([90,0,0]) cylinder(h=4, r=1.7,center=true,$fn=60); 
            translate([ 25.2,294.51,42.2]) rotate([90,0,0]) cylinder(h=4, r=1.7,center=true,$fn=60);       
            translate([-25.2,294.51,42.2]) rotate([90,0,0]) cylinder(h=4, r=1.7,center=true,$fn=60);} 

        //cornerfix    
        //translate([26,292.5,106.5]) rotate([90,0,0]) cylinder(h=10, r=1.5,center=true,$fn=60);      
        //translate([26,294.51,106.5]) rotate([90,0,0]) cylinder(h=4, r=3,center=true,$fn=60);      
        stamp_stage_negative();  
        }     
    }
module all_ports(){
        difference(){
            hull(){
            translate([5,-20,-5.8])cylinder(h=22.7, r=1,center=true,$fn=60);        
            translate([5,104,-5.8])cylinder(h=22.7, r=1,center=true,$fn=60);
            translate([-5,-20,-5.8])cylinder(h=22.7, r=1,center=true,$fn=60);        
            translate([-5,104,-5.8])cylinder(h=22.7, r=1,center=true,$fn=60);                 
            }                         
        translate([0,-4.65,0]) port_8x1();
        translate([0,26.45,0]) port_8x1();
        translate([0,57.55,0]) port_8x1();
        translate([0,88.65,0]) port_8x1();

        translate([0,-4.65,0]) port_outcut();
        translate([0,26.45,0]) port_outcut();
        translate([0,57.55,0]) port_outcut();
        translate([0,88.65,0]) port_outcut(); 
    }
    }
  

    module port_outcut(){
        difference(){
            hull(){
                translate([-4.8,-9,0])cylinder(h=40, r=2,center=true,$fn=60);  
                translate([-4.8, 9,0])cylinder(h=40, r=2,center=true,$fn=60);}      
                translate([-4.8,-9,0])cylinder(h=41, r=2.1,center=true,$fn=60);  
                translate([-4.8, 9,0])cylinder(h=41, r=2.1,center=true,$fn=60);           
            }
        }
    module all_ports_last(){
        difference(){union(){
        hull(){
        translate([ 5.5, 104,-1])cylinder(h=11, r=1,center=true,$fn=60);  
        translate([-5.5, 104,-1])cylinder(h=11, r=1,center=true,$fn=60);      
        translate([ 5.5,-20,-1])cylinder(h=11, r=1,center=true,$fn=60);      
        translate([-5.5,-20,-1])cylinder(h=11, r=1,center=true,$fn=60);  
        }          
        hull(){
        translate([   5.5,  -10.2,-1])cylinder(h=11, r=1,center=true,$fn=60);  
        translate([-17.5,  -10.2,-1])cylinder(h=11, r=1,center=true,$fn=60);      
        translate([   5.5,-20,-1])cylinder(h=11, r=1,center=true,$fn=60);      
        translate([-17.5,-20,-1])cylinder(h=11, r=1,center=true,$fn=60);  
        } 

        hull(){
            translate([   5.5,-20,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            translate([-17.5,-20,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([-17.5,-19,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([   5.5,-19,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            } 
        hull(){
            translate([  5.5,10.3,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            translate([-5.5,10.3,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([-5.5,11.5,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([  5.5,11.5,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            }            
        hull(){
            translate([ 5.5,41.4,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            translate([-5.5,41.4,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([-5.5,42.6,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([ 5.5,42.6,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            }   
        hull(){
            translate([ 5.5,72.5,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            translate([-5.5,72.5,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([-5.5,73.7,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([ 5.5,73.7,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            }
        hull(){
            translate([ 5.5,103,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            translate([-5.5,103,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([-5.5,104,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([ 5.5,104,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            }              
      hull(){
            translate([   5.5,-20,-6])cylinder(h=21, r=1,center=true,$fn=60);        
            translate([ 5.5,103,-6])cylinder(h=21, r=1,center=true,$fn=60);
            translate([   5,-20,-6])cylinder(h=21, r=1,center=true,$fn=60);        
            translate([ 5,103,-6])cylinder(h=21, r=1,center=true,$fn=60);    
      }  
            
            difference(){
            translate([-11.4,-10.2,-6.5])cube([5,5,11],$fn=60);
            translate([-11.4,-4.2,-0.5])cylinder(h=19, r=5,center=true,$fn=60);}    
        }
        translate([-12,-15.3,0]) port_2x1();
        translate([0,-4.65,0]) port_8x1();
        translate([0,26.45,0]) port_8x1();
        translate([0,57.55,0]) port_8x1();
        translate([0,88.65,0]) port_8x1();

    }
    }
    module all_ports_old(){
        translate([-12,29.5,0]) port_2x1();
        translate([-12,0,0]) port_8x1();
        translate([0,0,0]) port_8x1();
        translate([0,40,0]) port_8x1();
        translate([0,80,0]) port_8x1();
    
        hull(){
            translate([   5.5,-20,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            translate([-17.5,-20,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([-17.5,-16,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([   5.5,-16,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            } 
        hull(){
            translate([   5.5,17,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            translate([-17.5,17,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([-17.5,23,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([   5.5,23,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            }            
        hull(){
            translate([ 5.5,57,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            translate([-5.5,57,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([-5.5,63,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([ 5.5,63,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            }   
        hull(){
            translate([ 5.5,97,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            translate([-5.5,97,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([-5.5,100,-6])cylinder(h=21, r=1,center=true,$fn=60);      
            translate([ 5.5,100,-6])cylinder(h=21, r=1,center=true,$fn=60);  
            }   
             
      hull(){
            translate([   5.5,-20,-6])cylinder(h=21, r=1,center=true,$fn=60);        
            translate([ 5.5,100,-6])cylinder(h=21, r=1,center=true,$fn=60);
            translate([   5,-20,-6])cylinder(h=21, r=1,center=true,$fn=60);        
            translate([ 5,100,-6])cylinder(h=21, r=1,center=true,$fn=60);    
      }  
            
            difference(){
            translate([-14.5,37.5,-6.5])cube([8,8,11],$fn=60);
            translate([-14.5,45.5,-0.5])cylinder(h=19, r=8,center=true,$fn=60);}                      
    }
    module port_2x1(){       
        hull(){
        translate([ 3.3, 3.7,0])cylinder(h=10, r=0.25,center=true,$fn=60);  
        translate([-3.3, 3.7,0])cylinder(h=10, r=0.25,center=true,$fn=60);      
        translate([ 3.3,-3.7,0])cylinder(h=10, r=0.25,center=true,$fn=60);      
        translate([-3.3,-3.7,0])cylinder(h=10, r=0.25,center=true,$fn=60);  
        }   
        hull(){
        translate([ 2.6, 3.0,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);  
        translate([-2.6, 3.0,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);      
        translate([ 2.6,-3.0,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);      
        translate([-2.6,-3.0,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);  
        } 
        translate([ 3.3, 3.7,0])cylinder(h=10, r=0.7,center=true,$fn=60);  
        translate([-3.3, 3.7,0])cylinder(h=10, r=0.7,center=true,$fn=60);      
        translate([ 3.3,-3.7,0])cylinder(h=10, r=0.7,center=true,$fn=60);      
        translate([-3.3,-3.7,0])cylinder(h=10, r=0.7,center=true,$fn=60);        
        } 


    module port_8x1(){      
        hull(){
        translate([ 3.3, 14.4,0])cylinder(h=10, r=0.25,center=true,$fn=60);  
        translate([-3.3, 14.4,0])cylinder(h=10, r=0.25,center=true,$fn=60);      
        translate([ 3.3,-14.4,0])cylinder(h=10, r=0.25,center=true,$fn=60);      
        translate([-3.3,-14.4,0])cylinder(h=10, r=0.25,center=true,$fn=60);  
        }  
        hull(){
        translate([ 2.6, 13.7,-6.1])cylinder(h=30, r=0.25,center=true,$fn=60);  
        translate([-2.6, 13.7,-6.1])cylinder(h=30, r=0.25,center=true,$fn=60);      
        translate([ 2.6,-13.7,-6.1])cylinder(h=30, r=0.25,center=true,$fn=60);      
        translate([-2.6,-13.7,-6.1])cylinder(h=30, r=0.25,center=true,$fn=60);  
        }
        translate([ 3.3, 14.4,0])cylinder(h=10, r=0.7,center=true,$fn=60);  
        translate([-3.3, 14.4,0])cylinder(h=10, r=0.7,center=true,$fn=60);      
        translate([ 3.3,-14.4,0])cylinder(h=10, r=0.7,center=true,$fn=60);      
        translate([-3.3,-14.4,0])cylinder(h=10, r=0.7,center=true,$fn=60);  
        
    
        
    
    color ("red") hull(){
        translate([ 3, 14.1,5])cylinder(h=1, r=0.25,$fn=60);  
        translate([-3, 14.1,5])cylinder(h=1, r=0.25,$fn=60);      
        translate([ 3,-14.1,5])cylinder(h=1, r=0.25,$fn=60);      
        translate([-3,-14.1,5])cylinder(h=1, r=0.25,$fn=60);  
        }
        translate([ 3, 14.1,5])cylinder(h=1, r=0.5,$fn=60);  
        translate([-3, 14.1,5])cylinder(h=1, r=0.5,$fn=60);      
        translate([ 3,-14.1,5])cylinder(h=1, r=0.5,$fn=60);      
        translate([-3,-14.1,5])cylinder(h=1, r=0.5,$fn=60);  
        
        }
        
        
        module port_2x1_old(){
        difference(){
        hull(){
        translate([ 5.5, 7,-1])cylinder(h=11, r=1,center=true,$fn=60);  
        translate([-5.5, 7,-1])cylinder(h=11, r=1,center=true,$fn=60);      
        translate([ 5.5,-8,-1])cylinder(h=11, r=1,center=true,$fn=60);      
        translate([-5.5,-8,-1])cylinder(h=11, r=1,center=true,$fn=60);  
        } 
        hull(){
        translate([ 3.3, 3.7,0])cylinder(h=10, r=0.25,center=true,$fn=60);  
        translate([-3.3, 3.7,0])cylinder(h=10, r=0.25,center=true,$fn=60);      
        translate([ 3.3,-3.7,0])cylinder(h=10, r=0.25,center=true,$fn=60);      
        translate([-3.3,-3.7,0])cylinder(h=10, r=0.25,center=true,$fn=60);  
        }   
        hull(){
        translate([ 2.6, 3.0,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);  
        translate([-2.6, 3.0,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);      
        translate([ 2.6,-3.0,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);      
        translate([-2.6,-3.0,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);  
        } 
        translate([ 3.3, 3.7,0])cylinder(h=10, r=0.7,center=true,$fn=60);  
        translate([-3.3, 3.7,0])cylinder(h=10, r=0.7,center=true,$fn=60);      
        translate([ 3.3,-3.7,0])cylinder(h=10, r=0.7,center=true,$fn=60);      
        translate([-3.3,-3.7,0])cylinder(h=10, r=0.7,center=true,$fn=60);  
        }
        //translate([-2,0,10]) cube([11,7.5,11],center=true,$fn=30);
        } 

        module port_8x1_old(){
        difference(){
        hull(){
        translate([ 5.5, 20,-1])cylinder(h=11, r=1,center=true,$fn=60);  
        translate([-5.5, 20,-1])cylinder(h=11, r=1,center=true,$fn=60);      
        translate([ 5.5,-20,-1])cylinder(h=11, r=1,center=true,$fn=60);      
        translate([-5.5,-20,-1])cylinder(h=11, r=1,center=true,$fn=60);  
        }
        hull(){
        translate([ 3.3, 14.4,0])cylinder(h=10, r=0.25,center=true,$fn=60);  
        translate([-3.3, 14.4,0])cylinder(h=10, r=0.25,center=true,$fn=60);      
        translate([ 3.3,-14.4,0])cylinder(h=10, r=0.25,center=true,$fn=60);      
        translate([-3.3,-14.4,0])cylinder(h=10, r=0.25,center=true,$fn=60);  
        }  
        hull(){
        translate([ 2.6, 13.7,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);  
        translate([-2.6, 13.7,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);      
        translate([ 2.6,-13.7,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);      
        translate([-2.6,-13.7,-6.1])cylinder(h=3, r=0.25,center=true,$fn=60);  
        }
        translate([ 3.3, 14.4,0])cylinder(h=10, r=0.7,center=true,$fn=60);  
        translate([-3.3, 14.4,0])cylinder(h=10, r=0.7,center=true,$fn=60);      
        translate([ 3.3,-14.4,0])cylinder(h=10, r=0.7,center=true,$fn=60);      
        translate([-3.3,-14.4 ,0])cylinder(h=10, r=0.7,center=true,$fn=60);  
        }
        //translate([-2,0,10]) cube([11,28,11],center=true,$fn=30); 
        }   
       
  
        

module top_box(){ 
    difference(){         
            union(){
            difference(){ 
            hull(){
            translate([ 40.5,332, 63]) rotate([90,0,0]) cylinder(h=70, r=0.5,center=true,$fn=60); 
            translate([-40.5,332, 63]) rotate([90,0,0]) cylinder(h=70, r=0.5,center=true,$fn=60); 
            translate([ 40.5,307,119]) rotate([90,0,0]) cylinder(h=20, r=0.5,center=true,$fn=60); 
            translate([-40.5,307,119]) rotate([90,0,0]) cylinder(h=20, r=0.5,center=true,$fn=60);}          
            hull(){
            translate([ 34,321, 70.5]) rotate([90,0,0]) cylinder(h=60, r=0.5,center=true,$fn=60); 
            translate([-34,321, 70.5]) rotate([90,0,0]) cylinder(h=60, r=0.5,center=true,$fn=60); 
            translate([ 34,304.5,112.5]) rotate([90,0,0]) cylinder(h=19, r=0.5,center=true,$fn=60); 
            translate([-34,304.5,112.5]) rotate([90,0,0]) cylinder(h=19, r=0.5,center=true,$fn=60);}
            }
            mounts();             
            hull(){
            translate([25,320,60]) cylinder(h=6, r=1.7,center=true,$fn=60); 
            translate([25,350,60]) cylinder(h=6, r=1.7,center=true,$fn=60);} 
            hull(){
            translate([-25,320,60]) cylinder(h=6, r=1.7,center=true,$fn=60); 
            translate([-25,350,60]) cylinder(h=6, r=1.7,center=true,$fn=60);}
            }
            
            union(){

            translate([0,325,105])  rotate([0,-42,90]) Ypipe();            
            hull(){
                translate([-38,301,74.4]) rotate([0,90,0]) cylinder(h=8, r=4.4,center=true,$fn=60);
                translate([-38,295,74.4]) rotate([0,90,0]) cylinder(h=8, r=4.4,center=true,$fn=60);}
       
            translate([ 30,336, 86.25]) rotate([90,0,0]) cylinder(h=80, r=1.4,center=true,$fn=60); 
            translate([-30,336, 86.25]) rotate([90,0,0]) cylinder(h=80, r=1.4,center=true,$fn=60);          
            translate([ 30,342, 86.25]) rotate([90,0,0]) cylinder(h=80, r=3,center=true,$fn=60); 
            translate([-30,342, 86.25]) rotate([90,0,0]) cylinder(h=80, r=3,center=true,$fn=60);
            }}   
            } 
 
module mounts(){           
            difference(){   
            union(){
            hull(){
            translate([40.5,332, 86.3]) rotate([90,0,0]) cylinder(h=70, r=7.5,center=true,$fn=60);   
            translate([30,332, 86.3]) rotate([90,0,0]) cylinder(h=70, r=7.5,center=true,$fn=60);}     
            hull(){
            translate([-40.5,332, 86.3]) rotate([90,0,0]) cylinder(h=70, r=7.5,center=true,$fn=60);   
            translate([-30,332, 86.3]) rotate([90,0,0]) cylinder(h=70, r=7.5,center=true,$fn=60);}     
            }     
            difference(){   
            hull(){
            translate([ 50.5,332, 53]) rotate([90,0,0]) cylinder(h=130, r=0.5,center=true,$fn=60); 
            translate([-50.5,332, 53]) rotate([90,0,0]) cylinder(h=130, r=0.5,center=true,$fn=60); 
            translate([ 50.5,307,129]) rotate([90,0,0]) cylinder(h=80, r=0.5,center=true,$fn=60); 
            translate([-50.5,307,129]) rotate([90,0,0]) cylinder(h=80, r=0.5,center=true,$fn=60);}            
            hull(){
            translate([ 40.5,332, 63]) rotate([90,0,0]) cylinder(h=70, r=0.5,center=true,$fn=60); 
            translate([-40.5,332, 63]) rotate([90,0,0]) cylinder(h=70, r=0.5,center=true,$fn=60); 
            translate([ 40.5,307,119]) rotate([90,0,0]) cylinder(h=20, r=0.5,center=true,$fn=60); 
            translate([-40.5,307,119]) rotate([90,0,0]) cylinder(h=20, r=0.5,center=true,$fn=60);}           
            }             
            }
        }
    
module Ypipe(){
       translate([0,0,0]) rotate([0,90,0]) cylinder(h=8, r=4.4,center=true,$fn=60);
       translate([-1,-8,0]) rotate([0,90,0]) cylinder(h=8, r=1,center=true,$fn=60);
       translate([-1,8,0]) rotate([0,90,0]) cylinder(h=8, r=1.3,center=true,$fn=60);}   
    
module elektronic_box_base(){ 
difference(){ union(){
 ////base
         hull(){
            translate([ 40.5,301, 61.5]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60); 
            translate([-40.5,301, 61.5]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60); 
            translate([ 40.5,301,-72.5]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60); 
            translate([-40.5,301,-72.5]) rotate([90,0,0]) cylinder(h=8, r=0.5,center=true,$fn=60); 
            }        
            translate([ 18,293,-49]) rotate([90,0,0]) cylinder(h=8, r=5,center=true,$fn=60);  
            translate([-18,293,-49]) rotate([90,0,0]) cylinder(h=8, r=5,center=true,$fn=60); 
            }

        ////outcuts
         //screws back
        hull(){
            translate([ 18,301,70]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            translate([-18,301,70]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);   
            translate([ 14,301,47]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            translate([-14,301,47]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);}
        hull(){
            translate([ 29,301, 15]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            translate([-29,301, 15]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60); 
            translate([ 29,301,-42]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            translate([-29,301,-42]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);}
        ////Sb25 Port
        hull(){
            translate([ 18.5,301,50]) rotate([90,0,0]) cylinder(h=10, r=2.6,center=true,$fn=60);       
            translate([-18.5,301,50]) rotate([90,0,0]) cylinder(h=10, r=2.6,center=true,$fn=60); 
            translate([ 17.5,301,44]) rotate([90,0,0]) cylinder(h=10, r=2.6,center=true,$fn=60);       
            translate([-17.5,301,44]) rotate([90,0,0]) cylinder(h=10, r=2.6,center=true,$fn=60);} 
            
            translate([ 23.5,305,47]) rotate([90,0,0]) cylinder(h=10, r=0.8,center=true,$fn=60);       
            translate([-23.5,305,47]) rotate([90,0,0]) cylinder(h=10, r=0.8,center=true,$fn=60);
            
        hull(){
            translate([ 25.2,299,51.8]) rotate([90,0,0]) cylinder(h=4.8, r=1.7,center=true,$fn=60);       
            translate([-25.2,299,51.8]) rotate([90,0,0]) cylinder(h=4.8, r=1.7,center=true,$fn=60); 
            translate([ 25.2,299,42.2]) rotate([90,0,0]) cylinder(h=4.8, r=1.7,center=true,$fn=60);       
            translate([-25.2,299,42.2]) rotate([90,0,0]) cylinder(h=4.8, r=1.7,center=true,$fn=60);} 
            
            ////cover screws
            translate([ 36.5,301, 57.5]) rotate([90,0,0]) cylinder(h=10, r=1.5,center=true,$fn=60); 
            translate([-36.5,301, 57.5]) rotate([90,0,0]) cylinder(h=10, r=1.5,center=true,$fn=60); 
            translate([ 36.5,301,-68.5]) rotate([90,0,0]) cylinder(h=10, r=1.5,center=true,$fn=60); 
            translate([-36.5,301,-68.5]) rotate([90,0,0]) cylinder(h=10, r=1.5,center=true,$fn=60); 
            translate([ 36.5,298.99, 57.5]) rotate([90,0,0]) cylinder(h=4, r=3.2,center=true,$fn=60); 
            translate([-36.5,298.99, 57.5]) rotate([90,0,0]) cylinder(h=4, r=3.2,center=true,$fn=60); 
            translate([ 36.5,298.99,-68.5]) rotate([90,0,0]) cylinder(h=4, r=3.2,center=true,$fn=60); 
            translate([-36.5,298.99,-68.5]) rotate([90,0,0]) cylinder(h=4, r=3.2,center=true,$fn=60);
   
            translate([0,0,0]) arduino_neg();
            stamp_stage_negative();    
            translate([0,301,10]) rotate([90,0,0]) cylinder(h=16.5, r=20,center=true,$fn=60);
            translate([0,301,-84]) rotate([90,0,0]) cylinder(h=16.5, r=28,center=true,$fn=60);
    }
}

module elektronic_box_cover(){
    difference(){
    //union(){
            hull(){
            translate([ 40.5,336, 61.5]) rotate([90,0,0]) cylinder(h=62, r=0.5,center=true,$fn=60); 
            translate([-40.5,336, 61.5]) rotate([90,0,0]) cylinder(h=62, r=0.5,center=true,$fn=60); 
            translate([ 40.5,336,-72.5]) rotate([90,0,0]) cylinder(h=62, r=0.5,center=true,$fn=60); 
            translate([-40.5,336,-72.5]) rotate([90,0,0]) cylinder(h=62, r=0.5,center=true,$fn=60);}
            
            translate([ 36.5,308.9, 57.5]) rotate([90,0,0]) cylinder(h=8, r=0.8,center=true,$fn=60); 
            translate([-36.5,308.9, 57.5]) rotate([90,0,0]) cylinder(h=8, r=0.8,center=true,$fn=60); 
            translate([ 36.5,308.9,-68.5]) rotate([90,0,0]) cylinder(h=8, r=0.8,center=true,$fn=60); 
            translate([-36.5,308.9,-68.5]) rotate([90,0,0]) cylinder(h=8, r=0.8,center=true,$fn=60); 

            for(i=[0,10,20,30,40,50,60,70,80,90,100]){
            color("black")hull(){
            translate([ 25,363, 45-i]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60); 
            translate([-25,363, 45-i]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);
            } 
            }
            for(i=[0,20,40,60,,80,100]){
            color("black")hull(){
            translate([ 37,320, 45-i]) rotate([0,90,0]) cylinder(h=10, r=2,center=true,$fn=60); 
            translate([ 37,352, 45-i]) rotate([0,90,0]) cylinder(h=10, r=2,center=true,$fn=60);
            }} 
            for(i=[40,60,,80,100]){
            color("black")hull(){
            translate([-37,320, 45-i]) rotate([0,90,0]) cylinder(h=10, r=2,center=true,$fn=60); 
            translate([-37,350 , 45-i]) rotate([0,90,0]) cylinder(h=10, r=2,center=true,$fn=60);
            } 
            }
            for(i=[0,10,20,30,40,50]){
            color("black")hull(){
            translate([25-i,320,-70]) cylinder(h=10, r=2,center=true,$fn=60); 
            translate([25-i,350,-70]) cylinder(h=10, r=2,center=true,$fn=60);
            } 
            }
            for(i=[0,10,20,30,40,50]){
            color("black")hull(){
            translate([25-i,320,58]) cylinder(h=10, r=2,center=true,$fn=60); 
            translate([25-i,350,58]) cylinder(h=10, r=2,center=true,$fn=60);
            } 
            }
            translate([0,-0.01,0]) arduino_neg();
            }
    }

module stamp_stage_negative(){ 
    union(){$fn=60; 
        translate([0,0,69]) cube([45,45,38],center=true);
        ////top stemp holder (adjust y for visbility)
        translate([0,4,109]) cube([70,62,11],center=true);       
        //translate([0,-25, 91]) cube([70,4,25],center=true);
        
        translate([-29,-25.5,116]) cube([7,4,5],center=true);
        translate([29,-25.5,116]) cube([7,4,5],center=true);}        
        for(i=[-1,1]){
            translate([i*37,133,80.5]) cube([6.5,311,66],center=true);
            translate([i*37,150,29]) cube([6.5,277,39],center=true);
            translate([i*37,247,-22.5]) cube([6.5,83,66],center=true);}
        //safetyswitch rods
        translate([-34,-15,78]) rotate([0,90,0]) cylinder(h=13, r=1.5,center=true,center=true,$fn=60); 
        translate([-34,-6,100]) rotate([0,90,0]) cylinder(h=13, r=1.5,center=true,center=true,$fn=60); 
        //roller
        translate([0,28,27]) rotate([0,90,0]) cylinder(h=70, r=4,center=true,center=true,$fn=60); 
        //shield cutout
        difference(){
            hull(){
                translate([ 34,-22,112.75])cylinder(h=3.5, r=7.01,center=true,$fn=60); 
                translate([-34,-22,112.75])cylinder(h=3.5, r=7.01,center=true,$fn=60);}
            hull(){
                translate([ 54,-14.8,112.5])cylinder(h=4, r=7.01,center=true,$fn=60); 
                translate([-54,-14.8,112.5])cylinder(h=4, r=7.01,center=true,$fn=60);}
            }
        //screws
        color("red") union(){
        translate([30,27,114]) cylinder(h=10, r=1.5,center=true,$fn=60); 
        //translate([30,27,118.1]) cylinder(h=3, r=3,center=true,$fn=60); 
        translate([-30,27,114]) cylinder(h=10, r=1.5,center=true,$fn=60); 
        //translate([-30,27,118.1]) cylinder(h=3, r=3,center=true,$fn=60); 

        translate([-16,21,140]) rotate([135,0,0])monitor_screws();
        translate([ 22,21,140]) rotate([135,0,0])monitor_screws();
        hull(){    
        translate([0,15,130]) rotate([80,0,0]) cylinder(h=45, r=8,center=true,$fn=60);      
        translate([0,10,135]) rotate([80,0,0]) cylinder(h=30, r=8,center=true,$fn=60);  
        translate([0,40,118]) rotate([0,0,0]) cylinder(h=15, r=7,center=true,$fn=60);}
        } 
        //opening
        translate([0,98.5,116.5]) rotate([45,0,0]) cube([16,19,10],center=true); 
        translate([0,100,114]) cube([16,5,5],center=true);  
        //screws back
        translate([ 36.5,291.75,55]) rotate([90,0,0]) cylinder(h=10, r=1.5,center=true,$fn=60); 
        translate([ 36.5,294.6,55]) rotate([90,0,0]) cylinder(h=  4, r=3,center=true,$fn=60); 
        translate([-36.5,291.75,55]) rotate([90,0,0]) cylinder(h=10, r=1.5,center=true,$fn=60);   
        translate([-36.5,294.6,55]) rotate([90,0,0]) cylinder(h=  4, r=3,center=true,$fn=60); 
        
             
         translate([-9,260,79]) cube([50,50,63],center=true);
         translate([-9,260,20]) cylinder(h=66, r1=16,r2=17.5,center=true,$fn=60); 
         //gas suply
         translate([-12,294,77]) rotate([90,0,0]) cylinder(h=18, r=8,center=true,$fn=60);  
         
         //laser cutout
         hull(){
         translate([-32,-9,76]) rotate([0,90,0]) cylinder(h=18, r=2,center=true,center=true,$fn=60); 
         translate([-32, 9,76]) rotate([0,90,0]) cylinder(h=18, r=2,center=true,center=true,$fn=60);  
         translate([-32,-9,47]) rotate([0,90,0]) cylinder(h=18, r=2,center=true,center=true,$fn=60); 
         translate([-32, 9,47]) rotate([0,90,0]) cylinder(h=18, r=2,center=true,center=true,$fn=60);}
         translate([-28,-15,63]) rotate([90,0,0]) cylinder(h=20, r=3,center=true,$fn=60);  
 }  

module monitor_screws(){
    translate([0,0,16]) cylinder(h=11.1, r=1.7,$fn=60);  
    translate([0,0,6]) cylinder(h=10.1, r=2.2,$fn=60);
    translate([0,0,-29]) cylinder(h=36, r=5,$fn=60); 
    }  
    
module arduino_neg(){     
            translate([0,332.5,-5.5]) cube([66,55,120],center=true,$fn=30); 
    
            ////ports Bohrungsabstand 14,5 mm
            translate([-35,345,46.5]) rotate([0,90]) cylinder(h=15,r=1.5,$fn=60,center=true);      
            translate([-35,345,17.5]) rotate([0,90]) cylinder(h=15,r=1.5,$fn=60,center=true);     
            translate([-35,345,32]) cube([15,10.5,11.5],center=true,$fn=30);   
            
            translate([-35,330,40 ]) rotate([0,90]) cylinder(h=15,r=4,$fn=60,center=true);     
            ////for 24V temporaely
            hull(){
            translate([-35,319,42 ]) rotate([0,90]) cylinder(h=15,r=2,$fn=60,center=true);     
            translate([-35,319,38 ]) rotate([0,90]) cylinder(h=15,r=2,$fn=60,center=true);}
    
            hull(){
            translate([-34.99,342.9,46.5]) rotate([0,90]) cylinder(h=4,r=8,$fn=60,center=true);      
            translate([-34.99,342.9,17.5]) rotate([0,90]) cylinder(h=4,r=8,$fn=60,center=true);  
            translate([-34.99,346.9,46.5]) rotate([0,90]) cylinder(h=4,r=8,$fn=60,center=true);      
            translate([-34.99,346.9,17.5]) rotate([0,90]) cylinder(h=4,r=8,$fn=60,center=true);     
            translate([-34.99,319.9,40 ]) rotate([0,90]) cylinder(h=4,r=8,$fn=60,center=true);     
            }
    
            ////posts
            translate([ 21,298, 23.5]) rotate([90,0,0]) cylinder(h=16, r=0.95,center=true,$fn=60); 
            translate([-27,298, 22.5]) rotate([90,0,0]) cylinder(h=16, r=0.95,center=true,$fn=60); 
            translate([ 21,298,-60.5]) rotate([90,0,0]) cylinder(h=16, r=0.95,center=true,$fn=60); 
            translate([-27,298,-52.5]) rotate([90,0,0]) cylinder(h=16, r=0.95,center=true,$fn=60);
            }

module spacer(){
    difference(){ union(){
    //arduino
            translate([ 21,307,23.5]) rotate([90,0,0]) cylinder(h=1.4, r=2.6,center=true,$fn=60); 
            translate([-27,307,22.5]) rotate([90,0,0]) cylinder(h=1.4, r=2.6,center=true,$fn=60); 
            translate([ 21,307,-60.5]) rotate([90,0,0]) cylinder(h=1.4, r=2.6,center=true,$fn=60); 
            translate([-27,307,-52.5]) rotate([90,0,0]) cylinder(h=1.4, r=2.6,center=true,$fn=60);}  
            //translate([0,314,-15]) cube([54,10,105],center=true);
     translate([ 21,307,23.5]) rotate([90,0,0]) cylinder(h=30, r=1.4,center=true,$fn=60); 
     translate([-27,307,22.5]) rotate([90,0,0]) cylinder(h=30, r=1.4,center=true,$fn=60); 
     translate([ 21,307,-60.5]) rotate([90,0,0]) cylinder(h=30, r=1.4,center=true,$fn=60); 
     translate([-27,307,-52.5]) rotate([90,0,0]) cylinder(h=30, r=1.4,center=true,$fn=60);} 
}

module purger(){
    difference(){ 
        union(){
            
            hull(){
                translate([23.5,23.5,45]) sphere (r=1,$fn=60);               
                translate([23.5,38,45]) sphere (r=1,$fn=60); 
                translate([10,23.5,70]) sphere (r=1,$fn=60);               
                translate([10,38,70]) sphere (r=1,$fn=60);  
                translate([23.5,23.5,100]) sphere (r=1,$fn=60);               
                translate([23.5,38,100]) sphere (r=1,$fn=60); 
                translate([8.5,23.5,45]) sphere (r=1,$fn=60);               
                translate([8.5,38,45]) sphere (r=1,$fn=60); }
            hull(){
                translate([32.5,12.5,49]) sphere (r=1,$fn=60); 
                translate([32.5,12.5,45]) sphere (r=1,$fn=60); 
                translate([32.5,38,49]) sphere (r=1,$fn=60); 
                translate([32.5,38,45]) sphere (r=1,$fn=60); 
                translate([2,38,49]) sphere (r=1,$fn=60); 
                translate([2,38,45]) sphere (r=1,$fn=60);
                translate([2,20,49]) sphere (r=1,$fn=60); 
                translate([2,20,45]) sphere (r=1,$fn=60);
                translate([20,12.5,49]) sphere (r=1,$fn=60); 
                translate([20,12.5,45]) sphere (r=1,$fn=60);}  
              
                translate([17,17,51]) cylinder(h=2, r=1.8,center=true,$fn=60);  
            ////pipe           
            difference(){
            translate([0,0,0]) rotate([-30.1,10.2,0]) cylinder(h=55.5, r1=1.5, r2=5,$fn=60);
            translate([0,0,0]) rotate([-30.1,10.2,0]) cylinder(h=33, r=6,$fn=60);
            cube ([10,10,10],center=true);}
            translate([5,16.5,28]) sphere (r=3.6,$fn=60); 
            }           
        ////fitting
        translate([18,35,60]) rotate([-90,0,0]) cylinder(h=9, r=4.1,center=true,$fn=60);
        translate([18,29,60]) rotate([-90,0,0]) cylinder(h=5, r=1.3,center=true,$fn=60);
        hull(){ 
        translate([18,26.5,60]) rotate([-90,0,0]) cylinder(h=2.6, r=1.3,center=true,$fn=60);
        translate([12,26.5,50]) rotate([-90,0,0]) cylinder(h=2.6, r=1.3,center=true,$fn=60);} 
        hull(){ 
        translate([12,26.5,50]) rotate([-90,0,0]) cylinder(h=2.6, r=1.3,center=true,$fn=60); 
        translate([8.2,26.5,47]) rotate([-90,0,0]) cylinder(h=2.6, r=1.3,center=true,$fn=60);} 
        hull(){   
        translate([8.15,26.5,47]) rotate([-90,0,0]) cylinder(h=2.6, r=1.3,center=true,$fn=60);    
        translate([8.15,26.5,45]) rotate([-90,0,0]) cylinder(h=2.6, r=1.3,center=true,$fn=60);}    
            
        translate([0,0,0]) rotate([-30.1,10.2,0]) cylinder(h=53.2, r1=2.3, r2=1.3,$fn=60);    
        ////srews
        translate([30,27,105]) cylinder(h=24, r=1.3,center=true,$fn=60);
        } 
    }
    
module monitor_all(){ 
        difference(){ 
        translate([0,22,180]) rotate([45,0,0]) union(){
  
        //monitor_front();
        color("grey") union(){
        translate([0,0,0]) monitor_back();
        translate([0,0,0]) monitor_back2();
        translate([0,0,0]) monitor_back3();
        translate([0,-140,-110]) rotate([-45,0,0]) monitor_mount();}
        }
 color("green") union(){
        //stamp_cover_neg();
        //stamp_stage_negative();
        //monitor_mount_neg();   
    }     }
}      
        
    module monitor_front(){
         difference(){
            color ("grey")hull(){
                translate([ 122.5, 84,1]) sphere (r=1,$fn=60);               
                translate([ 122.5,-84,1]) sphere (r=1,$fn=60); 
                translate([-122.5, 84,1]) sphere (r=1,$fn=60);               
                translate([-122.5,-84,1]) sphere (r=1,$fn=60);  
                translate([ 122.5, 84,11]) sphere (r=1,$fn=60);               
                translate([ 122.5,-84,11]) sphere (r=1,$fn=60); 
                translate([-122.5, 84,11]) sphere (r=1,$fn=60);               
                translate([-122.5,-84,11]) sphere (r=1,$fn=60);} 
                 
            color ("grey")hull(){
                translate([ 107, 70,9]) sphere (r=1,$fn=60);               
                translate([ 107,-63,9]) sphere (r=1,$fn=60); 
                translate([-107, 70,9]) sphere (r=1,$fn=60);               
                translate([-107,-63,9]) sphere (r=1,$fn=60);  
                translate([ 110, 73,11.1]) sphere (r=1,$fn=60);               
                translate([ 110,-66,11.1]) sphere (r=1,$fn=60); 
                translate([-110, 73,11.1]) sphere (r=1,$fn=60);               
                translate([-110,-66,11.1]) sphere (r=1,$fn=60);}  

            hull(){
                translate([ 120.75, 82.25,0]) sphere (r=1,$fn=60);               
                translate([ 120.75,-82.25,0]) sphere (r=1,$fn=60); 
                translate([-120.75, 82.25,0]) sphere (r=1,$fn=60);               
                translate([-120.75,-82.25,0]) sphere (r=1,$fn=60);  
                translate([ 120.75, 82.25,5]) sphere (r=1,$fn=60);               
                translate([ 120.75,-82.25,5]) sphere (r=1,$fn=60); 
                translate([-120.75, 82.25,5]) sphere (r=1,$fn=60);               
                translate([-120.75,-82.25,5]) sphere (r=1,$fn=60);} 
            }
            color ("black") hull(){
                translate([ 107, 70,9]) sphere (r=1,$fn=60);               
                translate([ 107,-63,9]) sphere (r=1,$fn=60); 
                translate([-107, 70,9]) sphere (r=1,$fn=60);               
                translate([-107,-63,9]) sphere (r=1,$fn=60);}  
            ////posts                          
            translate([ 117.75, 79.25,3]) cylinder(h=5, r=2.3, $fn=60);                  
            translate([         0, 79.25,3]) cylinder(h=5, r=2.3, $fn=60);           
            translate([-117.75, 79.25,3]) cylinder(h=5, r=2.3, $fn=60);                
         
            translate([-116.5,-78.25,3]) cylinder(h=5, r=2.3, $fn=60); 
            translate([     -20,-78.25,3]) cylinder(h=5, r=2.3, $fn=60);    
            translate([ 116.5,-78.25,3]) cylinder(h=5, r=2.3, $fn=60); 
         
            ////buttons
            color ("red") translate([101.5,-76,12]) cylinder(h=1, r=2, $fn=60);        
            color ("black") translate([101.5,-76,11.5]) cylinder(h=0.9, r=2.5, $fn=60);  
            color ("black") union(){ 
                hull(){    
                translate([90,-73,12]) cylinder(h=1, r=1.5, $fn=60);
                translate([80,-73,12]) cylinder(h=1, r=1.5, $fn=60);}
                hull(){    
                translate([73,-73,12]) cylinder(h=1, r=1.5, $fn=60);
                translate([63,-73,12]) cylinder(h=1, r=1.5, $fn=60);}
                  hull(){    
                translate([56,-73,12]) cylinder(h=1, r=1.5, $fn=60);
                translate([46,-73,12]) cylinder(h=1, r=1.5, $fn=60);}
                  hull(){    
                translate([39,-73,12]) cylinder(h=1, r=1.5, $fn=60);
                translate([29,-73,12]) cylinder(h=1, r=1.5, $fn=60);}
                  hull(){    
                translate([22,-73,12]) cylinder(h=1, r=1.5, $fn=60);
                translate([12,-73,12]) cylinder(h=1, r=1.5, $fn=60);}
                }      
        }

    module monitor_back(){ 
            difference(){union(){    
            ////posts                 
            translate([ 117.75, 79.25,0.75]) cylinder(h=2.2, r=3, $fn=60);                  
            translate([         0, 79.25,0.75]) cylinder(h=2.2, r=3, $fn=60);           
            translate([-117.75, 79.25,0.75]) cylinder(h=2.2, r=3, $fn=60);                
         
            translate([-116.5,-78.25,0.75]) cylinder(h=2.2, r=3, $fn=60); 
            translate([     -20,-78.25,0.75]) cylinder(h=2.2, r=3, $fn=60);    
            translate([ 116.5,-78.25,0.75]) cylinder(h=2.2, r=3, $fn=60); 
            ////frame
            difference(){
            hull(){
            translate([ 119.75, 81.25,0.75]) cylinder(h=2.2, r=1, $fn=60);                  
            translate([ 119.75,-81.25,0.75]) cylinder(h=2.2, r=1, $fn=60);    
            translate([-119.75, 81.25,0.75]) cylinder(h=2.2, r=1, $fn=60);                
            translate([-119.75,-81.25,0.75]) cylinder(h=2.2, r=1, $fn=60);} 
    
            hull(){
            translate([ 118.75, 80.25,0.7]) cylinder(h=2.5, r=1, $fn=60);                  
            translate([ 118.75,-80.25,0.7]) cylinder(h=2.5, r=1, $fn=60);    
            translate([-118.75, 80.25,0.7]) cylinder(h=2.5, r=1, $fn=60);                
            translate([-118.75,-80.25,0.7]) cylinder(h=2.5, r=1, $fn=60);} 
            }
            ////base
            hull(){
                translate([ 120.25, 81.75,-0.3]) sphere (r=1.1,$fn=60);               
                translate([ 120.25,-81.75,-0.3]) sphere (r=1.1,$fn=60); 
                translate([-120.25, 81.75,-0.3]) sphere (r=1.1,$fn=60);               
                translate([-120.25,-81.75,-0.3]) sphere (r=1.1,$fn=60);  
                translate([ 120.25, 81.75,-1.2]) sphere (r=1.1,$fn=60);               
                translate([ 120.25,-81.75,-1.2]) sphere (r=1.1,$fn=60); 
                translate([-120.25, 81.75,-1.2]) sphere (r=1.1,$fn=60);               
                translate([-120.25,-81.75,-1.2]) sphere (r=1.1,$fn=60);
            } 
            }    
            ////srews               
            translate([ 117.75, 79.25,0.8]) cylinder(h=2.2, r=1.4, $fn=60);                  
            translate([         0, 79.25,0.8]) cylinder(h=2.2, r=1.4, $fn=60);           
            translate([-117.75, 79.25,0.8]) cylinder(h=2.2, r=1.4, $fn=60);                
         
            translate([-116.5,-78.25,0.8]) cylinder(h=2.2, r=1.4, $fn=60); 
            translate([     -20,-78.25,0.8]) cylinder(h=2.2, r=1.4, $fn=60);    
            translate([ 116.5,-78.25,0.8]) cylinder(h=2.2, r=1.4, $fn=60);
            
            translate([ 117.75, 79.25,0]) cylinder(h=1.5, r1=2.5, r2= 1.4, $fn=60);                  
            translate([         0, 79.25,0]) cylinder(h=1.5, r1=2.5, r2= 1.4, $fn=60);           
            translate([-117.75, 79.25,0]) cylinder(h=1.5, r1=2.5, r2= 1.4, $fn=60);                
         
            translate([-116.5,-78.25,0]) cylinder(h=1.5, r1=2.5, r2= 1.4, $fn=60); 
            translate([     -20,-78.25,0]) cylinder(h=1.5, r1=2.5, r2= 1.4, $fn=60);    
            translate([ 116.5,-78.25,0]) cylinder(h=1.5, r1=2.5, r2= 1.4, $fn=60);
            
            translate([ 117.75, 79.25,-3.19]) cylinder(h=3.2, r=2.5, $fn=60);                  
            translate([         0, 79.25,-3.19]) cylinder(h=3.2, r=2.5, $fn=60);           
            translate([-117.75, 79.25,-3.19]) cylinder(h=3.2, r=2.5, $fn=60);                
         
            translate([-116.5,-78.25,-3.19]) cylinder(h=3.2, r=2.5, $fn=60); 
            translate([     -20,-78.25,-3.19]) cylinder(h=3.2, r=2.5, $fn=60);    
            translate([ 116.5,-78.25,-3.19]) cylinder(h=3.2, r=2.5, $fn=60);
            ////outcut
            hull(){
            translate([ 80, 65,-3]) cylinder(h=5, r=1, $fn=60);                  
            translate([ 80,-05,-3]) cylinder(h=5, r=1, $fn=60);    
            translate([-80, 65,-3]) cylinder(h=5, r=1, $fn=60);                
            translate([-80,-05,-3]) cylinder(h=5, r=1, $fn=60);} 
            
            hull(){
            translate([ 13,-65,-3]) cylinder(h=5, r=1, $fn=60);                  
            translate([ 13,-15,-3]) cylinder(h=5, r=1, $fn=60);    
            translate([-13,-65,-3]) cylinder(h=5, r=1, $fn=60);                
            translate([-13,-15,-3]) cylinder(h=5, r=1, $fn=60);} 
            hull(){       
            translate([ 13,-15,-3]) cylinder(h=5, r=1, $fn=60);    
            translate([-13,-15,-3]) cylinder(h=5, r=1, $fn=60);       
            translate([ 23,-05,-3]) cylinder(h=5, r=1, $fn=60);                          
            translate([-23,-05,-3]) cylinder(h=5, r=1, $fn=60);} 
            ////screws
            translate([ 84, 69,-3]) cylinder(h=5, r=1.6, $fn=60);                  
            translate([ 84,-09,-3]) cylinder(h=5, r=1.6, $fn=60);    
            translate([-84, 69,-3]) cylinder(h=5, r=1.6, $fn=60);                
            translate([-84,-09,-3]) cylinder(h=5, r=1.6, $fn=60); 
            translate([   0, 69,-3]) cylinder(h=5, r=1.6, $fn=60); 

            translate([-25, -20,-3]) cylinder(h=5, r=1.6, $fn=60);                
            translate([ 25,-20,-3]) cylinder(h=5, r=1.6, $fn=60); 
            translate([-25, -55,-3]) cylinder(h=5, r=1.6, $fn=60);                
            translate([ 25,-55,-3]) cylinder(h=5, r=1.6, $fn=60); 
            }
    }

    module monitor_back2(){ 
            difference(){ 
            union(){difference(){hull(){
            translate([ 86, 71,-17.25]) cylinder(h=15, r=2, $fn=60);                  
            translate([ 86,-11,-17.25]) cylinder(h=15, r=2, $fn=60);    
            translate([-86, 71,-17.25]) cylinder(h=15, r=2, $fn=60);                
            translate([-86,-11,-17.25]) cylinder(h=15, r=2, $fn=60);}
            hull(){
            translate([ 83, 68,-14.25]) cylinder(h=15, r=2, $fn=60);                  
            translate([ 83,-08,-14.25]) cylinder(h=15, r=2, $fn=60);    
            translate([-83, 68,-14.25]) cylinder(h=15, r=2, $fn=60);                
            translate([-83,-08,-14.25]) cylinder(h=15, r=2, $fn=60);} 
            hull(){
            translate([ 13, 0,-14.25]) cylinder(h=15, r=2, $fn=60);                  
            translate([ 13,-18,-14.25]) cylinder(h=15, r=2, $fn=60);    
            translate([-13, 0,-14.25]) cylinder(h=15, r=2, $fn=60);                
            translate([-13,-18,-14.25]) cylinder(h=15, r=2, $fn=60);}
            
            for(i=[0,10,20,30,40,50,60,70,80,90,100,110 ]){
            hull(){
            translate([-55+i,5,-16]) cylinder(h=4, r=2,center=true,$fn=60); 
            translate([-55+i,55,-16]) cylinder(h=4, r=2,center=true,$fn=60);
            }
            }
 
            }
            translate([ 15,-11.5,-17.25]) cylinder(h=15, r=1.5, $fn=60);                  
            translate([-15,-11.5,-17.25]) cylinder(h=15, r=1.5, $fn=60);  
            

            translate([ 84, 69,-17.25]) cylinder(h=15, r=4, $fn=60);                  
            translate([ 84,-09,-17.25]) cylinder(h=15, r=4, $fn=60);    
            translate([-84, 69,-17.25]) cylinder(h=15, r=4, $fn=60);                
            translate([-84,-09,-17.25]) cylinder(h=15, r=4, $fn=60); 
            translate([   0, 69,-17.25]) cylinder(h=15, r=4, $fn=60); 
            
            translate([ 70,54,-17.25]) cylinder(h=15, r=2.5, $fn=60);                  
            translate([ 70,06,-17.25]) cylinder(h=15, r=2.5, $fn=60);    
            translate([-70,54,-17.25]) cylinder(h=15, r=2.5, $fn=60);                
            translate([-70,06,-17.25]) cylinder(h=15, r=2.5, $fn=60); 
            
            }
            translate([ 84, 69,-7]) cylinder(h=5, r=1, $fn=60);                  
            translate([ 84,-09,-7]) cylinder(h=5, r=1, $fn=60);    
            translate([-84, 69,-7]) cylinder(h=5, r=1, $fn=60);                
            translate([-84,-09,-7]) cylinder(h=5, r=1, $fn=60); 
            translate([   0, 69,-7]) cylinder(h=5, r=1, $fn=60); 
            
            translate([ 70,54,-7]) cylinder(h=5, r=0.8, $fn=60);                  
            translate([ 70,06,-7]) cylinder(h=5, r=0.8, $fn=60);    
            translate([-70,54,-7]) cylinder(h=5, r=0.8, $fn=60);                
            translate([-70,06,-7]) cylinder(h=5, r=0.8, $fn=60); 
            
            }       
    }
    
    module monitor_back3(){   
            difference(){
            difference(){
            hull(){
            translate([37,-21,-68]) rotate([45,0,0]) cylinder(h=75, r=2, $fn=60);  
            translate([-37,-21,-68]) rotate([45,0,0]) cylinder(h=75, r=2, $fn=60);      
            translate([-37,-15.5,-17.25]) cylinder(h=15, r=2, $fn=60);                  
            translate([ 37,-15.5,-17.25]) cylinder(h=15, r=2, $fn=60);    
            translate([-37,-73,-7.25]) cylinder(h=5, r=2, $fn=60);                
            translate([ 37,-73,-7.25]) cylinder(h=5, r=2, $fn=60);
            }       
            union(){hull(){
            translate([-12,-13.5,-14.25]) cylinder(h=15, r=2, $fn=60);                  
            translate([ 12,-13.5,-14.25]) cylinder(h=15, r=2, $fn=60);  
            translate([-12,-35.5,-14.25]) cylinder(h=15, r=2, $fn=60);                  
            translate([ 12,-35.5,-14.25]) cylinder(h=15, r=2, $fn=60);}  
            hull(){
            translate([-12,-35.5,-14.25]) cylinder(h=15, r=2, $fn=60);                  
            translate([ 12,-35.5,-14.25]) cylinder(h=15, r=2, $fn=60);
            translate([-12,-62,-42]) cylinder(h=40, r=2, $fn=60);                
            translate([ 12,-62,-42]) cylinder(h=40, r=2, $fn=60);}
            hull(){
            translate([-12,-54,-42]) cylinder(h=40, r=2, $fn=60);                
            translate([ 12,-54,-42]) cylinder(h=40, r=2, $fn=60);
            translate([-12,-64,-42]) cylinder(h=40, r=2, $fn=60);                
            translate([ 12,-64,-42]) cylinder(h=40, r=2, $fn=60);}
        }
        }
            translate([-25, -20,-17]) cylinder(h=15, r=1, $fn=60);                
            translate([ 25,-20,-17]) cylinder(h=15, r=1, $fn=60); 
            translate([-25, -55,-17]) cylinder(h=15, r=1, $fn=60);                
            translate([ 25,-55,-17]) cylinder(h=15, r=1, $fn=60); 
       
        stamp_cover();
        stamp_stage_negative(); 
        }
 }    
    module monitor_mount(){
        difference(){
        union(){
        hull() {
        translate([ 8,15,120]) cylinder(h=12, r=2,center=true,$fn=60);  
        translate([-8,15,120]) cylinder(h=12, r=2,center=true,$fn=60);  
        translate([ 8,30,120]) cylinder(h=12, r=2,center=true,$fn=60);  
        translate([-8,30,120]) cylinder(h=12, r=2,center=true,$fn=60);}
        hull() {    
        translate([30,15,120]) cylinder(h=12, r=2,center=true,$fn=60);  
        translate([-30,15,120]) cylinder(h=12, r=2,center=true,$fn=60);  
        translate([30,-5,124]) cylinder(h=20, r=2,center=true,$fn=60);  
        translate([-30,-5,124]) cylinder(h=20, r=2,center=true,$fn=60);
        }} 
        stamp_stage_negative();
        translate([13,4,119]) cylinder(h=10, r=2,center=true,$fn=60);  
        translate([-25,4,119]) cylinder(h=10, r=2,center=true,$fn=60);  
        translate([13,4,131.5]) cylinder(h=15.1, r=4,center=true,$fn=60);  
        translate([-25,4,131.5]) cylinder(h=15.1, r=4,center=true,$fn=60); 
        }
 }     
        
    module monitor_mount_neg(){
        hull() {
        translate([ 8,15,120]) cylinder(h=13, r=2.5,center=true,$fn=60);  
        translate([-8,15,120]) cylinder(h=13, r=2.5,center=true,$fn=60);  
        translate([ 8,45,120]) cylinder(h=13, r=2.5,center=true,$fn=60);  
        translate([-8,45,120]) cylinder(h=13, r=2.5,center=true,$fn=60);}
        hull() {    
        translate([30,15,120]) cylinder(h=13, r=2.5,center=true,$fn=60);  
        translate([-30,15,120]) cylinder(h=13, r=2.5,center=true,$fn=60);  
        translate([30,-5,124]) cylinder(h=21, r=2.5,center=true,$fn=60);  
        translate([-30,-5,124]) cylinder(h=21, r=2.5,center=true,$fn=60);}
    }
    module monitor_mount_neg2(){
        hull() {
        translate([ 8,15,120]) cylinder(h=23, r=4,center=true,$fn=60);  
        translate([-8,15,120]) cylinder(h=23, r=4,center=true,$fn=60);  
        translate([ 8,45,120]) cylinder(h=23, r=4,center=true,$fn=60);  
        translate([-8,45,120]) cylinder(h=23, r=4,center=true,$fn=60);}
        hull() {    
        translate([30,15,120]) cylinder(h=23, r=4,center=true,$fn=60);  
        translate([-30,15,120]) cylinder(h=23, r=4,center=true,$fn=60);  
        translate([30,-5,124]) cylinder(h=31, r=4,center=true,$fn=60);  
        translate([-30,-5,124]) cylinder(h=31, r=4,center=true,$fn=60);}
    }    
    module stamp(){ 
    color("silver") union(){$fn=100;
        translate([0,0,(20)]) cylinder(h=20,r=9);
        translate([0,0,(30)]) cylinder(h=40,r=7);
        translate([0,0,(16)]) cylinder(h=4,r=4);
        translate([0,0,(14)]) cylinder(h=2,r1=2,r2=4);        
        translate([0,0,79]) cube([45,45,58],center=true);    
        translate([0,30,79]) cube([15,15,58],center=true);
        translate([0,4,109]) cube([70,62,11],center=true);    
        }  
    }
    
module nuc(){
        difference(){
            union(){
        difference(){
            union(){            
            ////arduino postes
                translate([ 11.5,-38.5,4]) cylinder(h=3, r=2.5,$fn=60); 
                translate([-37, 38,4]) cylinder(h=3, r=2.5,$fn=60); 
                translate([-37,-45,4]) cylinder(h=3, r=2.5,$fn=60); 
                translate([11.5, 37, 4]) cylinder(h=3, r=2.5,$fn=60); 
            ////main hull
                difference(){
                    hull() {
                        translate([ 49.5, 47.5,0]) cylinder(h=60, r=8,$fn=60);  
                        translate([-49.5,-47.5,0]) cylinder(h=60, r=8,$fn=60);  
                        translate([ 49.5,-47.5,0]) cylinder(h=60, r=8,$fn=60);  
                        translate([-49.5, 47.5,0]) cylinder(h=60, r=8,$fn=60);
                    } 
                    hull(){
                        translate([ 46.5, 44.5,4]) cylinder(h=72, r=8,$fn=60);  
                        translate([-46.5,-44.5,4]) cylinder(h=72, r=8,$fn=60);  
                        translate([ 46.5,-44.5,4]) cylinder(h=72, r=8,$fn=60);  
                        translate([-46.5, 44.5,4]) cylinder(h=72, r=8,$fn=60);
                    }       
                }
            }
            ////srewhead cutout
                translate([ 47.5, 45.5,1]) cylinder(h=5, r=5,$fn=60);  
                translate([-47.5,-45.5,1]) cylinder(h=5, r=5,$fn=60);  
                translate([-47.5, 45.5,1]) cylinder(h=5, r=5,$fn=60);  
                translate([ 47.5,-45.5,1]) cylinder(h=5, r=5,$fn=60);  
            ////srew cutout
                translate([ 47.5, 45.5,-1]) cylinder(h=10, r=2.8,$fn=60);  
                translate([-47.5,-45.5,-1]) cylinder(h=10, r=2.8,$fn=60);  
                translate([-47.5, 45.5,-1]) cylinder(h=10, r=2.8,$fn=60);  
                translate([ 47.5,-45.5,-1]) cylinder(h=10, r=2.8,$fn=60);     
           
            ////main cutout
                hull() {
                    translate([ 40, 24, -10]) cylinder(h=20, r=6,$fn=60);  
                    translate([-40,-29,-10]) cylinder(h=20, r=6,$fn=60);  
                    translate([ 40,-29,-10]) cylinder(h=20, r=6,$fn=60);  
                    translate([-40, 24,-10]) cylinder(h=20, r=6,$fn=60);
                }   
            ////arduino srews cutout
                translate([ 11.5,-38.5,2]) cylinder(h=13, r=1.2,$fn=60); 
                translate([-37, 38,2]) cylinder(h=13, r=1.2,$fn=60); 
                translate([-37,-45,2]) cylinder(h=13, r=1.2,$fn=60); 
                translate([ 11.5, 37, 2]) cylinder(h=13, r=1.2,$fn=60); 
                 
           ////Elektronic cutout  
           hull(){
                translate([ -37,57, 8]) rotate([90,0]) cylinder(h=6, r=0.1,$fn=60);     
                translate([-27.5,57, 8]) rotate([90,0]) cylinder(h=6, r=0.1,$fn=60);
                translate([ -37,57,20.5]) rotate([90,0]) cylinder(h=6, r=0.1,$fn=60);     
                translate([-27.5,57,20.5]) rotate([90,0]) cylinder(h=6, r=0.1,$fn=60);}      

            ////Sb25 Port         
            translate([ 25,52,8.5]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);       
            translate([ 25,52,55.5]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);   
            hull(){
                translate([ 18,48.5,5]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);       
                translate([ 32,48.5,5]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);       
                translate([ 18,48.5,60]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);       
                translate([ 32,48.5,60]) rotate([90,0,0]) cylinder(h=10, r=1,center=true,$fn=60);       
                }           
            hull(){
                translate([ 22,52,15]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
                translate([ 28,52,14]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
                translate([ 22,52,49]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
                translate([ 28,52,50]) rotate([90,0,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            }         
        }      
             
        difference(){ union(){
        ////upper srews
            hull(){
                translate([ 48, 46,54]) cylinder(h=6, r=7,$fn=60);  
                translate([ 56, 34,57]) cylinder(h=3, r=1,$fn=60);  
                translate([ 36, 54,57]) cylinder(h=3, r=1,$fn=60);
                translate([ 54.5, 52.5,4]) cylinder(h=1, r=0.8,$fn=60);   
                }  
            
               hull(){
                translate([ -48, 46,54]) cylinder(h=6, r=7,$fn=60);  
                translate([ -56, 34,57]) cylinder(h=3, r=1,$fn=60);  
                translate([ -36, 54,57]) cylinder(h=3, r=1,$fn=60);
                translate([ -54.5, 52.5,4]) cylinder(h=1, r=0.8,$fn=60);   
                }  
               hull(){
                translate([ -48, -46,54]) cylinder(h=6, r=7,$fn=60);  
                translate([ -56, -34,57]) cylinder(h=3, r=1,$fn=60);  
                translate([ -36, -54,57]) cylinder(h=3, r=1,$fn=60);
                translate([ -54.5, -52.5,4]) cylinder(h=1, r=0.8,$fn=60);   
                }  
               hull(){
                translate([ 48, -46,54]) cylinder(h=6, r=7,$fn=60);  
                translate([ 56, -34,57]) cylinder(h=3, r=1,$fn=60);  
                translate([ 36, -54,57]) cylinder(h=3, r=1,$fn=60);
                translate([ 54.5, -52.5,4]) cylinder(h=1, r=0.8,$fn=60);   
                }   
                
        }  
            ////upper srew cutout
                translate([ 47.5, 45.5,48]) cylinder(h=12, r=1.4,$fn=60);  
                translate([-47.5,-45.5,48]) cylinder(h=12, r=1.4,$fn=60);  
                translate([-47.5, 45.5,48]) cylinder(h=12, r=1.4,$fn=60);  
                translate([ 47.5,-45.5,48]) cylinder(h=12, r=1.4,$fn=60);    
             ///upper srewhead cutout
                translate([ 47.5, 45.5,58]) cylinder(h=2.1, r=4.5,$fn=60);  
                translate([-47.5,-45.5,58]) cylinder(h=2.1, r=4.5,$fn=60);  
                translate([-47.5, 45.5,58]) cylinder(h=2.1, r=4.5,$fn=60);  
                translate([ 47.5,-45.5,58]) cylinder(h=2.1, r=4.5,$fn=60);}                 
            }  
                 hull(){
                translate([ 53.8,-40,58.1]) cylinder(h=2, r=0.7,$fn=60);  
                translate([ 53.8, 43,58.1]) cylinder(h=2, r=0.7,$fn=60);}
                
                hull(){
                translate([ 53.8, 43,48.1]) cylinder(h=12, r=0.7,$fn=60);  
                translate([ 53.8, 30,48.1]) cylinder(h=12, r=0.7,$fn=60);}
            
            
            for(j=[-55,55], i=[0,10,20,30,-10,-20,-30]){           
            
            color ("red") hull(){
            translate([j,0+i,12]) rotate([0,90,0]) cylinder(h=10, r=2,center=true,$fn=60);       
            translate([j,0+i,48]) rotate([0,90,0]) cylinder(h=10, r=2,center=true,$fn=60);      
            }
        }
    }        
 }   
////////////////////    
module full_view_top_covers(){  
    color("green") union(){
        stamp_cover();
        stamp_cover_back();
        electronic_port();}
    
    monitor_all();
    color("magenta") purger();   
    
    ////if electronic boards are mounted on rear side////
    //color("green") top_box(); 
    //color("green") elektronic_box_base(); 
    //color("green") elektronic_box_cover();   
    ////

    ////for electronic boards external on NUC system////
    //translate([400,0,0]) nuc();
    ////
}
    
full_view_top_covers(); 