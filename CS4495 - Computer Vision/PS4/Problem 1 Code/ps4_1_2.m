image1 = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/transA.jpg');
image2 = imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/simA.jpg');
images = {image1, image2};
for i = 1 : 2
    [I_x, I_y] = GaussianGradients(images{1, i}, 3, 1);
    H = Harris(I_x, I_y, 7, 0.04);
    dif = max(abs(min(min(H))), abs(max(max(H))));
    figure, imshow(H, [-dif, dif]);
end