image = imread('ps1-input3.jpg');
gImage = rgb2gray(image);
gauss = fspecial('gaussian', [11, 11], 3);
smoothed = imfilter(gImage, gauss);
edgeSmoothed = edge(smoothed, 'canny', 0.25);
imshow(edgeSmoothed)