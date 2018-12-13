// TLC interface automatisation for CAMAG interface
// autoTLC-MS Interface; plate frame and Xcarrier
// 2018 September

use <02_autoTLC_Interface_base.scad>

////////////////////// 

//Adjust X-Axis hight everywhere!!!
//////Frame/////
 module plate_frame(){    
        difference(){

        color("grey") union(){
            translate([0,-76,4.4])cube([209,109,8.8],center=true);
            translate([0,-18.5,4.4])cube([99,8,8.8],center=true);
        }         
        color("grey") union(){
        translate([0,-76,0.85])cube([202,102,1.75],center=true);
        translate([0,-76,6])cube([196,96,9],center=true);
        translate([0,-128,4])cube([195,10,10],center=true);}
                 
        ////front screws
        //translate([-6,-23.25,5]) rotate([90,0]) cylinder(h=20,r=1.5,center=true,$fn=60);
        //translate([6,-23.25,5]) rotate([90,0]) cylinder(h=20,r=1.5,center=true,$fn=60);      
        
        ////corners
        color("blue") difference(){
        translate([45.5,-18.5,5])cylinder(h=15,r=7,center=true,$fn=60);
        translate([45.5,-18.5,5])cylinder(h=20,r=4,center=true,$fn=60);
        translate([35.5,-18.5,5])cube(20,20,20,center=true,$fn=60);
        translate([45.5,-28.5,5])cube(20,20,20,center=true,$fn=60);
        }
        color("blue") difference(){
        translate([-45.5,-18.5,5])cylinder(h=15,r=7,center=true,$fn=60);
        translate([-45.5,-18.5,5])cylinder(h=20,r=4,center=true,$fn=60);
        translate([-35.5,-18.5,5])cube(20,20,20,center=true,$fn=60);
        translate([-45.5,-28.5,5])cube(20,20,20,center=true,$fn=60);
        }
        
        color("blue") difference(){
        translate([100.5,-25.5,5])cylinder(h=15,r=7,center=true,$fn=60);
        translate([100.5,-25.5,5])cylinder(h=20,r=4,center=true,$fn=60);
        translate([90.5,-25.5,5])cube(20,20,20,center=true,$fn=60);
        translate([100.5,-35.5,5])cube(20,20,20,center=true,$fn=60);
        }
        color("blue") difference(){
        translate([-100.5,-25.5,5])cylinder(h=15,r=7,center=true,$fn=60);
        translate([-100.5,-25.5,5])cylinder(h=20,r=4,center=true,$fn=60);
        translate([-90.5,-25.5,5])cube(20,20,20,center=true,$fn=60);
        translate([-100.5,-35.5,5])cube(20,20,20,center=true,$fn=60);
        }
        ////inner screw cutout
        translate([0,-77,4.5])cube([26,109,10],center=true);
        
        color("blue") difference(){
        translate([17,-24,5])cylinder(h=15,r=7,center=true,$fn=60);
        translate([17,-24,5])cylinder(h=20,r=4,center=true,$fn=60);
        translate([27,-24,5])cube(20,20,20,center=true,$fn=60);
        translate([17,-14,5])cube(20,20,20,center=true,$fn=60);
        }
        color("blue") difference(){
        translate([-17,-24,5])cylinder(h=15,r=7,center=true,$fn=60);
        translate([-17,-24,5])cylinder(h=20,r=4,center=true,$fn=60);
        translate([-27,-24,5])cube(20,20,20,center=true,$fn=60);
        translate([-17,-14.5,5])cube(20,20,20,center=true,$fn=60);}          
        }
        difference(){
        color("blue") union(){
            translate([-98,-130,4.4])cylinder(h=8.8,r=6.5,center=true,$fn=60);
            translate([98,-130,4.4])cylinder(h=8.8,r=6.5,center=true,$fn=60);      
        }
        color("grey") union(){
        translate([0,-76,0.85])cube([202,102,1.75],center=true);
        translate([0,-76,5])cube([196,96,7],center=true);}
        ////abschrägung
        translate([-90,-130,-0.75])rotate([0,-6,0])cube([15,15,3],center=true); 
        translate([90,-130,-0.75])rotate([0,6,0])cube([15,15,3],center=true); 
             }     
    ////plate posts        
    translate([-101,-120,0])cylinder(h=3,r=1,$fn=60);       
    translate([-101,-100,0])cylinder(h=3,r=1,$fn=60);          
    
    translate([101,-120,0])cylinder(h=3,r=1,$fn=60);       
    translate([101,-100,0])cylinder(h=3,r=1,$fn=60);          
    difference(){union(){            
    translate([96,-127,0])cylinder(h=3,r=1,$fn=60); 
    translate([-96,-127,0])cylinder(h=3,r=1,$fn=60);}
    translate([-90,-130,-0.75])rotate([0,-6,0])cube([15,15,3],center=true); 
    translate([90,-130,-0.75])rotate([0,6,0])cube([15,15,3],center=true);}          
    }
    module plate_frame_m(){ 
        difference(){
        translate([0,0,0]) rotate([0,0]) plate_frame();
        translate([0,-82.5,4])cube([220,109,10],center=true);
        }
    }
    module plate_frame_l(){ 
        difference(){
        translate([0,0,0]) rotate([0,0]) plate_frame();
        translate([0,-15.5,4])cube([220,25.1,10],center=true);
        translate([97,-80,4])cube([35,125,10],center=true);
        }
    }
    module plate_frame_r(){ 
        difference(){
        translate([0,0,0]) rotate([0,0]) plate_frame();
        translate([0,-15.5,4])cube([220,25.1,10],center=true);
        translate([-97,-80,4])cube([35,125,10],center=true);
        }
    }
    module plate_frame_all(){ 
        difference(){
        union(){
        translate([0,0,0]) rotate([0,0]) plate_frame_m();
        translate([-1.05,3.7,0]) rotate([0,0,2]) plate_frame_l();
        translate([1.05,3.7,0]) rotate([0,0,-2]) plate_frame_r();}
        
        hull(){
        translate([-98,-28,-1])cylinder(h=10,r=2,$fn=60);      
        translate([-83,-30,-1])cylinder(h=10,r=2,$fn=60);   
        translate([-95.7,-43,-1])cylinder(h=10,r=2,$fn=60);} 
        hull(){
        translate([98,-28,-1])cylinder(h=10,r=2,$fn=60);
        translate([83,-30,-1])cylinder(h=10,r=2,$fn=60);   
        translate([95.7,-43,-1])cylinder(h=10,r=2,$fn=60);}        
    }
    }

module X_carrier_frame(){
    color("blue") difference(){
        union(){
            /////back  with endstop   
            hull(){ 
            translate([-23,20,4.4]) cylinder(h=8.8,r=2.5,center=true,$fn=60); 
            translate([ 23,20,4.4]) cylinder(h=8.8,r=2.5,center=true,$fn=60);
            translate([26,20,5]) rotate([0,90]) cylinder(h=12,r=2,center=true,$fn=60);        
            }       
            translate([0,0,4.4]) cube([38,40,8.8],center=true);
            
            ////frontmount
            hull(){ 
            translate([-24,-20,4.4]) cylinder(h=8.8,r=2.5,center=true,$fn=60); 
            translate([ 24,-20,4.4]) cylinder(h=8.8,r=2.5,center=true,$fn=60);
            }
        }
         ///x-rod///  
        translate([0,-11,4.5]) rotate([0,90]) cylinder(h=303,r=2.4,center=true,$fn=60);
        translate([0, 11,4.5]) rotate([0,90]) cylinder(h=303,r=2.4,center=true,$fn=60);
        ////belt screws
        translate([-14,0.1,6.1]) cylinder(h=7,r=2.3,center=true,$fn=60);
        translate([ 14,0.1,6.1]) cylinder(h=7,r=2.3,center=true,$fn=60);      
        ////innere 16 mm schrauben für keilriemen    
        translate([-6,  0,4]) rotate([90,0]) cylinder(h=16.5,r=1.5,center=true,$fn=60);
        translate([ 6,  0,4]) rotate([90,0]) cylinder(h=16.5,r=1.5,center=true,$fn=60); 
        translate([-6,15.5,4]) rotate([90,0]) cylinder(h=20,   r=   3,center=true,$fn=60);
        translate([ 6,15.5,4]) rotate([90,0]) cylinder(h=20,   r=   3,center=true,$fn=60);   
        ////innere aushöhlung          
        hull(){
            translate([-6,0,3.5]) rotate([90,0]) cylinder(h=7.4,r=2.6,center=true,$fn=60);
            translate([6,0,3.5]) rotate([90,0]) cylinder(h=7.4,r=2.6,center=true,$fn=60);      
            translate([-25,0,3]) rotate([90,0]) cylinder(h=7.4,r=1.75,center=true,$fn=60);
            translate([25,0,3]) rotate([90,0]) cylinder(h=7.4,r=1.75,center=true,$fn=60);      
            }                           
        //// 5 mm schrauben für seitenteile
        translate([-19,6,4]) rotate([0,90]) cylinder(h=6,r=0.8,center=true,$fn=60);
        translate([-19,-6,4]) rotate([0,90]) cylinder(h=6,r=0.8,center=true,$fn=60);   
        translate([19,6,4]) rotate([0,90]) cylinder(h=6,r=0.8,center=true,$fn=60);
        translate([19,-6,4]) rotate([0,90]) cylinder(h=6,r=0.8,center=true,$fn=60); 
        ////joint cutout
        translate([0,-20.3,4]) cube([5,4.41,10],center=true);
        translate([ 2.49,-22.51,4]) cube([1,1,10],center=true);
        translate([-2.49,-22.51,4]) cube([1,1,10],center=true);
        } 
        color("blue") union(){
        translate([ 2.99,-22.01,4.4]) cylinder(h=8.8,r=0.5,center=true,$fn=60); 
        translate([- 2.99,-22.01,4.4]) cylinder(h=8.8,r=0.5,center=true,$fn=60);}      
                                  
    }            
//////Carrier/////
module X_carrier(){
    color("blue") difference(){
        union(){
            /////back  with endstop   
            hull(){ 
            translate([-23,20,4.4]) cylinder(h=8.8,r=2.5,center=true,$fn=60); 
            translate([ 23,20,4.4]) cylinder(h=8.8,r=2.5,center=true,$fn=60);
            translate([26,20,5]) rotate([0,90]) cylinder(h=12,r=2,center=true,$fn=60);        
            }       
            translate([0,0,4.4]) cube([38,40,8.8],center=true);
            
            ////frontmount
            hull(){ 
            translate([-24,-20,4.4]) cylinder(h=8.8,r=2.5,center=true,$fn=60); 
            translate([ 24,-20,4.4]) cylinder(h=8.8,r=2.5,center=true,$fn=60);
            }
        }
         ///x-rod///  
        translate([0,-11,4.5]) rotate([0,90]) cylinder(h=303,r=2.4,center=true,$fn=60);
        translate([0, 11,4.5]) rotate([0,90]) cylinder(h=303,r=2.4,center=true,$fn=60);
        ////belt screws
        translate([-14,0.1,6.1]) cylinder(h=7,r=2.3,center=true,$fn=60);
        translate([ 14,0.1,6.1]) cylinder(h=7,r=2.3,center=true,$fn=60);      
        ////innere 16 mm schrauben für keilriemen    
        translate([-6,  0,4]) rotate([90,0]) cylinder(h=16.5,r=1.5,center=true,$fn=60);
        translate([ 6,  0,4]) rotate([90,0]) cylinder(h=16.5,r=1.5,center=true,$fn=60); 
        translate([-6,15.5,4]) rotate([90,0]) cylinder(h=20,   r=   3,center=true,$fn=60);
        translate([ 6,15.5,4]) rotate([90,0]) cylinder(h=20,   r=   3,center=true,$fn=60);   
        ////innere aushöhlung          
        hull(){
            translate([-6,0,3.5]) rotate([90,0]) cylinder(h=7.4,r=2.6,center=true,$fn=60);
            translate([6,0,3.5]) rotate([90,0]) cylinder(h=7.4,r=2.6,center=true,$fn=60);      
            translate([-25,0,3]) rotate([90,0]) cylinder(h=7.4,r=1.75,center=true,$fn=60);
            translate([25,0,3]) rotate([90,0]) cylinder(h=7.4,r=1.75,center=true,$fn=60);      
            }                           
        //// 5 mm schrauben für seitenteile
        translate([-19,6,4]) rotate([0,90]) cylinder(h=6,r=0.8,center=true,$fn=60);
        translate([-19,-6,4]) rotate([0,90]) cylinder(h=6,r=0.8,center=true,$fn=60);   
        translate([19,6,4]) rotate([0,90]) cylinder(h=6,r=0.8,center=true,$fn=60);
        translate([19,-6,4]) rotate([0,90]) cylinder(h=6,r=0.8,center=true,$fn=60); 
        ////joint cutout
        translate([0,-20.3,4]) cube([5,4.41,10],center=true);
        translate([ 2.49,-22.51,4]) cube([1,1,10],center=true);
        translate([-2.49,-22.51,4]) cube([1,1,10],center=true);
        } 
        color("blue") union(){
        translate([ 2.99,-22.01,4.4]) cylinder(h=8.8,r=0.5,center=true,$fn=60); 
        translate([- 2.99,-22.01,4.4]) cylinder(h=8.8,r=0.5,center=true,$fn=60);}      
                                  
    }            
module X_carrier_side_L(){     
        ////Seitenteil
        difference(){    
        color("blue")
        translate([-1.5,0,4.4]) cube([5,33,8.8],center=true);
        
        //// 5 mm schrauben für seitenteile
        translate([-2,6,4]) rotate([0,90]) cylinder(h=10,r=0.9,center=true,$fn=60);
        translate([-2,-6,4]) rotate([0,90]) cylinder(h=10,r=0.9,center=true,$fn=60);      
        translate([-3.55,6,4]) rotate([0,90]) cylinder(h=4,r=1.6,center=true,$fn=60);
        translate([-3.55,-6,4]) rotate([0,90]) cylinder(h=4,r=1.6,center=true,$fn=60);  
     
        hull(){
            translate([9,0,3]) rotate([90,0]) cylinder(h=7.4,r=1.75,center=true,$fn=60); 
            translate([-9,0,3]) rotate([90,0]) cylinder(h=7.4,r=1.75,center=true,$fn=60);   
        }          
        translate([0,-11,3]) rotate([0,90]) cylinder(h=303,r=2.4,center=true,$fn=60);
        translate([0,11,3]) rotate([0,90]) cylinder(h=303,r=2.4,center=true,$fn=60);

       difference(){
            translate([1.5,-11,3]) rotate([0,90]) cylinder(h=2.6,r=4,center=true,$fn=60);
            translate([0,-14,-0.75]) cube([5,6,1]);}
            difference(){
            translate([1.5,11,3]) rotate([0,90]) cylinder(h=2.6,r=4,center=true,$fn=60);     
            translate([0,8,-0.75]) cube([5,6,1]);}
            }
        }   
module X_carrier_side_R(){  
        mirror (1,0,0) X_carrier_side_L();
        }
  

    
////////////////////    
////VIEW////       
module plate_frame_XYZ(X,Y,Z){
                color("orange") translate([   0,     133.1+Y, 0]) X_carrier_frame();
                translate([-20-X,  133.1+Y, 0]) X_carrier_side_L();
                translate([ 20+X, 133.1+Y, 0]) X_carrier_side_R();

                color("orange") translate ([0,130.1+Y, 0]) plate_frame();
                color("white") translate ([0,54.6+Y, 0.9125]) cube([202,102,1.75],center=true);
    
    //_all();9125
            }

module full_plate_frame(X,Y){
    translate([100.5-X,-(Y+2),0]) plate_frame_XYZ(0,0,0);
    } 

module plate_adapter(){
    difference(){
    union(){
    hull(){
    translate([2,2,0])cylinder(h=1.6,r=2,$fn=60);
    translate([2,98,0])cylinder(h=1.6,r=2,$fn=60);
    translate([198,2,0])cylinder(h=1.6,r=2,$fn=60);
    translate([198,98,0])cylinder(h=1.6,r=2,$fn=60);    
    }
    color("blue")hull(){
    translate([5,95,0])cylinder(h=4,r=2,$fn=60);
    translate([195,95,0])cylinder(h=4,r=2,$fn=60);
    translate([195,5,0])cylinder(h=4,r=2,$fn=60);
    translate([5,5,0])cylinder(h=4,r=2,$fn=60);
    translate([10,2,0])cylinder(h=4,r=2,$fn=60);
    translate([190,2,0])cylinder(h=4,r=2,$fn=60);    
    }
    
    ////Handle
    hull(){
    translate([54,-15,0])cylinder(h=4,r=5,$fn=60);
    translate([25,5,0])cylinder(h=4,r=5,$fn=60);
    translate([70,-7.8,0])cylinder(h=4,r=2,$fn=60);    
    translate([45,-15,0])cylinder(h=4,r=5,$fn=60);    
    }
    hull(){
    translate([146,-15,0])cylinder(h=4,r=5,$fn=60);
    translate([175,5,0])cylinder(h=4,r=5,$fn=60);
    translate([130,-7.8,0])cylinder(h=4,r=2,$fn=60);
    translate([155,-15,0])cylinder(h=4,r=5,$fn=60);
    }     
    }   
    ////diff
    hull(){
    translate([49.5,-5.5,-1])cylinder(h=6,r=0.3,$fn=60);
    translate([150.5,-5.5,-1])cylinder(h=6,r=0.3,$fn=60);
    translate([49.5,95.5,-1])cylinder(h=6,r=0.3,$fn=60);
    translate([150.5,95.5,-1])cylinder(h=6,r=0.3,$fn=60);
    }
    hull(){
    translate([55,-4,-1])cylinder(h=6,r=1,$fn=60);
    translate([51, 0,-1])cylinder(h=6,r=1,$fn=60);
    translate([50,-5,-1])cylinder(h=6,r=1,$fn=60);
    }
    hull(){
    translate([150,-5,-1])cylinder(h=6,r=1,$fn=60);
    translate([145,-4,-1])cylinder(h=6,r=1,$fn=60);
    translate([149, 0,-1])cylinder(h=6,r=1,$fn=60);
    }
    hull(){
    translate([50,95,-1])cylinder(h=6,r=1,$fn=60);
    translate([51,90,-1])cylinder(h=6,r=1,$fn=60);
    translate([55,94,-1])cylinder(h=6,r=1,$fn=60);
    }
    hull(){
    translate([150,95,-1])cylinder(h=6,r=1,$fn=60);
    translate([149,90,-1])cylinder(h=6,r=1,$fn=60);
    translate([145,94,-1])cylinder(h=6,r=1,$fn=60);
    }
    ///sides
    hull(){
    translate([10,10,-1])cylinder(h=6,r=3,$fn=60);
    translate([10,90,-1])cylinder(h=6,r=3,$fn=60);
    translate([40,90,-1])cylinder(h=6,r=3,$fn=60);
    translate([40,10,-1])cylinder(h=6,r=3,$fn=60);
    }
    hull(){
    translate([160,10,-1])cylinder(h=6,r=3,$fn=60);
    translate([160,90,-1])cylinder(h=6,r=3,$fn=60);
    translate([140,90,-1])cylinder(h=6,r=3,$fn=60);
    translate([140,10,-1])cylinder(h=6,r=3,$fn=60);
    }
    hull(){
    translate([190,10,-1])cylinder(h=6,r=3,$fn=60);
    translate([190,90,-1])cylinder(h=6,r=3,$fn=60);
    translate([169,90,-1])cylinder(h=6,r=3,$fn=60);
    translate([169,10,-1])cylinder(h=6,r=3,$fn=60);
    }  
    
}
        translate([0,-0.5,0]) flexhand();
        translate([145.5,-55,0]) rotate([0,0,90]) flexhand_R();
////Handle_R
    difference(){
        union(){
    hull(){
    translate([152.8,4,0])cylinder(h=4,r=2,$fn=60);
    translate([152.8,15,0])cylinder(h=4,r=2,$fn=60);    
    translate([160.3,-1,0])cylinder(h=4,r=5,$fn=60);    
    }
    hull(){
    translate([152.8,94,0])cylinder(h=4,r=2,$fn=60);
    translate([152.8,75,0])cylinder(h=4,r=2,$fn=60);
    translate([161.5,93,0])cylinder(h=4,r=3,$fn=60);
    translate([161.5,89.2,0])cylinder(h=4,r=3,$fn=60);
    }   
    }
     hull(){
    translate([150,95,-1])cylinder(h=6,r=1,$fn=60);
    translate([149,90,-1])cylinder(h=6,r=1,$fn=60);
    translate([145,94,-1])cylinder(h=6,r=1,$fn=60);
    }
}   
    //color("white")translate([100,45,0])cube([100,100,1.6],center=true);
   
}
    module springcut(){
    hull(){    
    translate([0,0,0]) cylinder(h=3,r=2,$fn=60);       
    translate([2,-1,0]) cylinder(h=3,r=2,$fn=60); 
    translate([-2,-1,0]) cylinder(h=3,r=2,$fn=60);
    }
}

    module flexhand(){
    difference(){ 
    union(){ 
    difference(){
        translate([100,-74,0])cylinder(h=1.6,r=70,$fn=300);
        translate([100,-74,-1])cylinder(h=3,r=68,$fn=300);
        ///springcuts   
        translate([91,-7.5,-1]) rotate([0,0,7]) springcut();
        translate([80,-10,-1]) rotate([0,0,17]) springcut();
        translate([70,-14,-1]) rotate([0,0,26]) springcut();
        translate([84.7,-4.75,-1]) rotate([0,0,195]) springcut();
        translate([73.6,-8.1,-1]) rotate([0,0,204]) springcut();
    
        translate([109,-7.5,-1]) rotate([0,0,-7]) springcut();
        translate([120,-10,-1]) rotate([0,0,-17]) springcut();
        translate([130,-14,-1]) rotate([0,0,-26]) springcut();
        translate([115.3,-4.75,-1]) rotate([0,0,-195]) springcut();
        translate([126.4,-8.1,-1]) rotate([0,0,-204]) springcut();
        }
        translate([100,-74,0])cylinder(h=4,r=66,$fn=300);
        }
        union(){
        translate([100,-94,1.6])cube([150,150,5],center=true);    
        }
            } 
 
    difference(){
        union(){
    hull(){
    translate([100,-5,0])cylinder(h=4.6,r=1,$fn=60);
    translate([95,-5.185,0])cylinder(h=4.6,r=1,$fn=60);
    translate([105,-5.185,0])cylinder(h=4.6,r=1,$fn=60);
    
    translate([96,-5.115,0])cylinder(h=4.6,r=1,$fn=60);
    translate([104,-5.115,0])cylinder(h=4.6,r=1,$fn=60);
    
    translate([97,-5.065,0])cylinder(h=4.6,r=1,$fn=60);
    translate([103,-5.065,0])cylinder(h=4.6,r=1,$fn=60);
    
    translate([98,-5.03,0])cylinder(h=4.6,r=1,$fn=60);
    translate([102,-5.03,0])cylinder(h=4.6,r=1,$fn=60);
    
    translate([99,-5.01,0])cylinder(h=4.6,r=1,$fn=60);
    translate([101,-5.01,0])cylinder(h=4.6,r=1,$fn=60);
    }    
    ////holder
    hull(){
    translate([100,-5,4.6])cylinder(h=2,r=1,$fn=60);
    translate([95,-5.185,4.6])cylinder(h=2,r=1,$fn=60);
    translate([105,-5.185,4.6])cylinder(h=2,r=1,$fn=60);
    
    translate([96,-5.115,4.6])cylinder(h=2,r=1,$fn=60);
    translate([104,-5.115,4.6])cylinder(h=2,r=1,$fn=60);
    
    translate([97,-5.065,4.6])cylinder(h=2,r=1,$fn=60);
    translate([103,-5.065,4.6])cylinder(h=2,r=1,$fn=60);
    
    translate([98,-5.03,4.6])cylinder(h=2,r=1,$fn=60);
    translate([102,-5.03,4.6])cylinder(h=2,r=1,$fn=60);
    
    translate([99,-5.01,4.6])cylinder(h=2,r=1,$fn=60);
    translate([101,-5.01,4.6])cylinder(h=2,r=1,$fn=60);

    translate([95,-16,4.6])cylinder(h=2,r=1,$fn=60);
    translate([105,-16,4.6])cylinder(h=2,r=1,$fn=60);
    }
    }
    translate([100,-3.3,4.9])rotate ([-75,0,0])cube([20,10,3],center=true);
    translate([100,-3.3,5.9])rotate ([-45,0,0])cube([20,10,3],center=true);
    translate([100,-3.3,5.2])rotate ([-60,0,0])cube([20,10,3],center=true);
    hull(){
    translate([98,-12.5,4.5])cylinder(h=3,r=2,$fn=60);
    translate([102,-12.5,4.5])cylinder(h=3,r=2,$fn=60);  
     
    }
    }
    ////handle2
    hull(){
    translate([45,-17,0])cylinder(h=4,r=3,$fn=60);  
    translate([155,-17,0])cylinder(h=4,r=3,$fn=60);  
    }
}
    module flexhand_R(){
     difference(){ 
    union(){ 
    difference(){
        translate([100,-74,0])cylinder(h=1.6,r=70,$fn=300);
        translate([100,-74,-1])cylinder(h=3,r=68,$fn=300);
        ///springcuts   
        translate([91,-7.5,-1]) rotate([0,0,7]) springcut();
        translate([80,-10,-1]) rotate([0,0,17]) springcut();
        translate([70,-14,-1]) rotate([0,0,26]) springcut();
        translate([84.7,-4.75,-1]) rotate([0,0,195]) springcut();
        translate([73.6,-8.1,-1]) rotate([0,0,204]) springcut();
    
        translate([109,-7.5,-1]) rotate([0,0,-7]) springcut();
        translate([120,-10,-1]) rotate([0,0,-17]) springcut();
        translate([130,-14,-1]) rotate([0,0,-26]) springcut();
        translate([115.3,-4.75,-1]) rotate([0,0,-195]) springcut();
        translate([126.4,-8.1,-1]) rotate([0,0,-204]) springcut();
        }
        translate([100,-74,0])cylinder(h=4,r=66,$fn=300);
        }
        union(){
        translate([100,-94,1.6])cube([150,150,5],center=true);    
        }
            } 
 
    difference(){
        union(){
    hull(){
    translate([100,-5,0])cylinder(h=4.6,r=1,$fn=60);
    translate([95,-5.185,0])cylinder(h=4.6,r=1,$fn=60);
    translate([105,-5.185,0])cylinder(h=4.6,r=1,$fn=60);
    
    translate([96,-5.115,0])cylinder(h=4.6,r=1,$fn=60);
    translate([104,-5.115,0])cylinder(h=4.6,r=1,$fn=60);
    
    translate([97,-5.065,0])cylinder(h=4.6,r=1,$fn=60);
    translate([103,-5.065,0])cylinder(h=4.6,r=1,$fn=60);
    
    translate([98,-5.03,0])cylinder(h=4.6,r=1,$fn=60);
    translate([102,-5.03,0])cylinder(h=4.6,r=1,$fn=60);
    
    translate([99,-5.01,0])cylinder(h=4.6,r=1,$fn=60);
    translate([101,-5.01,0])cylinder(h=4.6,r=1,$fn=60);
    }    
    ////holder
    hull(){
    translate([100,-5,4.6])cylinder(h=2,r=1,$fn=60);
    translate([95,-5.185,4.6])cylinder(h=2,r=1,$fn=60);
    translate([105,-5.185,4.6])cylinder(h=2,r=1,$fn=60);
    
    translate([96,-5.115,4.6])cylinder(h=2,r=1,$fn=60);
    translate([104,-5.115,4.6])cylinder(h=2,r=1,$fn=60);
    
    translate([97,-5.065,4.6])cylinder(h=2,r=1,$fn=60);
    translate([103,-5.065,4.6])cylinder(h=2,r=1,$fn=60);
    
    translate([98,-5.03,4.6])cylinder(h=2,r=1,$fn=60);
    translate([102,-5.03,4.6])cylinder(h=2,r=1,$fn=60);
    
    translate([99,-5.01,4.6])cylinder(h=2,r=1,$fn=60);
    translate([101,-5.01,4.6])cylinder(h=2,r=1,$fn=60);

    translate([95,-16,4.6])cylinder(h=2,r=1,$fn=60);
    translate([105,-16,4.6])cylinder(h=2,r=1,$fn=60);
    }
    }
    translate([100,-3.3,4.9])rotate ([-75,0,0])cube([20,10,3],center=true);
    translate([100,-3.3,5.9])rotate ([-45,0,0])cube([20,10,3],center=true);
    translate([100,-3.3,5.2])rotate ([-60,0,0])cube([20,10,3],center=true);
    hull(){
    translate([98,-12.5,4.5])cylinder(h=3,r=2,$fn=60);
    translate([102,-12.5,4.5])cylinder(h=3,r=2,$fn=60);  
     
    }
    }
    ////handle2
    hull(){
    translate([55,-17,0])cylinder(h=4,r=3,$fn=60);  
    translate([145,-17,0])cylinder(h=4,r=3,$fn=60);  
    }
}

////Print Job   

full_plate_frame(0.5,2.5);

//color ("orange") plate_adapter();
    

