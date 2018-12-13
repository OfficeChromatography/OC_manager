// TLC interface automatisation for CAMAG interface
// autoTLC-MS Interface; corner parts and rod holder
// 2018 September

////////////////////// 

////Rod holders are designed based on position R front!  
module rod_holder_all(){   ////y=118 for print 
    color("silver") 
    difference (){
        union(){
            translate([0,0,0])rod_holder_front_R();
            translate([0,0,0])rod_holder_front_L();
            translate([0,0,0])rod_holder_back_R ();
            translate([0,0,0])rod_holder_back_L ();
            translate([0,118,0])  mirror ([0,0,  0]) rod_adjust();
            translate([0,118,0])  mirror ([1,0,  0]) rod_adjust();
            translate([0,-28,0])  mirror ([0,1,  0]) rod_adjust();
            translate([0,-28,0])  rotate ([0,0,180]) rod_adjust();     
            }
         translate([0,0,0])connection_plate_negativ();
         translate([0,0,0])connection_plate_negativ(); 
        
        translate([0,0,0]) mirror([1,0,0]) Y_gearing_out_R();
        translate([0,0,0])                 Y_gearing_out_R();   
        translate([0,0,0]) mirror([1,0,0]) Y_gearing_out_R();
        translate([0,0,0])                 Y_gearing_out_R();   
     
        translate([0,0,0]) mirror([1,0,0]) rods();
        translate([0,0,0])                 rods();
        translate([0,0,0]) mirror([1,0,0]) rods();
        translate([0,0,0])                 rods();   
        }
    }     

    module rod_holder_hull_back(){
        difference(){  
        union(){                  
        ////endstop  
        hull(){
            translate([126.5,-74,-54]) rotate([0,90]) cylinder(h=7,r=3,center=true,$fn=60);
            translate([126.5,-84.5,-57.5]) color("blue") cube([7,7,13],center=true); 
            translate([126.5,-77.5,-60.5]) color("blue") cube([7,13,7],center=true);}
        hull(){
            translate([85,-127,-64]) cube([70,50,0.01]);
            translate([85,-117,-13]) cube([28,40,0.1]);
                 
            translate([106,-152,-59]) rotate([0,90]) cylinder(h=42,r=5,center=true); 
            translate([106,-152,-24]) rotate([0,90]) cylinder(h=42,r=5,center=true);   
            
            translate([151,-102,-48]) rotate([90,0]) cylinder(h=50,r=5,center=true);
            translate([133,-97,-18]) rotate([90,0]) cylinder(h=40,r=5.1,center=true);              
            }
            }
        //big base outcut
        translate([0,239,-35])cube([68,98,40],center=true);
        CubePoints3=[ 
            [-115,-115,-55],  
            [ 115,-115,-55],  
            [ 115, 205,-55],  
            [-115, 205,-55], 
            [-104,-104,-15],  
            [ 104,-104,-15],  
            [ 104, 194,-15], 
            [-104, 194,-15]]; 
        CubeFaces3=[[0,1,2,3],[4,5,1,0],[7,6,5,4],[5,6,2,1],[6,7,3,2],[7,4,0,3]];  
        color("silver") polyhedron(CubePoints3,CubeFaces3);      
        //////////////
        translate([67,-67,-59]) cylinder(h=11,r=30,center=true); 
        translate([120,-73,-57.5]) rotate([0,180,-90]) endstop();
         }
    }
    
    module rod_holder_hull_front(){
        difference(){  
        hull(){
        translate([85,-127,-64]) cube([70,50,0.01]);
        translate([95,-112,-13]) cube([8,35,0.1]);
        translate([151,-97,-48]) rotate([90,0]) cylinder(h=40,r=5,center=true);
        translate([133,-92,-18]) rotate([90,0]) cylinder(h=30,r=5.1,center=true);
        }
        //big base outcut
        translate([0,239,-35])cube([68,98,40],center=true);
        CubePoints3=[ 
            [-115,-115,-55],  
            [ 115,-115,-55],  
            [ 115, 205,-55],  
            [-115, 205,-55], 
            [-104,-104,-15],  
            [ 104,-104,-15],  
            [ 104, 194,-15], 
            [-104, 194,-15] ]; 
        CubeFaces3=[[0,1,2,3],[4,5,1,0],[7,6,5,4],[5,6,2,1],[6,7,3,2],[7,4,0,3]];  
        color("silver") polyhedron(CubePoints3,CubeFaces3);      
        //////////////
        translate([59.5,-165,-65]) rotate([-10,0,10])cube([50,50,250]);
        translate([42,-146.5,-65]) rotate([0,0,-10])cube([50,50,250]);  
        translate([67,-67,-59]) rotate([00,0]) cylinder(h=11,r=30,center=true);
        }
    }
    
    module rod_holder_inside(){
    //cut outs//
    translate([74.5,-104.3,-22]) cube([30,30,10]);
    translate([109.5,-109.5,-35])rotate([-15.5,-14.7,0])cylinder(h=44,r=1,center=true,$fn=12);
    translate([115,-96,-55])rotate([90,0,0])cylinder(h=40,r=1,center=true,$fn=12);
    translate([96,-115,-55])rotate([0,90,0])cylinder(h=40,r=1,center=true,$fn=12);
    //pedestal holes//
    translate([95,-95,-59]) cylinder(h=4.5, r=2.2,$fn=12);
    translate([95,-95,-64.1]) cylinder(h=5.2, r=4,$fn=12);
    translate([111,-98,-64.5]) cylinder(h=10, r=2,$fn=12);
    }

        module rod_holder_front_R(){
            difference (){
            rod_holder_hull_front();
            rod_holder_inside();}
            }
   
            module rod_holder_front_L(){
            translate ([0,0,0]) mirror ([1,0,0]) rod_holder_front_R();
            }  
    
            module rod_holder_back(){
            difference (){
            rod_holder_hull_back();
            rod_holder_inside();}
            }
    
            module rod_holder_back_R(){     
            translate ([0,90,0]) mirror ([0,1,0]) rod_holder_back();
            }
    
            module rod_holder_back_L(){
            translate ([0,0,0]) mirror ([1,0,0]) rod_holder_back_R();
            }
                   
            module endstop(){
                    color("red") translate([3.25,0,2]) rotate([0,90]) cylinder(h=1,r=0.5,$fn=60,center=true);
                    color("red") translate([3.25,0,-2]) rotate([0,90]) cylinder(h=1,r=0.5,$fn=60,center=true);
                    color("red") rotate([0,90]) cylinder(h=1,r=0.5,$fn=60,center=true);
                    color("red") translate([-1.75,2,3.25]) rotate([90,0]) cylinder(h=15,r=1,$fn=60,center=true);
                    color("red") translate([-1.75,2,-3.25]) rotate([90,0]) cylinder(h=15,r=1,$fn=60,center=true);
                    translate([-4,0,0]) color("grey") cube([14.5,6,13.1],center=true); 
                    translate([ 0,0,0]) color("grey") cube([  6.5,6,13.1],center=true);  
                    }
                module connection_plate_negativ(){
    difference(){
        union(){//core square//          
            hull(){
                translate([-115,193,-15]) cylinder(h=4,r=1,$fn=60);
                translate([115,193,-15]) cylinder(h=4,r=1,$fn=60);
                translate([-115,-103,-15]) cylinder(h=4,r=1,$fn=60);
                translate([115,-103,-15]) cylinder(h=4,r=1,$fn=60);
                }
            hull(){//side connections back//
                translate([-115,182,-15]) cylinder(h=4,r=12.3,$fn=60);
                translate([115,182,-15]) cylinder(h=4,r=12.3,$fn=60);
                }        
            hull(){//side connections front//
                translate([-115,-92,-15]) cylinder(h=4,r=12.3,$fn=60);
                translate([115,-92,-15]) cylinder(h=4,r=12.3,$fn=60);
                }
            }
        //difference//
        union(){   
            //cutout L//
            hull(){    
                //innercutout//
                translate([-30,40,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                translate([-75,-40,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                //outhercutout
                translate([-116,-64.7,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                translate([-116,154.7,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                }
            //cutout R//
            hull(){
                //innercutout//  
                translate([30,40,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                translate([75,-40,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                //outhercutout
                translate([116,-64.7,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                translate([116,154.7,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                } 
            
                }
                hull(){
                translate([-100,200,-16]) cylinder(h=6,r=1,$fn=60);
                translate([100,200,-16]) cylinder(h=6,r=1,$fn=60);
                translate([-100,-110,-16]) cylinder(h=6,r=1,$fn=60);
                translate([100,-110,-16]) cylinder(h=6,r=1,$fn=60);    
                }               
        }
        //screwholes//      
        color("red") union(){   
            //translate([-116,-92,-22.9]) cylinder(h=8,r=1.7,$fn=60);
            //translate([-116,182,-22.9]) cylinder(h=8,r=1.7,$fn=60);
            //translate([ 116,-92,-22.9]) cylinder(h=8,r=1.7,$fn=60);
            //translate([ 116,182,-22.9]) cylinder(h=8,r=1.7,$fn=60);
            
            translate([-112,-92,-22.9]) cylinder(h=8,r=1.7,$fn=60);
            translate([-112,182,-22.9]) cylinder(h=8,r=1.7,$fn=60);
            translate([ 112,-92,-22.9]) cylinder(h=8,r=1.7,$fn=60);
            translate([ 112,182,-22.9]) cylinder(h=8,r=1.7,$fn=60);
                    
            translate([-120,-92,-22.9]) cylinder(h=8,r=1.7,$fn=60);
            translate([-120,182,-22.9]) cylinder(h=8,r=1.7,$fn=60);
            translate([ 120,-92,-22.9]) cylinder(h=8,r=1.7,$fn=60);
            translate([ 120,182,-22.9]) cylinder(h=8,r=1.7,$fn=60);    
            }
    }
                  
////Gearing parts         
    module Y_gearing(){  
        rotate([0,0,0]) nema14_Y();   
        translate ([0,-318,0]) rotate([90,0,90]) 8mm_belt_bearing();                   
        color("black") translate([7,-160,0]) cube([2,318,6],center=true);
        color("black") translate([-7,-160,0]) cube([2,318,6],center=true);    
        } 
           
        module Y_gearing_all(){                                                          
                translate ([121,225,-34]) rotate ([0,75,0]) Y_gearing();                                                                       
                translate ([-121,225,-34]) rotate ([0,-75,0]) Y_gearing();             
                
                translate([120,163,-57.5]) rotate([0,0,-90]) endstop();
                translate([-120,163,-57.5]) rotate([0,180,90]) endstop();
       
                 color("red") translate([ 132,45,-22]) rotate([90,0]) cylinder(h=285,r=4.35,center=true,$fn=30);
                 color("red") translate([ 147,45,-48]) rotate([90,0]) cylinder(h=285,r=4.35,center=true,$fn=30);
                 color("red") translate([-132,45,-22]) rotate([90,0]) cylinder(h=285,r=4.35,center=true,$fn=30);
                 color("red") translate([-147,45,-48]) rotate([90,0]) cylinder(h=285,r=4.35,center=true,$fn=30);
                }
               
                module nema14_Y(){
        union(){
            color("black") translate([0,0,-27]) cube([36,36,38],center=true);  
            color("silver") translate([0,0,-8]) cylinder(h=21,r=2.5,$fn=60); 
            color("silver") translate([0,0,-8]) cylinder(h=2,r=11.5,$fn=60); 
            //zahnrad//
            color("grey") difference(){
                translate([0,0,-4]) cylinder(h=16,r=8,$fn=60); 
                translate([0,0,-3]) cylinder(h=6,r=8.1,$fn=60);
                }
            }
        color("black") translate([0,0,-3]) cylinder(h=6,r=8,$fn=60);
            
            //mounting screws        
        color("red") union(){
            translate([ 13, 13, -8]) cylinder(h=10,r=1.7,$fn=60);  
            translate([-13, 13, -8]) cylinder(h=10,r=1.7,$fn=60);  
            translate([ 13,-13, -8]) cylinder(h=10,r=1.7,$fn=60);   
            translate([-13,-13, -8]) cylinder(h=10,r=1.7,$fn=60);      
            }
        }     
                module 8mm_belt_bearing(){
                color("red") rotate([90,0]) cylinder(h=31,r=1.6,center=true,$fn=30);
                //washers
                translate([0,3.25,0]) rotate([90,0]) cylinder(h=0.5,r=2,center=true);
                translate([0,-3.25,0]) rotate([90,0]) cylinder(h=0.5,r=2,center=true);
                translate([0,4.25,0]) rotate([90,0]) cylinder(h=1,r=8,center=true);
                translate([0,-4.25,]) rotate([90,0]) cylinder(h=1,r=8,center=true);
                color("black") translate([0,0,0]) rotate([90,0]) cylinder(h=7,r=8,center=true);   
                }
                
        module Y_gearing_out(){  
            nema14_Y_neg();

            color("orange") hull(){
            cylinder(h=12.5,r=9.5,center=true,$fn=60);     
            translate([0,-70,0]) cylinder(h=12.5,r=9,center=true,$fn=60);}
            
            color("orange") hull(){
            cylinder(h=20,r=12.5,center=true,$fn=60);     
            translate([0,-9,0]) cylinder(h=20,r=9,center=true,$fn=60);}
     
            translate ([0,-318,0]) rotate([-90,0,90]) 8mm_belt_bearing_out_Y();         //belt    
            color("black") translate([7,-159,0]) cube([4,300,8],center=true);
            color("black") translate([-7,-159,0]) cube([3.5,300,7],center=true);
            }  
                 
        module Y_gearing_out_R(){                                                          
                        translate ([121,225,-34]) rotate ([0,75,0]) Y_gearing_out();} 
                                     
                module nema14_Y_neg(){          
            translate([0,0,-27]) cube([37,37,38],center=true);  
            translate([0,0,-8]) cylinder(h=22,r=12,$fn=60); 
   
            //mounting screws        
            translate([ 13, 13, -8.1]) cylinder(h=10,r=1.7,$fn=60);  
            translate([-13, 13, -8.1]) cylinder(h=10,r=1.7,$fn=60);  
            translate([ 13,-13, -8.1]) cylinder(h=10,r=1.7,$fn=60);   
            translate([-13,-13, -8.1]) cylinder(h=10,r=1.7,$fn=60);           
        
            //enlarged motor cutout          
            color("red")translate([-30,-24,0])cube([80,60,45]);              
            color("red")translate([-30,-18.5 ,-48])cube([60,60,40]);       
        }

                module 8mm_belt_bearing_out_Y (){ 
                    color("red") translate([0,0,0]) rotate([90,0]) cylinder(h=28,r=1.55,center=true,$fn=30);
                    color("red") translate([0,11.5,0]) rotate([90,0]) cylinder(h=5.1,r=3.5,center=true,$fn=30);    
    
                    color("orange") hull(){
                    rotate([90,0]) cylinder(h=14.6,r=9.5,center=true,$fn=90);  
                    translate([20,0,0]) rotate([90,0]) cylinder(h=14.6,r=9.5,center=true,$fn=90);}
                    }
      module rods(){
         //8 mm rod (r=4.15 up to 4.3 
        color("red") translate([132,45,-22]) rotate([90,0]) cylinder(h=285,r=4.3,center=true,$fn=30);
        color("red") translate([147,45,-48]) rotate([90,0]) cylinder(h=285,r=4.3,center=true,$fn=30);
        }          
  
      module rod_adjust(){
        //8 mm rod
        difference(){hull(){
        translate([132,45,-22]) rotate([90,0]) cylinder(h=7,r=8,center=true,$fn=30);
        translate([147,45,-48]) rotate([90,0]) cylinder(h=7,r=8,center=true,$fn=30);
        }
        translate([137.8,45,-32]) rotate([90,0]) cylinder(h=8,r=1.5,center=true,$fn=30);
        translate([141.2,45,-38]) rotate([90,0]) cylinder(h=8,r=1.5,center=true,$fn=30);
        translate([137.8,42.99,-32]) rotate([90,0]) cylinder(h=3,r=3,center=true,$fn=30);
        translate([141.2,42.99,-38]) rotate([90,0]) cylinder(h=3,r=3,center=true,$fn=30);
        }}                    
                    
////////////////////    
////VIEW////
//Printed Parts
 rod_holder_all();              


//Gearing parts
//Y_gearing_all(); 
 
    
