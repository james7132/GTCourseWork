f1 = imread('yos_img_01.jpg');
height = 2;
[lPyramid, gPyramid] = LaplacianPyramid(f1);
figure, imshow(gPyramid{1})
for i = 1 : height + 1
    figure, imshow(lPyramid{i})
    imwrite(lPyramid{i}, strcat('PS5-2-2-', num2str(i), '.png'));
end