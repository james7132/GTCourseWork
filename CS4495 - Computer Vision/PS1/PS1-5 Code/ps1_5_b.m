image = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS1/Data/ps1-input1.jpg');
gImage = rgb2gray(image)
gauss = fspecial('gaussian', [9, 9], 4);
smoothed = imfilter(gImage, gauss);
imshow(smoothed);
imwrite(smoothed, 'ps1-5-a-1.png');
edgeSmoothed = edge(smoothed, 'canny', 0.95);
imshow(edgeSmoothed);
imwrite(edgeSmoothed, 'ps1-5-b-1.png');