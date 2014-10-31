image = imread('ps1-input3.jpg');
gImage = rgb2gray(image);
gauss = fspecial('gaussian', [9, 9], 4);
smoothed = imfilter(gImage, gauss);
edgeSmoothed = edge(smoothed, 'canny', 0.95);
dD = 3;
dTheta = 1;
[size_x, size_y] = size(gImage);
d_max = size_x + size_y;
H = zeros((2 * d_max) / dD, 180 / dTheta);
[edge_x, edge_y] = find(edgeSmoothed);
for i = 1 : size(edge_x)
    x = edge_x(i);
    y = edge_y(i);
    for theta = 1 : dTheta : 180
        d = round((x * cos(degtorad(theta))) - (y * sin(degtorad(theta)))) + d_max;
        bD = round(d / dD);
        bTheta = round(theta/dTheta);
        H(bD, bTheta) = H(bD, bTheta) + 1;
    end
end
H_max = max(max(H));
imshow(H, [0, H_max])
[max_d, max_theta] = find(H > 0.6 * H_max);
maximums = [max_theta, max_d];
radii = max_d(:);
radii(:) = 2;
viscircles(maximums, radii);
imshow(smoothed)
hold on
for i = 1 : size(max_d)
    d = max_d(i) * dD - d_max;
    theta = max_theta(i) * dTheta;
    x = d * cos(degtorad(theta+90));
    y = d * sin(degtorad(theta+90));
    if (theta ~= 90) && (theta ~= 270)
        m = tan(degtorad(theta))
        b = y - m * x
        xx = 1 : size_y;
        yy = m * xx + b;
        plot(xx,yy);
    else
        xx = x * ones(size_y);
        yy = 1 : size_y;
        plot(xx,yy);
    end
end