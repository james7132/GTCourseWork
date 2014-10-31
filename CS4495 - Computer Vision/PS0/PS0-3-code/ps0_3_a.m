image1 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05');
image2 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.1.08');

gray_image1 = image1(:,:,1);
gray_image2 = image2(:,:,1);

im1_center = size(image1) / 2;
im2_center = size(image2) / 2;

gray_image2(im2_center(1) - 25: im2_center(1) + 25, im2_center - 50: im2_center + 50) = gray_image1(im1_center(1) - 25: im1_center(1) + 25, im1_center - 50: im1_center + 50);

imshow(gray_image2);

imwrite(gray_image2, 'ps0-3-a-1.png');