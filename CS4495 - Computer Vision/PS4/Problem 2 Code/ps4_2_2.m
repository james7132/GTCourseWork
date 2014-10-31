images = {imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/transA.jpg'),
          imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/transB.jpg'),
          imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/simA.jpg'),
          imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/simB.jpg')};
f = cell(4, 1);
d = cell(4, 1);
scale = 3;
for i = 1 : 4
    I = single(images{i});
    [I_x, I_y] = GaussianGradients(images{i}, 3, 1.5);
    H = Harris(I_x, I_y, 7, 0.04);
    [~, ~, x, y] = HarrisCorners(H, 4e8);
    [points, ~] = size(x);
    angle = diag(atan2(I_y(y, x), I_x(y, x)));
    fc = [x, y, scale * ones(points, 1), angle];
    [f{i}, d{i}] = vl_sift(I, 'frames', transpose(fc));
end
for i = 1 : 2 : 4
    figure, imshow([images{i}, images{i + 1}]);
    [size_r, size_c] = size(images{i});
    [~, count] = size(f{i + 1});
    f{i + 1}(1,:) = f{i + 1}(1,:) + size_c * ones(1, count);
    [matches, scores] = vl_ubcmatch(d{i}, d{i + 1});
    [~, match_count] = size(matches);
    hold on
    plottedDescriptors1 = vl_plotframe(f{i});
    plottedDescriptors2 = vl_plotframe(f{i + 1});
    X = [f{i}(1, matches(1, :)); f{i + 1}(1, matches(2,:))];
    Y = [f{i}(2, matches(1, :)); f{i + 1}(2, matches(2,:))];
    line(X, Y);
end