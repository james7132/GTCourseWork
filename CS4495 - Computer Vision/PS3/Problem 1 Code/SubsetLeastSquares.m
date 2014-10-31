function [ BestM, BestResidual, Residuals ] = SubsetLeastSquares( Coords2d, Coords3d, SubsetSize, TestSize, Iterations )
    [size_r2, size_c2] = size(Coords2d);
    [size_r3, size_c3] = size(Coords3d);
    
    if size_c2 ~= 2
        throw(MException('Size Error', 'Need a set of 2D coordinates'));
    end
    if size_c3 ~= 3
        throw(MException('Size Error', 'Need a set of 3D coordinates'));
    end
    if size_r2 ~= size_r3
        throw(MException('Size Error', 'Size of 2D and 3D coordinate sets needs to be the same'));
    end
    
    BestResidual = inf;
    Residuals = zeros(1, Iterations);
    
    for i = 1 : Iterations
        subsetInd = randperm(size_r2, SubsetSize);
        subsetOut = ~ismember(1 : size_r2, subsetInd);
        testInd = randperm(size_r2 - SubsetSize, TestSize);
        subset2d = Coords2d(subsetInd, :);
        subset3d = Coords3d(subsetInd, :);
        subset2dOut = Coords2d(subsetOut, :);
        subset3dOut = Coords3d(subsetOut, :);
        test2d = subset2dOut(testInd, :);
        test3d = subset3dOut(testInd, :);
        M = LeastSquares(subset2d, subset3d);
        homogenousTest2d = transpose([test2d, ones(TestSize, 1)]);
        homogenousTest3d = transpose([test3d, ones(TestSize, 1)]);
        testProjections = M * homogenousTest3d;
        residualSum = 0;
        for j = 1 : TestSize
            testProjections(:,j) = testProjections(:,j) / testProjections(3, j);
            residualSum = residualSum + sumsqr(testProjections(:,j) - homogenousTest2d(:,j));
        end
        Residuals(1, i) = residualSum / TestSize;
        if Residuals(1, i) < BestResidual
            BestResidual = Residuals(1, i);
            BestM = M;
        end
    end
end

