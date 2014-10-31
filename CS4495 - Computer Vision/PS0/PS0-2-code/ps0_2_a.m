image1 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05');

im1_red = image1(:,:,1);

im1_blue = image1(:,:,3);

new_image1 = image1(:,:,:);

new_image1(:,:,3) = im1_red;
new_image1(:,:,1) = im1_blue;

imshow(new_image1);

imwrite(new_image1, 'ps0-2-a-1.png')