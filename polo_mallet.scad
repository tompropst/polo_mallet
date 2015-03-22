/*******************************************************************************
* Author: Tom Propst
* Title : Polo Mallet Head
* Rev   : A
*******************************************************************************/

$fn = 24;

radius = 25;
straightLength = 55;
bendRadius = 40;
bendAngle = 45;
poleDia = 13; // At the cut end
poleTaper = 0.6; // degrees
headAngle = 15;
poleDepth = 0.75; // percent depth of the head - 50% or less will miss the bolt
face = 15; // distance from centerline to face
boltDia = 5; // actual 5mm bolt is too tight with this set to 5 when using ABS
// The calculation below puts the pivot point of the head angle at the end of 
// the shaft. It would be better to put it at the center of the mass (making 
// boltY always zero.
boltY = (poleDepth*2*radius-radius) * tan(headAngle);
boltHeadDia = 11; 
nutWidth = 8.6; // polygons this small come out poorly in ABS
nutDepth = 4;
// Options:
traction = 1; // Add traction to the bottom = 1, no traction = 0

echo(boltY);
/*****
* The following 2 modules for creating an elbow came from:
* http://www.thingiverse.com/thing:34027/#instructions
*****/

module pie_slice(radius, angle, step) {
  for(theta = [0:step:angle-step]) {
    rotate([0,0,0]) linear_extrude(height = radius*2, center=true)
      polygon( points = [[0,0],
               [radius * cos(theta+step) ,radius * sin(theta+step)],
               [radius*cos(theta),radius*sin(theta)]]
      );
  };
};

module partial_rotate_extrude(angle, radius, convex) {
  intersection () {
    rotate_extrude(convexity=convex) translate([radius,0,0]) children(0);
    pie_slice(radius*2, angle, angle/5);
  };
};



difference() {
  union() {
    // Straight Section
    difference() {
      rotate([-90,0,0]) cylinder(h=straightLength,r=radius);

      // Pole Hole
      translate([poleDepth*2*radius-radius,straightLength/2,0]) 
        rotate([0,-90,headAngle])
          cylinder(h=radius*2, d1=poleDia, 
                   d2=poleDia+2*tan(poleTaper)*2*radius);
    };

    // Origin End
    translate([-bendRadius,0,0]) rotate([0,0,-bendAngle]) {
      partial_rotate_extrude(bendAngle, bendRadius, 10) circle(radius);
      translate([bendRadius,0,0]) sphere(radius);
    };

    // Other End
    translate([-bendRadius,straightLength,0]) rotate([180,0,bendAngle]) {
      partial_rotate_extrude(bendAngle, bendRadius, 10) circle(radius);
      translate([bendRadius,0,0]) sphere(radius);
    };
  };

  // Faces
  translate([-(bendRadius+radius),-(bendRadius+radius),face])
    cube([bendRadius+2*radius,
          2*(bendRadius+2*radius)+straightLength,
          radius-face]);
  translate([-(bendRadius+radius),-(bendRadius+radius),-radius])
    cube([bendRadius+2*radius,
          2*(bendRadius+2*radius)+straightLength,
          radius-face]);

  // Mounting Hole
  translate([0,straightLength/2-boltY,-radius])
    cylinder(h=2*radius, r=boltDia/2);

  // Nut Hole
  translate([0,straightLength/2-boltY,face-nutDepth/2]) {
    // The following pattern for a hexagon came from:
    // http://svn.clifford.at/openscad/trunk/libraries/shapes.scad
    for (r=[-60, 0, 60]) rotate([0,0,r]) 
      cube([nutWidth/1.75, nutWidth, nutDepth], true);
  };

  // Bolt Countersink
  translate([0,straightLength/2-boltY,-face]) {
    cylinder(h=boltHeadDia/2, r1=boltHeadDia/2, r2=0);
  };

  // Scales
  for(scales = [-50:5:straightLength]) {
    translate([radius,scales,-face]) {
      cylinder(h=2*radius, r=2);
    };
  };
};



