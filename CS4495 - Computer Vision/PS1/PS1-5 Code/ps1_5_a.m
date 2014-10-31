image = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS1/Data/ps1-input1.jpg');
gImage = rgb2gray(image)
gauss = fspecial('gaussian', [5, 5], 3);
smoothed = imfilter(gImage, gauss);
imshow(smoothed);
imwrite(smoothed, 'ps1-5-a-2.png');