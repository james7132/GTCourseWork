function [ pyramids ] = GaussianSequence( ims )
    len = length(ims);
    pyramids = {};
    for i = 1 : len
        pyramids = [pyramids; GaussianPyramid(ims{i})];
    end
end

