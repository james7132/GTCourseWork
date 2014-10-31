images = {imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/transA.jpg'),
          imread('http://www.cc.gatech.edu/~afb/classes/CS4495-Fall2014/ProblemSets/PS4/transB.jpg')};
f = cell(4, 1);
d = cell(4, 1);
scale = 3;
agreeingThreshold = 15;
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
    translations = [X(2, :) - X(1, :); Y(2, :) - Y(1, :)];
    bestMatchSet = zeros([2, 0]);
    bestMatchSetSize = 0;
    bestAcceptedSetError = inf;
    for j = 1 : RANSAC_Iterations
        randomMatch = translations(:, randi(match_count));
        error = zeros(1, match_count);
        for k = 1 : match_count
            error(k) = sqrt((randomMatch(1, 1) - translations(1, k))^2 + (randomMatch(2, 1) - translations(2, k))^2);
        end
        agreeingMatches = error < agreeingThreshold;
        if(sum(agreeingMatches) > bestMatchSetSize)
            bestMatchSet = agreeingMatches;
            bestMatchSetSize = sum(agreeingMatches);
        end
    end
    matches = matches(:, bestMatchSet);
    x = f{i}(1, matches(1, :));
    u = f{i + 1}(1, matches(2,:));
    y = f{i}(2, matches(1, :));
    v = f{i + 1}(2, matches(2,:));
    bestTranslation = [mean(u - x); mean(v - y)]
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
    transformedRectangle = rectangleStart;
    for j = 1 : 5
        transformedRectangle(1:2, j) = transformedRectangle(1:2, j) + bestTranslation + [size_c; 0];
    end
    line(X, Y);
    line(rectangleStart(1, :), rectangleStart(2, :),...
         'LineWidth', 4,...
         'Color', 'y');
    line(transformedRectangle(1, :), transformedRectangle(2, :),...
         'LineWidth', 4,...
         'Color', 'y');
end