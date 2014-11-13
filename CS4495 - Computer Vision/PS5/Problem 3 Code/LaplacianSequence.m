function [ lPyramids, gPyramids ] = LaplacianSequence( ims, height )
    len = length(ims);
    lPyramids = {};
    gPyramids = {};
    for i = 1 : len
        [lP, gP] = LaplacianPyramid(ims{i}, height);
        lPyramids = [lPyramids; lP];
        gPyramids = [gPyramids; gP];
    end
end

