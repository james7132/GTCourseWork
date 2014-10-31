image1 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05');

gray_image1 = image1(:,:,1);

im1_mean = mean2(gray_image1)
im1_std_dev = std2(gray_image1)

gray_image1_alter = (((gray_image1(:,:,:) -  im1_mean) / im1_std_dev) * 10) + im1_mean;

imshow(gray_image1_alter)

imwrite(gray_image1_alter, 'ps0-4-b-1.png')