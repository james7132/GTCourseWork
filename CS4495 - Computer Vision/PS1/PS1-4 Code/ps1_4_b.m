image = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS1/Data/ps1-input0-noise.png');
dImage = im2double(image);
gauss = fspecial('gaussian', [3, 3], 1);
smoothed = imfilter(dImage, gauss);
edgeRaw = edge(image, 'canny');
edgeSmoothed = edge(smoothed, 'canny', 0.55, 0.5);
imshow(edgeSmoothed);
imwrite(edgeRaw, 'ps1-4-b-1.png');
imwrite(edgeSmoothed, 'ps1-4-b-2.png');