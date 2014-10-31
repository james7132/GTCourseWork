GImage = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/transA.jpg');
FilterSize = 3;
Sigma = 1;
w = (FilterSize - 1) / 2;
GaussianFilter = fspecial('gaussian', FilterSize, Sigma);
FilteredImage = imfilter(GImage, GaussianFilter);
[gradX, gradY] = imgradientxy(FilteredImage);
image = [gradX, gradY];
dImage = im2double(image);
dif = max(abs(min(min(dImage))), abs(max(max(dImage))));
figure, imshow(image, [-dif, dif]);
GImage = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/simA.jpg');
FilteredImage = imfilter(GImage, GaussianFilter);
[gradX, gradY] = imgradientxy(FilteredImage);
image = [gradX, gradY];
dImage = im2double(image);
dif = max(abs(min(min(dImage))), abs(max(max(dImage))));
figure, imshow(image, [-dif, dif]);

