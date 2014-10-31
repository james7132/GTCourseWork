left = imread('http://www.cc.gatech.edu/%7Eafb/classes/CS4495-Fall2014/ProblemSets/PS2/Data/proj2-pair1-L.png');
right = imread('http://www.cc.gatech.edu/%7Eafb/classes/CS4495-Fall2014/ProblemSets/PS2/Data/proj2-pair1-R.png');
gLeft = rgb2gray(left);
gRight = rgb2gray(right);
gLeft = gLeft * 1.1
imwrite(gLeft, 'left-contrast.png');
disparity_L = SumOfSquareDifferences(gLeft, gRight, 15, 70);
disparity_R = SumOfSquareDifferences(gRight, gLeft, 15, 70);