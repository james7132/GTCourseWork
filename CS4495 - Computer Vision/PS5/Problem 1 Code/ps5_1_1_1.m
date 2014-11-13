base = imread('Shift0.png');
R2 = imread('Shiftr2.png');
[U2, V2] = OpticFlow(base, R2, 21, 4, 21, 8);
DrawOpticFlow(U2, V2);