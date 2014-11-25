function [ lapPyramid, gaussPyramid ] = LaplacianPyramid( im )
    gaussPyramid = GaussianPyramid(im);
    [~, height] = size(gaussPyramid);
    lapPyramid = cell(1, height - 1);
    for i = 1 : height - 1
        g1 = gaussPyramid{i};
        [sr, sc] = size(g1);
        lapPyramid{i} = g1 -  Expand(gaussPyramid{i + 1}, sr, sc);
    end
end

