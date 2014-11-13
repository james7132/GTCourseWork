function [ warpI2 ] = Warp( im2, vx, vy)
    [M, N] = size(im2);
    [x, y] = meshgrid(1:N,1:M);
    warpI3 = interp2(x, y, im2, x + vx,y + vy, '*nearest'); % use Matlab interpolation routine
    warpI2 = interp2(x, y, im2, x + vx,y + vy, '*linear'); % use Matlab interpolation routine
    I = find(isnan(warpI2));
    warpI2(I) = warpI3(I);
    warpI2(isnan(warpI2)) = im2(isnan(warpI2));
end

