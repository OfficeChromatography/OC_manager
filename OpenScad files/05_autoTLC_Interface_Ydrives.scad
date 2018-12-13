// TLC interface automatisation for CAMAG interface
// autoTLC-MS Interface; all Ydrives
// 2018 September

use <03_autoTLC_Interface_connections.scad>
use <04_autoTLC_Interface_rodholder.scad>

////////////////////

module Y_carriers_all(){
    difference(){ 
        union(){
           translate([0,0,0]) mirror (1,0,0) Y_carrier_hull_R();
           translate([0,0,0]) Y_carrier_hull_R();
           translate([0,0,0]) base_carrier();}
                             
           translate([0,0,0]) Y_carriers_in();
           translate([0,0,0]) Y_carriers_in();
           translate([0,0,0]) mirror (1,0,0) Y_gearing_out_R();
           translate([0,0,0])                Y_gearing_out_R();     
        
            
            drilling_holes_base();
            translate([0,0,0])    nema14_cutout();      
            translate ([139.5,20,4]) rotate([180,180]) endstop();                    
            }
            translate([0,0,0]) X_carrier_adjust_L();
            translate([0,0,0]) X_carrier_adjust_R();
        }

    module Y_carrier_hull_R(){ 
color("blue") 
    difference(){ 
        union(){      
            ////upper rounds
            hull(){   
                translate([152,0,-48]) rotate([90,0]) cylinder(h=33,r=6,center=true,$fn=60);          
                translate([148,0,1]) rotate([90,0]) cylinder(h=33,r=10,center=true,$fn=60);                 
                } 
            hull(){ 
                translate([148,0,1]) rotate([90,0]) cylinder(h=33,r=10,center=true,$fn=60);
                translate([139,0,2]) rotate([90,0]) cylinder(h=33,r=3,center=true,$fn=60);
                translate([139,0,8]) rotate([90,0]) cylinder(h=33,r=3,center=true,$fn=60);  
                translate([141.65,0,-7.5]) rotate([90,0]) cylinder(h=33,r=3,center=true,$fn=60);           
                }
                
            ////base
            hull(){
                translate([147,0,-48]) rotate([90,0]) cylinder(h=33,r=11,center=true,$fn=60);
                translate([133,0,-61.5]) rotate([90,0]) cylinder(h=33,r=4,center=true,$fn=60);
                translate([113.3,-16.5,-65.5]) cube([18,33,11]);  
                }
            ////beltmount       
            hull(){
                translate([147,0,-48.0]) rotate([90,0]) cylinder(h=33,r=11,center=true,$fn= 60);  
                translate([110,0,-21.0]) rotate([90,0]) cylinder(h=33,r= 2,center=true,$fn=  60);
                translate([120,0,-55.0]) rotate([90,0]) cylinder(h=33,r= 2,center=true,$fn=  60);
                translate([140,0,-12.57]) rotate([90,0]) cylinder(h=33,r= 2,center=true,$fn=120);
                }  
            hull(){   
                translate([140,0,-13]) rotate([90,0]) cylinder(h=33,r= 2,center=true,$fn=120);
                translate([125,0,-16]) rotate([90,0]) cylinder(h=33,r= 5,center=true,$fn=120);
                translate([110,0,-21.0]) rotate([90,0]) cylinder(h=33,r= 2,center=true,$fn=  60);
                }   
            ////baseplate
            translate([35,-16.5,-65.5]) cube([90,33,8]);
            ////plate cutoutbase
            translate([140,0,-11.4]) rotate([90,0]) cylinder(h=33,r=5.1,center=true,$fn=60);          
                
           ////endstop////
            hull(){   
                translate([121.25,21,-60.7]) rotate([90,0]) cylinder(h=10,r=0.5,center=true,$fn=60);
                translate([117.85,21,-60.7]) rotate([90,0]) cylinder(h=10,r=0.5,center=true,$fn=60);
                translate([119.55,21,-54]) rotate([90,0]) cylinder(h=10,r1=1.6,r2=2.3,center=true,$fn=60);   
                translate([124,15,-59.2]) rotate([90,0]) cylinder(h=1,r=2,center=true,$fn=60);}       
                hull(){   
                translate([114.7,15,-59.15]) rotate([90,0]) cylinder(h=1,r=2,center=true,$fn=60);
                translate([119.55,21,-54]) rotate([90,0]) cylinder(h=10,r1=1.6,r2=2.3,center=true,$fn=60);
                translate([117.8,21,-60.7]) rotate([90,0]) cylinder(h=10,r=0.5,center=true,$fn=60);
                translate([118.05,21,-58.5]) rotate([90,0]) cylinder(h=10,r=0.5,center=true,$fn=60);
                }               
            }          
        ////lower inner outcut
        translate([113.31,0,-53.5]) rotate([90,0]) cylinder(h=60,r=4,center=true,$fn=60);
     
        ////upper inner plate cutout
        translate([134.52,0,-7.20]) rotate([90,0]) cylinder(h=50,r=3.8,center=true,$fn=60);    
        }   
    }
     
    module Y_carriers_in(){
        mirror(1,0,0) Y_carrier_in_R ();  
                            Y_carrier_in_R ();     
            //3mm X_rod
            translate([-2,-11,4]) rotate([0,90]) cylinder(h=300,r=1.55,center=true,$fn=60);
            translate([-2,11,4]) rotate([0,90]) cylinder(h=300,r=1.55,center=true,$fn=60); 
            translate([155,-11,4]) rotate([0,90]) cylinder(h=15,r=1.9,center=true,$fn=60);
            translate([155,11,4]) rotate([0,90]) cylinder(h=15,r=1.9,center=true,$fn=60); 
     
            translate([0,0,-60]) cube([216,14.6,5.01],center=true);     
            }
  
        module Y_carrier_in_R (){   
        //linear bearing
        color("orange") translate([132,5,-22]) rotate([90,0]) cylinder(h=35,r=7.7,center=true);
        color("orange") translate([147,5,-48]) rotate([90,0]) cylinder(h=35,r=7.7,center=true); 
        
        //8 mm rod
        color("red") translate([132,0,-22]) rotate([90,0]) cylinder(h=50,r=5,center=true, $fn=30);
        color("red") translate([147,0,-48]) rotate([90,0]) cylinder(h=50,r=5,center=true,$fn=30);
        
        //8mm_belt_bearings  
        translate ([147,0,-2.97]) belt_bearing_out();
        translate ([126,0,-53]) belt_bearing_out();        
        
        //belt screws
        translate([115.5,0,-15]) rotate([0,-16.5,0]) Y_belt_screws(); 
        ///belt cutouts/// 
        color("orange") union(){
        translate([-0.5,0,1.5]) cube([293,14.6,10],center=true);   
        translate([132,0,-5])  rotate([0,-69]) cube([12,14.6,35],center=true); 
           
        translate([144.8,0,-23])  rotate([0,-65.5]) cube([39,14.6,6.5],center=true);
        translate([135.8,0,-45])  rotate([0,-69.5]) cube([24,14.6,6.2],center=true);

        translate([125,0,-42.24])  rotate([0,-105.05]) cube([8,14.6,27],center=true);  
        translate([120.5,0,-45]) cube([30,14.6,5],center=true); 
            
        translate([115.5,0,-54.5]) cube([20,14.6,16],center=true);
        }      
        }
        
        module belt_bearing_out (){
        color("red") translate([0,0,0]) rotate([90,0]) cylinder(h=25,r=1.55,center=true,$fn=30);
        color("red") translate([0,15,0]) rotate([90,0]) cylinder(h=5.1,r=3.4,center=true,$fn=30);    
        color("orange") rotate([90,0]) cylinder(h=14.6,r=9.5,center=true,$fn=90);
        }
        module Y_belt_screws(){
        color("red") translate([0,-6,0]) cylinder(h=30,r=2.4,center=true,$fn=60);
        color("red") translate([0,6,0]) cylinder(h=30,r=2.4,center=true,$fn=60);
        
        translate([0, 6,-14]) cube([6.5,5,2],center=true);
        translate([0,-6,-14]) cube([6.5,5,2],center=true);}

    module base_carrier(){  
        difference(){
        color("blue") union(){  
            ////motor holder
            translate([70,-11.9,-45]) cube([40,9.2,40],center=true);
            translate([52,-11.9,-45]) rotate([0,12,0]) cube([11,9.2,34],center=true);
            translate([88,-11.9,-45]) rotate([0,-12,0]) cube([11,9.2,34],center=true);
            ////bearings post
            translate ([88,0,-51]) bearing_post();
            translate ([52,0,-51]) bearing_post();}
                color("red") translate([88,-10,-51]) rotate([90,0]) cylinder(h=20,r=1.6,center=true,$fn=30);
                color("red") translate([52,-10,-51]) rotate([90,0]) cylinder(h=20,r=1.6,center=true,$fn=30); 
                color("red") translate([52,-14.1,-51]) rotate([90,0]) cylinder(h=5,r=3.25,$fn=6,center=true);
                color("red") translate([88,-14.1,-51]) rotate([90,0]) cylinder(h=5,r=3.25,$fn=6,center=true);
                }
            }

        module bearing_post (){
        hull(){
        color("red") translate([0,-5.5,0]) rotate([90,0]) cylinder(h=7,r=2.5,center=true,$fn=30);
        color("red") translate([0,-5.5,0]) rotate([90,0]) cylinder(h=4,r=3.8,center=true,$fn=30);}
        }
        
        module nema14_X(){
        union(){
            color("orange") translate([0,0,-27]) cube([36,36,38],center=true);  
            color("silver") translate([0,0,-6]) cylinder(h=21,r=2.5,$fn=60); 
            color("silver") translate([0,0,-8]) cylinder(h=2,r=11.5,$fn=60); 
            //zahnrad//
            color("grey") difference(){
                translate([0,0,-2]) cylinder(h=16,r=8,$fn=60); 
                translate([0,0,6]) cylinder(h=6,r=8.1,$fn=60);
                }
            }
        color("black") translate([0,0,6]) cylinder(h=6,r=8,$fn=60);
            
            //mounting screws        
        color("red") union(){
            translate([ 13, 13, -8]) cylinder(h=10,r=1.7,$fn=60);  
            translate([-13, 13, -8]) cylinder(h=10,r=1.7,$fn=60);  
            translate([ 13,-13, -8]) cylinder(h=10,r=1.7,$fn=60);   
            translate([-13,-13, -8]) cylinder(h=10,r=1.7,$fn=60);      
            }
        }
        
        module nema14_cutout(){
        translate([57,-9.2,-30]) rotate([90,0]) cylinder(h=4,r=3.25,$fn=6,center=true);    
        translate([83,-9.2,-30]) rotate([90,0]) cylinder(h=4,r=3.25,$fn=6,center=true);
        translate([57,-9.2,-56]) rotate([90,0]) cylinder(h=4,r=3.25,$fn=6,center=true);    
        translate([83,-9.2,-56]) rotate([90,0]) cylinder(h=4,r=3.25,$fn=6,center=true);

        translate([70,-12,-43]) rotate([90,0]) cylinder(h=10,r=12,$fn=60,center=true);
        translate([70,-7,-20]) rotate( [0,0]) cylinder(h=40,r=2.5,center=true,$fn=30);  
        
        translate([57,-12,-30]) rotate([90,0]) cylinder(h=10,r=1.6,$fn=60,center=true);    
        translate([83,-12,-30]) rotate([90,0]) cylinder(h=10,r=1.6,$fn=60,center=true);
        translate([57,-12,-56]) rotate([90,0]) cylinder(h=10,r=1.6,$fn=60,center=true);    
        translate([83,-12,-56]) rotate([90,0]) cylinder(h=10,r=1.6,$fn=60,center=true);
        }

//////////
module base_traverse(){
    color("blue") difference(){
        translate([0,0,-65]) cube([250,39,7],center=true);
        translate([0,0,-63.49]) cube([252,33,4],center=true);  
       
        color("red")  translate([0,0,-0.01]) drilling_holes_base();
        } 
    }
  
module drilling_holes_base(){  
    translate([55,11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([55,11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);   
    
    translate([55,-11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([55,-11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);
    
    translate([85,11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([85,11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);   
    
    translate([85,-11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([85,-11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);
    
    translate([115,11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([115,11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);   
    
    translate([115,-11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([115,-11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);        
           
 
    translate([-55,11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([-55,11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);   
    
    translate([-55,-11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([-55,-11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);
    
    translate([-85,11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([-85,11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);   
    
    translate([-85,-11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([-85,-11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);
    
    translate([-115,11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([-115,11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);   
    
    translate([-115,-11,-66.5]) cylinder(h=7,r=0.75,$fn=60); 
    translate([-115,-11,-68.5]) cylinder(h=2.01,r1=3.4,r2=0.75,$fn=60);             
    }   
    
module linearbearing_cover(){
//linear bearing
        difference(){ union(){
        color("orange") translate([132,25,-22]) rotate([90,0]) cylinder(h=3,r=7.5,center=true);
        color("orange") translate([147,25,-48]) rotate([90,0]) cylinder(h=3,r=7.5,center=true); 
        translate([132,27,-22]) rotate([90,0]) cylinder(h=1,r=8.5,center=true);
        translate([147,27,-48]) rotate([90,0]) cylinder(h=1,r=8.5,center=true);} 
        color("red") translate([132,25,-22]) rotate([90,0]) cylinder(h=6,r=5,center=true, $fn=30);
        color("red") translate([147,25,-48]) rotate([90,0]) cylinder(h=6,r=5,center=true,$fn=30);}
        }
//////////
module X_gearing(){       
    ///black belts/// 
    color("black") translate([0,0,4]) cube([298,6,2],center=true);
    color("black") translate([-36,0,-59]) rotate([0,-0.7]) cube([179.5,6,2],center=true);
    color("black") translate([107,0,-59]) rotate([0,3]) cube([40,6,2],center=true);
    color("black") translate([143,0,-30])  rotate([0,-67.2]) cube([56,6,2],center=true);  
    color("black") translate([-143,0,-30])  rotate([0,67.2]) cube([56,6,2],center=true);    
 
    color("black") translate([78.5,0,-46])  rotate([0,67.2]) cube([16.5,6,2],center=true);  
    color("black") translate([61.5,0,-46])  rotate([0,-67.2]) cube([16.5,6,2],center=true); 
    
    ///x-rod///
    color("red") translate([0,-11,3.75]) rotate([0,90]) cylinder(h=300,r=1.5,center=true,$fn=30);
    color("red") translate([0,11,3.75]) rotate([0,90]) cylinder(h=300,r=1.5,center=true,$fn=30);       
    //8mm_belt_bearings  
    translate ([147,0,-3]) 8mm_belt_bearing();
    translate ([126,0,-53]) 8mm_belt_bearing();
    translate ([-147,0,-3]) 8mm_belt_bearing();
    translate ([-126,0,-53]) 8mm_belt_bearing();
   
    translate ([52,0,-51]) 8mm_belt_bearing_X();
    translate ([88,0,-51]) 8mm_belt_bearing_X();

    translate ([139.5,20,4]) rotate([180,180]) endstop();   
    
    translate([70,-9,-43]) rotate([-90,0,0]) nema14_X();
  
    }
    
      module 8mm_belt_bearing_X(){
                color("red") rotate([90,0]) cylinder(h=16,r=1.6,center=true,$fn=30);
                 translate([0,6.5,0]) color("red") rotate([90,0]) cylinder(h=3,r=2.6,center=true,$fn=30);
                //washers
                translate([0,3.25,0]) rotate([90,0]) cylinder(h=0.5,r=2,center=true);
                translate([0,-3.25,0]) rotate([90,0]) cylinder(h=0.5,r=2,center=true);
                translate([0,4.25,0]) rotate([90,0]) cylinder(h=1,r=8,center=true);
                translate([0,-4.25,]) rotate([90,0]) cylinder(h=1,r=8,center=true);
                color("black") translate([0,0,0]) rotate([90,0]) cylinder(h=7,r=8,center=true);   
                }
       
module X_carrier_adjust_L(){      
        difference(){  
        color("blue")hull(){
        hull(){
        translate([138,-14.49,13.5]) rotate([0,90]) cylinder(h=14,r=2,center=true,$fn=60);
        translate([138,14.49,13.5]) rotate([0,90]) cylinder(h=14,r=2,center=true,$fn=60);}
        
        hull(){
        translate([143,-14.49,2]) rotate([0,90]) cylinder(h=24,r=2,center=true,$fn=60);
        translate([143,14.49,2]) rotate([0,90]) cylinder(h=24,r=2,center=true,$fn=60);}
        }
        //// 5 mm schrauben
        translate([140, 11,14.-4]) cylinder(h=10,r=0.9,center=true,$fn=60);
        translate([140,-11,14.-4]) cylinder(h=10,r=0.9,center=true,$fn=60);      
        translate([140, 11,14.3]) cylinder(h=2.5,r=1.6,center=true,$fn=60);
        translate([140,-11,14.3]) cylinder(h=2.5,r=1.6,center=true,$fn=60);  
    
        Y_carrier_hull_R();
        Y_carriers_in();
            }       
        } 
        
module X_carrier_adjust_R(){  
        mirror (1,0,0) X_carrier_adjust_L();
        }                
         
////VIEW////
module full_view_Ydrives(){
Y_carriers_all();
base_traverse();
}    
  
full_view_Ydrives();    
linearbearing_cover();