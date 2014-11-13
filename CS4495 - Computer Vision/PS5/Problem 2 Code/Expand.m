function [ expanded ] = Expand( image )
    expandFilter = [1/8; 1/2; 3/4; 1/2; 1/8] * [1/8, 1/2, 3/4, 1/2, 1/8];
    current = im2double(image);
    [size_r, size_c] = size(current);
    if size_r > 1
        new = zeros(2 * size_r, size_c);
        new(1,:) = current(1,:);
        for i = 2 : size_r
            new(2 * i, :) = current(i, :);
        end
        current = new;
    end
    [size_r, size_c] = size(current);
    if size_c > 1
        new = zeros(size_r, 2 * size_c);
        new(:,1) = current(:,1);
        for i = 2 : size_c
            new(:, 2 * i) =  current(:, i);
        end
        current = new;
    end
    expanded = imfilter(current, expandFilter);
end

