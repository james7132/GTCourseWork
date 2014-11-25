function [ reduced ] = Reduce( image )
    reduceFilter = [1/16; 1/4; 3/8; 1/4; 1/16] * [1/16, 1/4, 3/8, 1/4, 1/16];
    current = im2double(image);
    current = imfilter(current, reduceFilter);
    [size_r, size_c] = size(current);
    reduced = current(1 : 2 : size_r, 1 : 2 : size_c);
end

