$fn=24*4;

poleDia = 19; // 19 is a hair big
handleStraightL = 140;
handleDep = 15;
stopperD1 = 24;
stopperD2 = 32;
stopperH = 24;

difference() {
  union() {
    cube([handleDep,handleStraightL,poleDia]);
    translate([handleDep,0,poleDia/2])
      rotate([-90,0,0]) cylinder(h=handleStraightL, d=poleDia);
    translate([handleDep,0,poleDia/2]) sphere(d=poleDia);
    translate([handleDep,handleStraightL,poleDia/2]) sphere(d=poleDia);
    translate([0,0,poleDia/2])
      rotate([0,90,0]) cylinder(h=handleDep, d=poleDia);
    translate([0,handleStraightL,poleDia/2])
      rotate([0,90,0]) cylinder(h=handleDep, d=poleDia);
  };
  translate([0,-handleStraightL/2,poleDia/2])
    rotate([-90,0,0]) cylinder(h=2*handleStraightL, d=poleDia);
  translate([0,-handleStraightL/2,0])
    cube([poleDia/4, 2*handleStraightL, poleDia]);
  translate([0,0,poleDia/2])
    rotate([90,0,0]) cylinder(h=stopperH, d1=stopperD1, d2=stopperD2);
};