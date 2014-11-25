function [ lPyramids, gPyramids ] = LaplacianSequence( ims )
    len = length(ims);
    lPyramids = {};
    gPyramids = {};
    for i = 1 : len
        [lP, gP] = LaplacianPyramid(ims{i});
        lPyramids = [lPyramids; lP];
        gPyramids = [gPyramids; gP];
    end
end

