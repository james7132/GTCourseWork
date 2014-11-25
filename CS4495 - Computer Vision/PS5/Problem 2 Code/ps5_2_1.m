f1 = imread('yos_img_01.jpg');
height = 3;
pyramid = GaussianPyramid(f1);
for i = 1 : height + 1
    figure, imshow(pyramid{i})
    imwrite(pyramid{i}, strcat('PS5-2-1-', num2str(i), '.png'));
end