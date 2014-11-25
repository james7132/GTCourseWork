function [ expanded ] = Expand( image, r, c)
    expandFilter = [1/8; 1/2; 3/4; 1/2; 1/8] * [1/8, 1/2, 3/4, 1/2, 1/8];
    current = im2double(image);
    [size_r, size_c] = size(current);
    expanded = zeros(2 * size_r, 2 * size_c);
    expanded(1 : 2 : 2 * size_r, 1 : 2 : 2 * size_c) = current;
    expanded = imfilter(expanded, expandFilter);
    if nargin > 1
        expanded = expanded(1 : r, 1 : c);
    end
end

