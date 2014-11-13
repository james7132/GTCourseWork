base = imread('Shift0.png');
R2 = imread('Shiftr40.png');
[U40, V40] = OpticFlow(base, R2, 21, 4, 21, 8);
DrawOpticFlow(U40, V40);