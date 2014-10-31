image = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS1/Data/ps1-input0.png');
edge_image = edge(image, 'sobel');
imshow(edge_image)
imwrite(edge_image, 'ps1-1-a-0.png');