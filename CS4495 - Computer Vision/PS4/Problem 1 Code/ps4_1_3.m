images = {imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/transA.jpg'),
          imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/transB.jpg'),
          imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/simA.jpg'),
          imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/simB.jpg')};
for i = 1 : 4
    [I_x, I_y] = GaussianGradients(images{i}, 3, 1);
    H = Harris(I_x, I_y, 7, 0.04);
    [~, ~, x, y] = HarrisCorners(H, 4e8);
    figure, imshow(images{i});
    hold on
    plot(x, y, '+')
end