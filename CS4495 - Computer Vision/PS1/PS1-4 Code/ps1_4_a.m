image = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS1/Data/ps1-input0-noise.png');
dImage = im2double(image);
gauss = fspecial('gaussian', [11, 11], 4);
smoothed = imfilter(dImage, gauss);
imshow(smoothed);
imwrite(smoothed, 'ps1-4-a-1.png');