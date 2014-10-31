function [ F ] = DrawEpipolarLines( ImageA, ImageB, CoordsA, CoordsB)
    [size_rA, ~] = size(CoordsA);
    [size_rB, ~] = size(CoordsB);
    [hA, wA] = size(rgb2gray(ImageA));
    [hB, wB] = size(rgb2gray(ImageB));
    F = SVDFundamental(CoordsA, CoordsB);
    homogenousCoordsA = transpose([CoordsA, ones(size_rA, 1)]);
    homogenousCoordsB = transpose([CoordsB, ones(size_rB, 1)]);
    L_lA = cross([0, 0, 1], [0, hA, 1]);
    L_lB = cross([0, 0, 1], [0, hB, 1]);
    L_rA = cross([wA, 0, 1], [wA, hA, 1]);
    L_rB = cross([wB, 0, 1], [wB, hB, 1]);
    L = transpose(F) * homogenousCoordsA;
    figure, imshow(ImageB);
    for i = 1 : size_rA
        pointL = cross(L(:,i), L_lB);
        pointR = cross(L(:,i), L_rB);
        pointL = pointL / pointL(3);
        pointR = pointR / pointR(3);
        line([pointL(1), pointR(1)], [pointL(2), pointR(2)]);
    end
    L = F * homogenousCoordsB;
    figure, imshow(ImageA);
    for i = 1 : size_rA
        pointL = cross(L(:, i), L_lA);
        pointR = cross(L(:, i), L_rA);
        pointL = pointL / pointL(3);
        pointR = pointR / pointR(3);
        line([pointL(1), pointR(1)], [pointL(2), pointR(2)]);
    end
end

