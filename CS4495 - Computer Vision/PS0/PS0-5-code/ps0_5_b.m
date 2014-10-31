image1 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05');

sigma = 0.05;

im_blue = image1(:,:,2);

im_blue = imnoise(im_green, 'gaussian', 0, power(sigma,2));

image1(:,:,2) = im_green;

imshow(image1)

imwrite(image1, 'ps0-5-b-1.png')