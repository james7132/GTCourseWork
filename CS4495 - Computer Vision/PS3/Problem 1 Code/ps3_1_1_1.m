Coord2d = dlmread('pts2d-norm-pic_a.txt');
Coord3d = dlmread('pts3d-norm.txt');
[size_r, ~] = size(Coord2d);
homogenous2d = transpose([Coord2d, ones(size_r, 1)]);
homogenous3d = transpose([Coord3d, ones(size_r, 1)]);
M = LeastSquares(Coord2d, Coord3d)
test2d = M * homogenous3d
residuals = zeros(1, size_r);
for i = 1 : size_r
    test2d(:,i) = test2d(:,i) / test2d(3,i);
    residuals(1,i) = sumsqr(test2d(:,i) - homogenous2d(:,i));
end
residuals