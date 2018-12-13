// TLC interface automatisation for CAMAG interface
// autoTLC-MS Interface; all parts
// 2018 September

use <02_autoTLC_Interface_base.scad>
use <03_autoTLC_Interface_connections.scad>
use <04_autoTLC_Interface_rodholder.scad>
use <05_autoTLC_Interface_Ydrives.scad>
use <06_autoTLC_Interface_plate_frame.scad>
use <07_autoTLC_Interface_top_covers.scad>

////////////////////    

////VIEW////
module full_view(X,Y){
//02//
    full_view_base(); 
        //full_view_oldbase();

//03//
    full_view_connections();   

//04//
    Y_gearing_all(); 
    color("orange") rod_holder_all();   
    
//05//    
    translate([0,131.1-Y,0]) Y_carriers_all();
    translate([0,131.1-Y,0]) X_gearing();
    translate([0,131.1-Y,0]) base_traverse();
    
//06//
    full_plate_frame(X,Y);
 
//07//    
    full_view_top_covers();                            
}    

////Print Jobs////
module full_print_jobs(){
//03//
    color("gold") translate([0,0,-100]) connection_plate();

//04//
    color("gold") translate ([0,0,-50]) rod_holder_all(); 

//05//
    translate([0,-50,-50]) Y_carriers_all();
  
//06//
    color("darkorange") translate([0,-50,110])  full_plate_frame(0,100); 
    //plate_carrier_all(30,50,30); 
  
    
//07//    
translate([0,0,70]) full_view_top_covers(10);   
}   

////Gearing////
module gearingXY(){
    X_gearing();   
    Y_gearing_all();    
}

////Fullview////

full_view(100,150);    
//full_print_jobs();
//gearingXY();



