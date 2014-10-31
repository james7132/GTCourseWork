coordsA = dlmread('pts2d-pic_a.txt');
coordsB = dlmread('pts2d-pic_b.txt');
imageA = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS3/pic_a.jpg');
imageB = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS3/pic_b.jpg');
F = DrawEpipolarLines(imageA, imageB, coordsA, coordsB)