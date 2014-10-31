Coord2d = dlmread('pts2d-pic_b.txt');
Coord3d = dlmread('pts3d.txt');
BestM = zeros(4, 3);
BestResidual = inf;
Residuals = zeros(3,10);
for i = 8 : 4 : 16
    i
    [M, Residual , temp] = SubsetLeastSquares(Coord2d, Coord3d, i, 4, 10);
    Residuals(i / 4 - 1, :) = temp
    if Residual < BestResidual
        BestResidual = Residual;
        BestM = M;
    end
end
Residuals
BestResidual
BestM
C = ComputeCameraCenter(BestM)