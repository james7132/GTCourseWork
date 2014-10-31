function [ M ] = LeastSquares( Coords2d, Coords3d )
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
    u = Coords2d(:,1);
    v = Coords2d(:,2);
    X = Coords3d(:,1);
    Y = Coords3d(:,2);
    Z = Coords3d(:,3);
    A = zeros(2 * size_r2, 11);
    B = zeros(2 * size_r2, 1);
    for i = 1 : size_r2
        A(2 * i - 1,:)= [X(i), Y(i), Z(i), 1, 0, 0, 0, 0, -u(i)*X(i), -u(i)*Y(i), -u(i)*Z(i)];
        A(2 * i,:) =    [0, 0, 0, 0, X(i), Y(i), Z(i), 1, -v(i)*X(i), -v(i)*Y(i), -v(i)*Z(i)];
        B(2 * i - 1,1)= u(i);
        B(2 * i,1) =    v(i);
    end
    X = transpose([A\B; 1]);
    M = [X(1:4); X(5:8); X(9:12)];
    M = -M / sqrt(sumsqr(M));
end

