function [ F ] = LeastSquaresFundamental( CoordsA, CoordsB )
    [size_rA, size_cA] = size(CoordsA);
    [size_rB, size_cB] = size(CoordsB);
    if size_cA ~= 2 || size_cB ~= 2
        throw(MException('Size Error', 'Need a set of 2D coordinates'));
    end
    if size_rA ~= size_rB
        throw(MException('Size Error', 'Size of 2D and 3D coordinate sets needs to be the same'));
    end
    x = CoordsA(:,1);
    y = CoordsA(:,2);
    u = CoordsB(:,1);
    v = CoordsB(:,2);
    A = zeros(size_rA, 8);
    B = -ones(size_rA, 1);
    for i = 1 : size_rA
        A(i, :) = [x(i) * u(i), x(i) * v(i), x(i), y(i) * u(i), y(i) * v(i), y(i), u(i), v(i)];
    end
    x = transpose([A\B; 1]);
    F = [x(1:3); x(4:6); x(7:9)];
end