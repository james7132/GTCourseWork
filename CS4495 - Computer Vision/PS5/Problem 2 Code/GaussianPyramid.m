function [ pyramid ] = GaussianPyramid( im )
    start = im2double(im);
    [sr, sc] = size(start);
    pyramid = {start};
    i = 2;
    while sr > 2 && sc > 2
        pyramid{i} = Reduce(pyramid{i - 1});
        [sr, sc] = size(pyramid{i});
        i = i + 1;
    end
end

