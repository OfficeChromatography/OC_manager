// TLC interface automatisation for CAMAG interface
// autoTLC-MS Interface; all connections
// 2018 September

////////////////////// 

module connection_plate(){
    difference(){
        union(){//core square//          
            hull(){
                translate([-115,193,-15]) cylinder(h=4,r=1,$fn=60);
                translate([115,193,-15]) cylinder(h=4,r=1,$fn=60);
                translate([-115,-103,-15]) cylinder(h=4,r=1,$fn=60);
                translate([115,-103,-15]) cylinder(h=4,r=1,$fn=60);
                }
            hull(){//side connections back//
                translate([-116,182,-15]) cylinder(h=4,r=12,$fn=60);
                translate([116,182,-15]) cylinder(h=4,r=12,$fn=60);
                }        
            hull(){//side connections front//
                translate([-116,-92,-15]) cylinder(h=4,r=12,$fn=60);
                translate([116,-92,-15]) cylinder(h=4,r=12,$fn=60);
                }
            }
        //difference//
        union(){//baseposts// !Set r=15.5 for print; r=15.1 for CNC!
            hull(){
                translate([0,0,-15.01]) cylinder(h=4.02,r=15.5,$fn=60);
                translate([20,-34.641,-15.01]) cylinder(h=4.02,r=15.5,$fn=60);
                translate([-20,-34.641,-15.01]) cylinder(h=4.02,r=15.5,$fn=60);
                }     
            translate([-80,170,-15.01]) cylinder(h=4.02,r=15.5,$fn=60);
            translate([80,170,-15.01]) cylinder(h=4.02,r=15.5,$fn=60);
            //screwholes//      
            translate([-112,-92,-15.01]) cylinder(h=4.02,r=1.7,$fn=60);
            translate([-112,182,-15.01]) cylinder(h=4.02,r=1.7,$fn=60);
            translate([112,-92,-15.01]) cylinder(h=4.02,r=1.7,$fn=60);
            translate([112,182,-15.01]) cylinder(h=4.02,r=1.7,$fn=60);
                
            translate([-120,-92,-15.01]) cylinder(h=4.02,r=1.7,$fn=60);
            translate([-120,182,-15.01]) cylinder(h=4.02,r=1.7,$fn=60);
            translate([120,-92,-15.01]) cylinder(h=4.02,r=1.7,$fn=60);
            translate([120,182,-15.01]) cylinder(h=4.02,r=1.7,$fn=60);    
            //cutout L//
            hull(){    
                //innercutout//
                translate([-30,40,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                translate([-75,-40,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                //outhercutout
                translate([-116,-65,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                translate([-116,155,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                }
            //cutout R//
            hull(){
                //innercutout//  
                translate([30,40,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                translate([75,-40,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                //outhercutout
                translate([116,-65,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                translate([116,155,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                }
            //cutout front//
            hull(){    
                //innercutout//
                translate([52,-70,-15.01]) cylinder(h=4.02,r=5.1,$fn=60);
                translate([-52,-70,-15.01]) cylinder(h=4.02,r=5.1,$fn=60);
                //outhercutout//
                translate([78,-84,-15.01]) cylinder(h=4.02,r=5.1,$fn=60);
                translate([-78,-84,-15.01]) cylinder(h=4.02,r=5.1,$fn=60);
                }          
            //cutout back//
            hull(){    
                //innercutout//
                translate([0,76,-15.01]) cylinder(h=4.02,r=15.1,$fn=60);
                //outhercutout//  
                translate([60,140,-15.01]) cylinder(h=4.02,r=5.1,$fn=60);
                translate([50,173,-15.01]) cylinder(h=4.02,r=5.1,$fn=60);         
                translate([-60,140,-15.01]) cylinder(h=4.02,r=5.1,$fn=60);
                translate([-50,173,-15.01]) cylinder(h=4.02,r=5.1,$fn=60);
                }     
            }
        }
    }
 
    
    module connection_plate_print_cuts(){       
    //cut middle R//
        hull(){    
            translate([0,40,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([5,40,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([3,50,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([5,40,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([3,50,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([13,50,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([11,40,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([13,50,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([11,40,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([20,40,-16]) cylinder(h=6,r=0.25,$fn=60);
            }       
    //cut middle L//
        hull(){    
            translate([0,40,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([-5,40,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([-3,50,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([-5,40,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([-3,50,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([-13,50,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([-11,40,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([-13,50,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([-11,40,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([-20,40,-16]) cylinder(h=6,r=0.25,$fn=60);
            }       
    //middlecuts//
        hull(){    
            translate([0,32,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,70,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([0,32,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([10,34,-16]) cylinder(h=6,r=0.25,$fn=60);
            }  
        hull(){    
            translate([10,24,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([10,34,-16]) cylinder(h=6,r=0.25,$fn=60);
            }    
        hull(){    
            translate([10,24,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,26,-16]) cylinder(h=6,r=0.25,$fn=60);
            }      
        hull(){    
            translate([0,0,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,26,-16]) cylinder(h=6,r=0.25,$fn=60);
            }      
    //middlefront//
        hull(){    
            translate([0,-40,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,-54,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([0,-54,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([10,-52,-16]) cylinder(h=6,r=0.25,$fn=60);
            }  
        hull(){    
            translate([10,-52,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([10,-62,-16]) cylinder(h=6,r=0.25,$fn=60);
            }    
        hull(){    
            translate([10,-62,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,-60,-16]) cylinder(h=6,r=0.25,$fn=60);
            }      
        hull(){    
            translate([0,-60,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,-70,-16]) cylinder(h=6,r=0.25,$fn=60);
            }           
    //front// 
         hull(){    
            translate([0,-80,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,-93.5,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([0,-93.5,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([10,-91.5,-16]) cylinder(h=6,r=0.25,$fn=60);
            }  
        hull(){    
            translate([10,-91.5,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([10,-101.5,-16]) cylinder(h=6,r=0.25,$fn=60);
            }    
        hull(){    
            translate([10,-101.5,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,-99.5,-16]) cylinder(h=6,r=0.25,$fn=60);
            }      
        hull(){    
            translate([0,-99.5,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,-109.5,-16]) cylinder(h=6,r=0.25,$fn=60);
            }        
    //back//
         hull(){    
            translate([0,175,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,183,-16]) cylinder(h=6,r=0.25,$fn=60);
            }
        hull(){    
            translate([0,183,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([10,181,-16]) cylinder(h=6,r=0.25,$fn=60);
            }  
        hull(){    
            translate([10,181,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([10,191,-16]) cylinder(h=6,r=0.25,$fn=60);
            }    
        hull(){    
            translate([10,191,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,189,-16]) cylinder(h=6,r=0.25,$fn=60);
            }      
        hull(){    
            translate([0,189,-16]) cylinder(h=6,r=0.25,$fn=60);          
            translate([0,200,-16]) cylinder(h=6,r=0.25,$fn=60);
            }          
    }
    
    module connection_plate_print(){   
    difference(){
        connection_plate();
        connection_plate_print_cuts();
        }
    }
    
module pedestals(){
    color("black") union(){  
        translate([-111,-98,-77]) cylinder(h=13, r=10);
        translate([ 111,-98,-77]) cylinder(h=13, r=10);
        translate([ 111,188,-77]) cylinder(h=13, r=10);
        translate([-111,188,-77]) cylinder(h=13, r=10);
        }
    color("red") union(){  
        translate([-111,-98,-64]) cylinder(h=10, r=1.6,$fn=60);
        translate([ 111,-98,-64]) cylinder(h=10, r=1.6,$fn=60);
        translate([ 111,188,-64]) cylinder(h=10, r=1.6,$fn=60);
        translate([-111,188,-64]) cylinder(h=10, r=1.6,$fn=60);
        }    
    }    
 
////////////////////    
////VIEW////
module full_view_connections(){
    color("yellow") translate([0,0,0.01]) connection_plate();
    pedestals();  
    }    
    
full_view_connections();    