function [ I_x, I_y ] = GaussianGradients( GImage, FilterSize, Sigma )
    GaussianFilter = fspecial('gaussian', FilterSize, Sigma);
    FilteredImage = imfilter(GImage, GaussianFilter);
    [I_x, I_y] = imgradientxy(FilteredImage);
end

