image = imread('ps1-input2.jpg');
gImage = rgb2gray(image);
gauss = fspecial('gaussian', [19, 19], 7);
smoothed = imfilter(gImage, gauss);
edgeSmoothed = edge(smoothed, 'canny', 0.3);
imshow(edgeSmoothed)
dA = 3;
dB = 3;
dR = 2;
[size_x, size_y] = size(gImage);
min_r = 18;
max_r = 30;
H = zeros(ceil(size_x / dA), ceil(size_y / dB), ceil((max_r - min_r) / dR));
[edge_x, edge_y] = find(edgeSmoothed);
for i = 1 : size(edge_x)
    x = edge_x(i);
    y = edge_y(i);
    i
    for r = min_r : dR : max_r
        for theta = 1 : 360
            a = x - r * cos(degtorad(theta));
            b = y + r * sin(degtorad(theta));
            if a > 0 && b > 0 && a <= size_x && b <= size_y
                bA = max(round(a / dA), 1);
                bB = max(round(b / dB), 1);
                bR = max(round((r - min_r) / dR), 1);
                H(bA, bB, bR) = H(bA, bB, bR) + 1;
            end
        end
    end
end
H_max = max(max(max(H)));
%imshow(, [0, H_max])
[max_a, max_b, max_r] = ind2sub(size(H), find( H > 0.75*  H_max));
maximums = [max_b * dB, max_a * dA];
radii = (max_r * dR) + min_r;
imshow(edgeSmoothed);
hold on
viscircles(maximums, radii);

%maximums = [max_a * dA, max_b * dB];
%radii = max_r - 1;
%viscircles(maximums, radii);