image1 = imread('http://sipi.usc.edu/database/download.php?vol=misc&img=4.2.05');

gray_image1 = image1(:,:,1);

shiftedGray_image1 = gray_image1(:,:,:)

shiftedGray_image1(:,1:end-2) = gray_image1(:,3:end);
shiftedGray_image1(:,end-1) = 0;
shiftedGray_image1(:,end-2) = 0;

dGray_image1 = im2double(gray_image1)
dShifted_gray_image1 = im2double(shiftedGray_image1)

subtract = dGray_image1 - dShifted_gray_image1;

imshow(subtract, [0,1.0])

imwrite(subtract, 'ps0-4-d-1.png')