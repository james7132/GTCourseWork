function [ pyramid ] = GaussianPyramid( im, height )
    pyramid = cell(height + 1, 1);
    pyramid{1} = im2double(im);
    if height + 1 >= 2
        for i = 2 : height + 1
            pyramid{i} = Reduce(pyramid{i - 1});
        end
    end
end

