base = imread('Shift0.png');
R2 = imread('Shiftr10.png');
[U10, V10] = OpticFlow(base, R2, 21, 4, 21, 8);
DrawOpticFlow(U10, V10);