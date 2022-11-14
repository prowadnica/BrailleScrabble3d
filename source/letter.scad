$fa = 0.01; $fs = 0.1; 

// Braille modules based on https://github.com/KitWallace/openscad/blob/master/braille.scad , but significantly modified

$dotHeight = 0.5;
$dotBase = 2.0;
$dotRadius = $dotBase /2;
$dotWidth= 3.25;
$charWidth = 7.5;
$lineHeight = 12.5;
$blackHeight = 0.5;

function join(strings, delimeter="") = 
	strings == undef?
		undef
	: strings == []?
		""
	: _join(strings, len(strings)-1, delimeter);
function _join(strings, index, delimeter) = 
	index==0 ? 
		strings[index] 
	: str(_join(strings, index-1, delimeter), delimeter, strings[index]) ;

function max_length_r(v, i, max) =
     i == len(v) ? max : max_length_r(v, i+1, len(v[i]) > max ? len(v[i]) : max);

function max_length(v) = max_length_r(v,0,0);

$charKeys = ["a", "A", "b", "B", "c", "C", "d", "D", "e", "E", "f", "F", "g", "G", "h", "H", "i", "I", "j", "J", "k", "K", "l", "L", "m", "M", "n", "N", "o", "O", "p", "P", "q", "Q", "r", "R", "s", "S", "t", "T", "u", "U", "v", "V", "w", "W", "x", "X", "y", "Y", "z", "Z", ",", ";", ":", ".", "!", "(", ")", "?", "\"", "*", "'", "-", "#", "1", "2","3","4","5","6","7","8","9","0","_", "^", "ą", "Ą", "ć", "Ć", "ę", "Ę", "ł", "Ł", "ń", "Ń", "ó", "Ó", "ś", "Ś", "ź", "Ź", "ż", "Ż"];

$charValues = [[1], [1], [1, 2], [1, 2], [1, 4], [1, 4], [1, 4, 5], [1, 4, 5], [1, 5], [1, 5], [1, 2, 4], [1, 2, 4], [1, 2, 4, 5], [1, 2, 4, 5], [1, 2, 5], [1, 2, 5], [2, 4], [2, 4], [2, 4, 5], [2, 4, 5], [1, 3], [1, 3], [1, 2, 3], [1, 2, 3], [1, 3, 4], [1, 3, 4], [1, 3, 4, 5], [1, 3, 4, 5], [1, 3, 5], [1, 3, 5], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 5], [1, 2, 3, 5], [2, 3, 4], [2, 3, 4], [2, 3, 4, 5], [2, 3, 4, 5], [1, 3, 6], [1, 3, 6], [1, 2, 3, 6], [1, 2, 3, 6], [2, 4, 5, 6], [2, 4, 5, 6], [1, 3, 4, 6], [1, 3, 4, 6], [1, 3, 4, 5, 6], [1, 3, 4, 5, 6], [1, 3, 5, 6], [1, 3, 5, 6], [2], [2, 3], [2, 5], [3], [2, 3, 5], [2, 3, 5, 6], [2, 3, 5, 6], [2, 3, 6], [2, 3, 6], [3, 5], [3], [3, 6], [3,4,5,6], [1], [1, 2], [1, 4], [1, 4, 5], [1, 5], [1, 2, 4], [1, 2, 4, 5], [1, 2, 5], [2, 4], [2, 4, 5], [4, 6], [4, 6], [1, 6], [1, 6], [1, 4, 6], [1, 4, 6], [1, 5, 6], [1, 5, 6], [1, 2, 6], [1, 2, 6], [1, 4, 5, 6], [1, 4, 5, 6], [3, 4, 6], [3, 4, 6], [2, 4, 6], [2, 4, 6], [2, 3, 4, 6], [2, 3, 4, 6], [1, 2, 3, 4, 6], [1, 2, 3, 4, 6]
];

module drawDot(location) {
    translate(location)
scale([1, 1, ($dotHeight*2)/$dotBase])
difference() {
sphere(d=$dotBase);
translate([0, 0, -$dotBase/4])
cylinder(h=$dotBase/2, d=$dotBase, center=true);
}
}

module drawCharacter(charMap) {
     for(i = [0: len(charMap)-1]) {
         dot = charMap[i] - 1;
         drawDot(   [floor(dot / 3) * $dotWidth,  -((1+(dot % 3)) * $dotWidth),   0] );
     }
}


module drawLine(line) {
    for(i = [0: len(line)-1]) { 
        translate([$charWidth*i, 0, 0]) {
            for(j = [0:len($charKeys)]) {
                if($charKeys[j] == line[i]) {
                    drawCharacter($charValues[j]);
                }
            }
        }
    }      
}

$type=0;

module mk(letter, points) {
if($type==0 || $type==1) {
translate([0.5, 0.5, 0])
cube([24.5, 24.5, 3]);
translate([0, 0, 3])
cube([25.5, 25.5, 1]);
}

if($type==0 || $type==2) {
translate([1.25+$charWidth/2, 25.5, 4]) {
br=join([letter, "#", points]);
if(letter!="") drawLine(br);
}
}

if($type==0 || $type==3) {
lh=["ą","ć","ę","ł","ń","ó","ś","ź","ż","Ą","Ć","Ę","Ł","Ń","Ó","Ś","Ź","Ż"];
islh = search([letter], lh)!=[[]];
lheight=(islh)?($lineHeight*0.7):($lineHeight*0.8);
translate([25.5/2, 0.5, 4])
linear_extrude(height = $blackHeight)
text(join([letter,points]), size=lheight, valign="bottom", font="Arial:style=Regular", halign="center");
}
}