function [dispMap] = SumOfSquareDifferences(im1, im2, W, dispMax)
    im1 = im2double(im1);
    im2 = im2double(im2);
    [size_r, size_c] = size(im1);
    dispMap=zeros(size_r, size_c);
    win = (W-1) / 2;
    im1 = padarray(im1, [win, win + dispMax], 'both');
    im2 = padarray(im2, [win, win + dispMax], 'both');
    for r = win + 1 : 1 : win + size_r 
        r
        for c = win + dispMax + 1 : 1 : win + dispMax + size_c
            prevSSD = 65532;
            best = 0;
            for dispRange = -dispMax : 1 : dispMax
                im1win = im1(r - win : r + win, c + dispRange - win : c + win + dispRange);
                im2win = im2(r - win : r + win, c - win : c + win);
                [ssd, temp] = sumsqr(im2win - im1win);
                if (prevSSD > ssd)
                    prevSSD = ssd;
                    best = dispRange;
                end
            end
            dispMap(r - win,c - win - dispMax) = best;
        end
    end
end