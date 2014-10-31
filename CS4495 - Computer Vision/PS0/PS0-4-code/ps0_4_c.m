image1 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05');

gray_image1 = image1(:,:,1);

gray_image1(:,1:end-2) = gray_image1(:,3:end);
gray_image1(:,end-1) = 0;
gray_image1(:,end-2) = 0;

imshow(gray_image1)

imwrite(gray_image1, 'ps0-4-c-1.png')