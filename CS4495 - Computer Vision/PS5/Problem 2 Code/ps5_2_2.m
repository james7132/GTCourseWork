f1 = imread('yos_img_01.jpg');
height = 2;
[lPyramid, gPyramid] = LaplacianPyramid(f1, height);
figure, imshow(gPyramid{1})
for i = 1 : height + 1
    figure, imshow(lPyramid{i})
    imwrite(lPyramid{i}, strcat('g', num2str(i - 1), '-f1.png'));
end