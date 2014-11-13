function [ pyramids ] = GaussianSequence( ims, height )
    len = length(ims);
    pyramids = cell(len, height + 1);
    for i = 1 : len
        pyramids{i, :} = GaussianPyramids(ims{i}, height);
    end
end

