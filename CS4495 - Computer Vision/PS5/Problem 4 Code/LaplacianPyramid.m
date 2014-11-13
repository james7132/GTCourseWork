function [ lapPyramid, gaussPyramid ] = LaplacianPyramid( im, height )
    gaussPyramid = GaussianPyramid(im, height + 1);
    lapPyramid = cell(1, height);
    if height + 1 >= 2
        for i = 1 : height
            g1 = gaussPyramid{i};
            [sr, sc] = size(g1);
            lapPyramid{i} = g1 -  Expand(gaussPyramid{i + 1}, sr, sc);
        end
    end
end

