function [ ] = DrawOpticFlow( U, V )
    [size_r, size_c] = size(U);
    [X, Y] = meshgrid(1 : size_c, 1 : size_r);
    quiver(X, Y, U, V)
end

