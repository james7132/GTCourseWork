function [ reduced ] = Reduce( image )
    reduceFilter = [1/16; 1/4; 3/8; 1/4; 1/16] * [1/16, 1/4, 3/8, 1/4, 1/16];
    current = im2double(image);
    current = imfilter(current, reduceFilter);
    [size_r, size_c] = size(current);
    if size_r > 2
        new = zeros(floor((size_r + 1)/ 2), size_c);
        new(1,:) = current(1,:);
        for i = 3 : 2 : size_r
            new((i + 1)/2, :) = current(i, :);
        end
        current = new;
    end
    [size_r, size_c] = size(current);
    if size_c > 2
        new = zeros(size_r, floor((size_c + 1)/ 2));
        new(:,1) = current(:,1);
        for i = 3 : 2 : size_c 
            new(:, (i + 1)/2) =  current(:, i);
        end
        current = new;
    end
    reduced = current;
end

