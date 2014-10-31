coordsA = dlmread('pts2d-pic_a.txt');
coordsB = dlmread('pts2d-pic_b.txt');
F = LeastSquaresFundamental(coordsA, coordsB)
    [size_rA, ~] = size(coordsA);

for i = 1 : size_rA
    check = [coordsA(i,:), 1] * F * [transpose(coordsB(i,:)); 1]
end