images = {imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/simA.jpg'),
          imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/simB.jpg')};
f = cell(4, 1);
d = cell(4, 1);
scale = 3;
agreeingThreshold = 5;
RANSAC_Iterations = 1000;
for i = 1 : 2
    I = single(images{i});
    [I_x, I_y] = GaussianGradients(images{i}, 3, 1.5);
    H = Harris(I_x, I_y, 7, 0.04);
    [~, ~, x, y] = HarrisCorners(H, 4e8);
    [points, ~] = size(x);
    angle = diag(atan2(I_y(y, x), I_x(y, x)));
    fc = [x, y, scale * ones(points, 1), angle];
    [f{i}, d{i}] = vl_sift(I, 'frames', transpose(fc));
end
for i = 1 : 2 : 2
    [matches, scores] = vl_ubcmatch(d{i}, d{i + 1});
    [~, match_count] = size(matches);
    X = [f{i}(1, matches(1, :)); f{i + 1}(1, matches(2,:))];
    Y = [f{i}(2, matches(1, :)); f{i + 1}(2, matches(2,:))];
    bestMatchSet = zeros([2, 0]);
    bestMatchSetSize = 0;
    for j = 1 : RANSAC_Iterations
        randomMatches = randperm(match_count, 2);
        u = X(1, randomMatches);
        v = Y(1, randomMatches);
        x = X(2, randomMatches);
        y = Y(2, randomMatches);
        B = [x(1); y(1); x(2); y(2)];
        A = [u(1), -v(1), 1, 0;
             v(1),  u(1), 0, 1;
             u(2), -v(2), 1, 0;
             v(2),  u(2), 0, 1;];
        sim = A\B;
        similarity = [sim(1), -sim(2), sim(3);
                      sim(2),  sim(1), sim(4)];
        error = zeros(1, match_count);
        for k = 1 : match_count
            match = matches(:, k);
            initial = [f{i}(1:2, match(1)); 1];
            final = f{i + 1}(1:2, match(2));
            error(k) = sumsqr(final - similarity * initial);
        end
        agreeingMatches = error < agreeingThreshold;
        if(sum(agreeingMatches) > bestMatchSetSize)
            bestMatchSet = agreeingMatches;
            bestMatchSetSize = sum(agreeingMatches);
            bestSimilarity = similarity;
        end
    end
    matches = matches(:, bestMatchSet);
    bestSimilarity
    bestMatchSetSize
    figure, imshow([images{i}, images{i + 1}]);
    hold on
    [~, size_c] = size(images{i});
    [~, count] = size(f{i + 1});
    f{i + 1}(1,:) = f{i + 1}(1,:) + size_c * ones(1, count);
    plottedDescriptors1 = vl_plotframe(f{i});
    plottedDescriptors2 = vl_plotframe(f{i + 1});
    X = [f{i}(1, matches(1, :)); f{i + 1}(1, matches(2,:))];
    Y = [f{i}(2, matches(1, :)); f{i + 1}(2, matches(2,:))];
    xMaxMin = [min(X(1, :)), max(X(1, :))];
    yMaxMin = [min(Y(1, :)), max(Y(1, :))];
    rectangleStart = [xMaxMin(1), xMaxMin(1), xMaxMin(2), xMaxMin(2), xMaxMin(1);
                      yMaxMin(1), yMaxMin(2), yMaxMin(2), yMaxMin(1), yMaxMin(1);
                      ones(1, 5)];
    transformedRectangle = bestSimilarity * rectangleStart;
    for j = 1 : 5
        transformedRectangle(1, j) = transformedRectangle(1, j) + size_c;
    end
    line(X, Y);
    line(rectangleStart(1, :), rectangleStart(2, :),...
         'LineWidth', 4,...
         'Color', 'y');
    line(transformedRectangle(1, :), transformedRectangle(2, :),...
         'LineWidth', 4,...
         'Color', 'y');
end