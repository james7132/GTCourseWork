image1 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05');

gray_image1 = image1(:,:,1);

im1_min = min(min(gray_image1))
im1_max = max(max(gray_image1))
im1_mean = mean2(gray_image1)