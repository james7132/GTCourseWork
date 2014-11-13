base = imread('Shift0.png');
R2 = imread('Shiftr5U5.png');
[U5, V5] = OpticFlow(base, R2, 21, 4, 21, 8);
DrawOpticFlow(U5, V5);