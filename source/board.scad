$fieldWidth=25;
$fieldHeight=1.4;
$borderWidth=2;
$borderHeight=2.6;
$edgeWidth=1.5;
$markDepth=0.6;

module board() {
translate([-($borderWidth*16+$fieldWidth*15+$edgeWidth*2)/2, ($borderWidth*16+$fieldWidth*15+$edgeWidth*2)/2, 0]) {
difference() {
union() {
translate([0, -($borderWidth*16+$fieldWidth*15+$edgeWidth*2), 0]) cube([$borderWidth*16+$fieldWidth*15+$edgeWidth*2, $borderWidth*16+$fieldWidth*15+$edgeWidth*2, $fieldHeight]);
for( i = [0:15-1]) {
for( j = [0:15-1]) {
x=$edgeWidth+i*($fieldWidth+$borderWidth);
y=-($edgeWidth+j*($fieldWidth+$borderWidth))-$fieldWidth-$borderWidth*2;
translate([x,y,$fieldHeight]) {
difference() {
cube([$fieldWidth+$borderWidth*2, $fieldWidth+$borderWidth*2, $borderHeight]);
translate([$borderWidth, $borderWidth, 0])
cube([$fieldWidth, $fieldWidth, $borderHeight]);
}
}
}
}
}

tw = [[0,0], [0,7], [0,14], [7,0], [7,14], [14,0], [14,7], [14,14]];
tl = [[0,3], [0,11], [2,6], [2,8], [3,0], [3,7], [3,14], [6,2], [6,6], [6,8], [6,12], [7,3], [7,11], [8,2], [8,6], [8,8], [8,12], [11,0], [11,7], [11,14], [12,6], [12,8], [14,3], [14,11]];
dw = [[1,1], [1,13], [2,2], [2,12], [3,3], [3,11], [4,4], [4,10], [7,7], [10,4], [10,10], [11,3], [11,11], [12,2], [12,12], [13,1], [13,13]];
dl = [[1,5], [1,9], [5,1], [5,5], [5,9], [5,13], [9,1], [9,5], [9,9], [9,13], [13,5], [13,9]];

for( i = [0:15-1]) {
for( j = [0:15-1]) {
x=$edgeWidth+i*($fieldWidth+$borderWidth)+$borderWidth+$fieldWidth/2;
y=-($edgeWidth+j*($fieldWidth+$borderWidth)+$borderWidth+$fieldWidth/2);
translate([x,y,$fieldHeight-$markDepth/2]) {

istw = search([[i,j]], tw)!=[[]];
if(istw)
cylinder(h=$markDepth, d=$fieldWidth*0.8, center=true);
isdw = search([[i,j]], dw)!=[[]];
if(isdw)
cylinder(h=$markDepth, d=$fieldWidth*0.4, center=true);

istl = search([[i,j]], tl)!=[[]];
if(istl)
cube([$fieldWidth*0.6, $fieldWidth*0.6, $markDepth], center=true);
isdl = search([[i,j]], dl)!=[[]];
if(isdl)
cube([$fieldWidth*0.4, $fieldWidth*0.4, $markDepth], center=true);


}
}
}

}
}
}

module hook_up() {
translate([-2.5, 0, 0])
cube([8, $fieldWidth/4, $fieldHeight]);
translate([0, $fieldWidth/4, 0])
cylinder(d=$fieldWidth/2, h=$fieldHeight);
}

module hook_down() {
translate([-2.5, -$fieldWidth/4, 0])
cube([8, $fieldWidth/4, $fieldHeight]);
translate([0, -$fieldWidth/4, 0])
cylinder(d=$fieldWidth/2, h=$fieldHeight);
}

module hook_right() {
translate([0, -2.5, 0])
cube([$fieldWidth/4, 8, $fieldHeight]);
translate([$fieldWidth/4, 0, 0])
cylinder(d=$fieldWidth/2, h=$fieldHeight);
}

module hook_left() {
translate([-$fieldWidth/4, -2.5, 0])
cube([$fieldWidth/4, 8, $fieldHeight]);
translate([-$fieldWidth/4, 0, 0])
cylinder(d=$fieldWidth/2, h=$fieldHeight);
}

module partBoard() {
l=$borderWidth*16+$fieldWidth*15+$edgeWidth*2;
h=$fieldHeight+$borderHeight;
p1=$fieldWidth+$borderWidth;
p2=l/2-$edgeWidth-$fieldWidth*1.5-$borderWidth*2;
difference() {
board();

translate([-l/2, 0, 0]) cube([l/2, l/2, h]);
translate([-l/2, -l/2, 0]) cube([l/2, l/2, h]);
translate([0, -l/2, 0]) cube([l/2, l/2, h]);

translate([p1, 0, 0]) hook_up();
translate([p2, 0, 0]) hook_up();
}

translate([0, p1, 0]) hook_left();
translate([0, p2, 0]) hook_left();
}

partBoard();