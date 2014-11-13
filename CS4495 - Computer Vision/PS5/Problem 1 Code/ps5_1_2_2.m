base = imread('Shift0.png');
R2 = imread('Shiftr20.png');
[U20, V20] = OpticFlow(base, R2, 21, 4, 21, 8);
DrawOpticFlow(U20, V20);