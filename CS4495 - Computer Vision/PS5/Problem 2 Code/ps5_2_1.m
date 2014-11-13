f1 = imread('yos_img_01.jpg');
height = 3;
pyramid = GaussianPyramid(f1, height);
for i = 1 : height + 1
    figure, imshow(pyramid{i})
    imwrite(pyramid{i}, strcat('g', num2str(i - 1), '-f1.png'));
end