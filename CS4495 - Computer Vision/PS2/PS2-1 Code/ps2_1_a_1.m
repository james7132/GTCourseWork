left = imread('http://www.cc.gatech.edu/%7Eafb/classes/CS4495-Fall2014/ProblemSets/PS2/Data/leftTest.png');
right = imread('http://www.cc.gatech.edu/%7Eafb/classes/CS4495-Fall2014/ProblemSets/PS2/Data/rightTest.png');
disparity_L = SumOfSquareDifferences(left, right, 9, 9);
disparity_R = SumOfSquareDifferences(right, left, 9, 9);
