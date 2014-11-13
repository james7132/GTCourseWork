function [ pyramid, gaussPyramid ] = LaplacianPyramid( im, height )
    gaussPyramid = GaussianPyramid(im, height + 1);
    pyramid = cell(height + 1, 1);
    if height + 1 >= 2
        for i = 1 : height + 1
            g1 = gaussPyramid{i};
            g2 = Expand(gaussPyramid{i + 1});
            [sr, sc] = size(g1);
            pyramid{i} = g1 - g2(1:sr, 1:sc);
        end
    end
end

