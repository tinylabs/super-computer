include </home/elliot/projects/openscad/smooth-prim/smooth_prim.scad>


module button (w, h, l, head, actuator) {

    translate ([-w/2, -h/2, l/2 - head])
    SmoothXYCube([w, h, head], 0.5, $fn=40);
    translate ([0, 0, actuator-head])
    union () {
        union () {
            cube ([w + 1, h/3, l-head-actuator], center=true);
            cube ([w/3, h + 1, l-head-actuator], center=true);
        translate ([-w/6, -h/6, -(l-head)/2])
        SmoothXYCube ([w/3, h/3, actuator], 0.1);
        }  
    }
}

module button_array () {
    button (w=3, h=1.5, l=4, head=1, actuator=1);
    translate ([-8.6, 0, 0])
    button (w=3, h=1.5, l=4, head=1, actuator=1);
    translate ([-8.6*2, 0, 0])
    button (w=3, h=1.5, l=4, head=1, actuator=1);
    translate ([8.6, 0, 0])
    button (w=3, h=1.5, l=4, head=1, actuator=1);
    translate ([8.6*2, 0, 0])
    button (w=3, h=1.5, l=4, head=1, actuator=1);
}

module connector (w, l, h, period)
{
    th = 0.2; // Thickness
    rotate ([90, 0, 0])
    translate ([-l/2, 0, -h/2])
    linear_extrude (height=h)
    union () {
         for (i = [0:360*period]) {
             translate ([i* l/(360*period), sin(i)*((w-th)/2), 0])
             circle (r=th/2, $fn=20);
         }
     }
}

module connector_array () {
    translate ([-4.3, 0, 0])
    connector (w=2, l=4.8, h=0.4, period=4.5);
    translate ([4.3, 0, 0])
    connector (w=2, l=4.8, h=0.4, period=4.5);
    translate ([3*-4.3, 0, 0])
    connector (w=2, l=4.8, h=0.4, period=4.5);
    translate ([3*4.3, 0, 0])
    connector (w=2, l=4.8, h=0.4, period=4.5);
}

//projection (cut=false)
union () {
    button_array ();
    connector_array ();
}

//connector (w=3, l=4.8, h=0.3, period=4);
