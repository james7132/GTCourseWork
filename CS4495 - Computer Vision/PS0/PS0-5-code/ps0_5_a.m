image1 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05');

sigma = 0.1;

im_green = image1(:,:,2);

im_green = imnoise(im_green, 'gaussian', 0, power(sigma,2));

image1(:,:,2) = im_green;

imshow(image1)

imwrite(image1, 'ps0-5-a-1.png')