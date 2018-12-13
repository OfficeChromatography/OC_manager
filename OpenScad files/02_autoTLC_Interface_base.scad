// TLC interface automatisation for CAMAG interface
// autoTLC-MS Interface; old and new base
// 2018 September

////////////////////

module base(){
    difference(){
        color("silver") union(){
            translate([0,239,-35]) cube([68,98,40],center=true);
                CubePoints3=[ 
            [-115.01,-115.01,-55.01],  
            [ 115.01,-115.01,-55.01],  
            [ 115.01, 205.01,-55.01],  
            [-115.01, 205.01,-55.01], 
            [-104.01,-104.01,-14.99],  
            [ 104.01,-104.01,-14.99],  
            [ 104.01, 194.01,-14.99], 
            [-104.01, 194.01,-14.99]];   
            CubeFaces3=[[0,1,2,3],[4,5,1,0],[7,6,5,4],[5,6,2,1],[6,7,3,2],[7,4,0,3]];  
            polyhedron(CubePoints3,CubeFaces3);}        
            color ("orange") for(i = [-1,1]){
                //big cutout left//
                hull(){
                    translate([i*67,-67,-56]) cylinder(h=33, r=30);
                    translate([i*67,157,-56]) cylinder(h=33, r=30);
                    translate([i*42,-89,-56]) cylinder(h=33, r=8);
                    translate([i*42,179,-56]) cylinder(h=33, r=8);
                    }
                ///small cutout front left///
                hull(){
                    translate([i*12,-89,-56]) cylinder(h=33, r=8);
                    translate([i*18,-89,-56]) cylinder(h=33, r=8);
                    translate([i*12,-30,-56]) cylinder(h=33, r=8);
                    translate([i*18,-25,-56]) cylinder(h=33, r=8);
                    }
                ///small cutout back left///
                hull(){
                    translate([i*12, 30,-56]) cylinder(h=33, r=8);
                    translate([i*18, 25,-56]) cylinder(h=33, r=8);
                    translate([i*12,271,-56]) cylinder(h=33, r=8);
                    translate([i*18,271,-56]) cylinder(h=33, r=8);
                    }
            }
        color("red") union(){//screw holes//
            //front//
            translate([-20,-35,-24]) cylinder(h=5,r=2,$fn=60,cetner=true);
            translate([20,-35,-24]) cylinder(h=5,r=2,$fn=60,cetner=true);
            //back//
            translate([80,167,-24]) cylinder(h=5,r=2,$fn=60,cetner=true);
            translate([-80,167,-24]) cylinder(h=5,r=2,$fn=60,cetner=true);
            //pedestal//
            translate([ 95,-95,-55.01]) cylinder(h=5, r=2,$fn=60);
            translate([-95,-95,-55.01]) cylinder(h=5, r=2,$fn=60);
            translate([ 95,185,-55.01]) cylinder(h=5, r=2,$fn=60);
            translate([-95,185,-55.01]) cylinder(h=5, r=2,$fn=60);
            }
        }
    } 
   
module baseplate(){
    difference(){
        union(){
            baseplate_top();
            baseplate_bottom();
            }
        union(){
            hull(){
                translate([0,0,-10.01]) cylinder(h=3,r=15.1,$fn=60);
                translate([20,-34.641,-10.01]) cylinder(h=3,r=15.1,$fn=60);
                translate([-20,-34.641,-10.01]) cylinder(h=3,r=15.1,$fn=60);
                }     
            translate([-80,170,-10.01]) cylinder(h=3,r=15.1,$fn=60);
            translate([80,170,-10.01]) cylinder(h=3,r=15.1,$fn=60);
            }
        }
    }
    module baseplate_top(){        
    CubePoints=[
        [-137,-134,-8],  
        [ 137,-134,-8],  
        [ 137, 200,-8],  
        [-137, 200,-8],  
        [-135,-132, 0],  
        [ 135,-132, 0],  
        [ 135, 198, 0],  
        [-135, 198, 0]]; 
        CubeFaces=[[0,1,2,3],[4,5,1,0],[7,6,5,4],[5,6,2,1],[6,7,3,2],[7,4,0,3]];
    color("grey") polyhedron(CubePoints,CubeFaces);
    }
  
    module baseplate_bottom(){
    CubePoints2=[ 
        [-135,-132,-10],  
        [ 135,-132,-10],  
        [ 135, 198,-10],  
        [-135, 198,-10], 
        [-137,-134, -8],  
        [ 137,-134, -8],  
        [ 137, 200, -8], 
        [-137, 200, -8]]; 
        CubeFaces2=[[0,1,2,3],[4,5,1,0],[7,6,5,4],[5,6,2,1],[6,7,3,2],[7,4,0,3]];  
    color("grey") polyhedron(CubePoints2,CubeFaces2);
    }
     
    module connections(){
    color("orange") union(){
        hull(){
            translate([0,0,-15]) cylinder(h=8,r=15);
            translate([-20,-34.641,-15]) cylinder(h=8,r=15);
            translate([20,-34.641,-15]) cylinder(h=8, r=15);
            }      
        translate([80,170,-15]) cylinder(h=8,r=15);
        translate([-80,170,-15]) cylinder(h=8,r=15); 
        }
    }
    module pedestals01(){
    color("black") union(){  
        translate([-95,-95,-68]) cylinder(h=13, r=10);
        translate([ 95,-95,-68]) cylinder(h=13, r=10);
        translate([ 95,185,-68]) cylinder(h=13, r=10);
        translate([-95,185,-68]) cylinder(h=13, r=10);
        }
    }
         
module stamp_stage(){
    color ("silver") union(){
        translate([0,28,27]) rotate([0,90,0]) cylinder(h=70, r=4,center=true,center=true,$fn=60); 
        for(i=[-1,1]){
            translate([i*37,133,80.5]) cube([6,310,65],center=true);
            translate([i*37,150,29]) cube([6,276,38],center=true);
            translate([i*37,247,-22.5]) cube([6,82,65],center=true);
            }
        }
    }
    
    module stamp(){ 
    color("silver") union(){$fn=100;
        translate([0,0,(20)]) cylinder(h=20,r=9);
        translate([0,0,(30)]) cylinder(h=40,r=7);
        translate([0,0,(16)]) cylinder(h=4,r=4);
        translate([0,0,(14)]) cylinder(h=2,r1=2,r2=4);       
        
        translate([0,0,69]) cube([45,45,38],center=true);
        translate([0,4,100.5]) cube([68,60,27],center=true);
        
        translate([-29,-26.5,116]) cube([6,3,4.5],center=true);
        translate([29,-26.5,116]) cube([6,3,4.5],center=true);
        }  
    }
    module drawer(){
        
drawer_x = 68;
drawer_y = 150;
drawer_z = 12;
drawer_x_bias = 0;
drawer_y_bias = 13+drawer_y/2;
drawer_z_bias = 10+drawer_z/2;
drawer_neg_cyl_h = 4;
drawer_neg_cyl_r = 12;
drawer_neg_cyl_x_bias = 0;
drawer_neg_cyl_y_bias = 30;
drawer_neg_cyl_z_bias = 18.1;
drawer_neg_cube_x = 12;
drawer_neg_cube_y = 4;
drawer_neg_cube_z = 4;
drawer_neg_cube_x_bias = -6;
drawer_neg_cube_y_bias = 12.9;
drawer_neg_cube_z_bias = drawer_neg_cyl_z_bias; 

    difference(){
    color ("white") translate([drawer_x_bias, drawer_y_bias, drawer_z_bias]) cube([drawer_x ,drawer_y ,drawer_z],center=true); 
    color ("lightgrey") hull(){
    translate([drawer_neg_cyl_x_bias,drawer_neg_cyl_y_bias,drawer_neg_cyl_z_bias]) cylinder(h=drawer_neg_cyl_h,d=drawer_neg_cyl_r);
    translate([drawer_neg_cube_x_bias,drawer_neg_cube_y_bias,drawer_neg_cube_z_bias]) cube([drawer_neg_cube_x,drawer_neg_cube_y,drawer_neg_cube_z]);
    }
    }
    }
    
    module top_cover(){
    
top_cover_x = 83;
top_cover_y = 319;
top_cover_z = 68;
top_cover_x_bias = 0;
top_cover_y_bias = -30+top_cover_y/2;
top_cover_z_bias = 47+top_cover_z/2;
top_cover_back_x = 77;
top_cover_back_y = 2;
top_cover_back_z = 68;
top_cover_back_x_bias = -38.5;
top_cover_back_y_bias = 287;
top_cover_back_z_bias = -21;
top_cover_neg_h = 40;
top_cover_neg_d = 10;
top_cover_neg_x_bias = 2;
top_cover_neg_y_bias_1 = 170;
top_cover_neg_y_bias_2 = top_cover_neg_y_bias_1+50;
top_cover_neg_z_bias = 65;
    
    difference(){
    translate([top_cover_x_bias,top_cover_y_bias,top_cover_z_bias]) color("lightgrey")cube([top_cover_x,top_cover_y,top_cover_z],center=true);
    color("grey")hull(){
    translate([top_cover_neg_x_bias,top_cover_neg_y_bias_1,top_cover_neg_z_bias]) rotate([0,90]) cylinder(h=top_cover_neg_h,d=top_cover_neg_d);
    translate([top_cover_neg_x_bias,top_cover_neg_y_bias_2,top_cover_neg_z_bias]) rotate([0,90]) cylinder(h=top_cover_neg_h,d=top_cover_neg_d);
    }
    }
    translate([top_cover_back_x_bias,top_cover_back_y_bias,top_cover_back_z_bias]) color("lightgrey") cube([top_cover_back_x,top_cover_back_y,top_cover_back_z]);
    }
        
    module blue_cover(){
            
    blue_cover_big_cyl_h = 79;
    blue_cover_big_cyl_r = 400;
    blue_cover_big_cyl_z_bias = -3;
    blue_cover_neg_x = 90;
    blue_cover_neg_y_1 = 460;
    blue_cover_neg_y_2 = 160;
    blue_cover_neg_z_1 = 330;
    blue_cover_neg_z_2 = 160;
    blue_cover_neg_x_bias = -45;
    blue_cover_neg_y_bias_1 = -240;
    blue_cover_neg_y_bias_2 = -200;
    blue_cover_neg_z_bias_1 = -215;
    blue_cover_neg_z_bias_2 = 100;
    blue_cover_neg_roate_x = 345;   

    difference(){$fn=300;
    color("steelblue") translate([0,0,blue_cover_big_cyl_z_bias]) rotate([0,90,0]) cylinder(h=blue_cover_big_cyl_h,d=blue_cover_big_cyl_r,center=true);
    color("lightgrey") translate([blue_cover_neg_x_bias,blue_cover_neg_y_bias_1,blue_cover_neg_z_bias_1]) cube([blue_cover_neg_x,blue_cover_neg_y_1,blue_cover_neg_z_1]); 
    color("steelblue") translate([blue_cover_neg_x_bias,blue_cover_neg_y_bias_2,blue_cover_neg_z_bias_2]) rotate([blue_cover_neg_roate_x,0,0]) cube([blue_cover_neg_x,blue_cover_neg_y_2,blue_cover_neg_z_2]);
    }
    color("black") translate([0,-20,130.4]) rotate([75,0,0]) cylinder(h=10,d=18);
    color("slategrey") translate([0,-18,130]) rotate([75,0,0]) cylinder(h=10,d=20);
    difference(){
    color("slategrey") translate([0,-13,155]) rotate([75,0,0]) cylinder(h=10,d=16);   
    color("slategrey") translate([0,-14,155.2]) rotate([75,0,0]) cylinder(h=10,d=12);}color("black") translate([0,-12,155]) rotate([75,0,0]) cylinder(h=10,d=14);
    color("grey") translate([0,-14,155]) rotate([95,0,0]) cylinder(h=23,d=5); 
    color("black") translate([0,-7,180.5]) rotate([75,0,0]) cylinder(h=10,d=15);
    color("slategrey") translate([0,-5,180]) rotate([75,0,0]) cylinder(h=10,d=18);
    }
 
    module laser(){
    CubePoints4=[ 
        [-43,-10,47],  
        [-40,-10,47],  
        [-40, 10,47],  
        [-43, 10,47], 
        [-73,-10,91],  
        [-40,-10,111],  
        [-40, 10,111], 
        [-73, 10,91]]; 
    CubeFaces4=[[0,1,2,3],[4,5,1,0],[7,6,5,4],[5,6,2,1],[6,7,3,2],[7,4,0,3]];  
    color("steelblue") polyhedron(CubePoints4,CubeFaces4); 
    color("red") cylinder(h=0.01, r=1);      
    }
    
    module gasvalve(){
    color("darkgrey") translate([-11,260,113]) rotate([0,0,0]) cylinder(h=3,d=40); 
    color("darkgrey") translate([-11,260,113]) rotate([0,0,0]) cylinder(h=27,d=25);
    color("darkgrey") translate([-11,260,137]) rotate([0,0,0]) cylinder(h=5,d=20);
    color("white") translate([-42,260,89]) rotate([0,90,0]) cylinder(h=5,d=20); 
    }
        
    module valve_6port(){
    color("darkgrey") translate([0,195,89]) rotate([0,0,0]) cylinder(h=33,d=35); 
    color("darkgrey") translate([0,195,120]) rotate([0,0,0]) cylinder(h=7,d=20);
    color("darkgrey") translate([0,195,127]) rotate([0,0,0]) cylinder(h=3,r1=10,r2=3);
    color("green") translate([0,195,110]) rotate([0,20]) cylinder(h=20,d=5);  
    color("red") translate([0,195,110]) rotate([0,-20]) cylinder(h=20,d=5);  
    color("green") translate([0,195,110]) rotate([16,10]) cylinder(h=20,d=5);  
    color("red") translate([0,195,110]) rotate([16,-10]) cylinder(h=20,d=5);  
    color("yellow") translate([0,195,110]) rotate([-16,10]) cylinder(h=20,d=5);  
    color("yellow") translate([0,195,110]) rotate([-16,-10]) cylinder(h=20,d=5);
    }
       
//////////   
module full_view_oldbase(){
base();
baseplate();
    connections();       
    pedestals01();
stamp_stage();
    stamp();
    drawer();
    top_cover();
    blue_cover();
    laser();
    gasvalve();
    valve_6port();       
    }
    
module full_view_base(){
base();
baseplate();
    connections();          
    stamp_stage();
    stamp();
    drawer();
    laser();
    gasvalve();
    translate([0,-20,20]) valve_6port();       
    }

//////////   
//full_view_oldbase();  
full_view_base();