image1 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05');

im1_green = image1(:,:,2);

imshow(im1_green);

imwrite(im1_green, 'ps0-2-b-1.png')