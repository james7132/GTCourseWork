function [ U, V ] = OpticFlow( im1, im2, blurSize, blurSigma, windowSize, windowSigma )
    [size_r, size_c] = size(im1);

    blurFilter = fspecial('gaussian', blurSize, blurSigma);
    sumFilter = fspecial('gaussian', windowSize, windowSigma);

    im1 = im2double(im1);
    im2 = im2double(im2);
    
    im1 = imfilter(im1, blurFilter);
    im2 = imfilter(im2, blurFilter);

    I_x = imfilter(im1, [-1 1]);
    I_y = imfilter(im1, [-1 1]');
    I_t  = im2 - im1;

    I_xx = imfilter(I_x .^ 2, sumFilter);
    I_yy = imfilter(I_y .^ 2, sumFilter);
    I_xy = imfilter(I_x .* I_y, sumFilter);
    I_xt = imfilter(I_x .* I_t, sumFilter);
    I_yt = imfilter(I_y .* I_t, sumFilter);
    
    U = 0 * im1;
    V = 0 * im2;
    for i = 1 : size_r
        for j = 1 : size_c
            A = [I_xx(i,j), I_xy(i,j); I_xy(i,j), I_yy(i,j)];
            B = [I_xt(i,j); I_yt(i,j)];
            
            if abs(det(A)) < 1e-20
                U(i, j) = 0;
                V(i, j) = 0;
            else
                x = A\B;
                U(i,j) = x(1);
                V(i,j) = x(2);
            end
        end
    end
end

