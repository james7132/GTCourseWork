function [dispMap] = NormalCorrelation(im1, im2, W)
    im1 = im2double(im1);
    im2 = im2double(im2);
    [size_r, size_c] = size(im1);
    dispMap=zeros(size_r, size_c);
    win = (W-1) / 2;
    im1 = padarray(im1, [win, win], 'both');
    im2 = padarray(im2, [win, win], 'both');
    for r = win + 1 : 1 : win + size_r 
        r
        im2row = im2(r - win : r + win, :);
        for c = win + 1 : 1 : win + size_c
            im1temp = im1(r - win : r + win, c - win : c + win);
            normCorrMat = normxcorr2(im1temp, im2row);
            [~, row] = max(normCorrMat(round(end/2), :));
            dispMap(r - win,c - win) = c - row;
        end
    end
end

