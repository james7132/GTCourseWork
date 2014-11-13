function [ pyramid ] = GaussianPyramid( im, height )
    pyramid = cell(1, height);
    pyramid{1} = im2double(im);
    if height >= 2
        for i = 2 : height
            pyramid{i} = Reduce(pyramid{i - 1});
        end
    end
end

