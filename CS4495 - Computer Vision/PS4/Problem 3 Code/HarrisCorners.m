function [ ThresholdImage, CornerImage, PointsX, PointsY] = HarrisCorners( HarrisImage, Threshold )
    thresholded = HarrisImage > Threshold;
    ThresholdImage = HarrisImage;
    ThresholdImage(~thresholded) = 0;
    CornerImage = imregionalmax(ThresholdImage);
    [PointsY, PointsX] = find(CornerImage);
end