image1 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05');

im1_red = image1(:,:,1);

imshow(im1_red);

imwrite(im1_red, 'ps0-2-c-1.png')