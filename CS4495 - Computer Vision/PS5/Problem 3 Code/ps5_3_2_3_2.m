%f = {imread('shift0.png'), imread('shiftR2.png')};
%f = {imread('yos_img_01.jpg'), imread('yos_img_02.jpg'), imread('yos_img_03.jpg')};
f = {rgb2gray(imread('0.png')), rgb2gray(imread('1.png')), rgb2gray(imread('2.png'))};
ws = 30;
wsig = 13;
bs = 30;
bsig = 13;
frameTransitions = length(f) - 1;
gPyr = GaussianSequence(f);
[~, gHeight] = size(gPyr);
selectedHeight = 4;
U = cell(frameTransitions, gHeight);
V = cell(frameTransitions, gHeight);
warped = cell(frameTransitions, gHeight);
for i = 1 : frameTransitions
    for j = 1 : gHeight
        [u, v] = OpticFlow(gPyr{i, j}, gPyr{i + 1, j}, bs, bsig, ws, bsig);
        U{i, j} = u;
        V{i, j} = v;
        warped{i, j} = Warp(gPyr{i + 1, j}, u, v);
    end
end
frameTime = 1/60;
[sr, sc] = size(warped{1, selectedHeight});
for i = 1 : frameTransitions
    DrawOpticFlow(U{i, selectedHeight}, V{i, selectedHeight});
    diff = gPyr{i, selectedHeight} - warped{i, selectedHeight};
    figure, imagesc(diff);
    colormap default
    colorbar
    sum(sum(abs(diff))) / (sr * sc)
    framesij = zeros(sr, sc, 2);
    framesij(:, :, 1) = gPyr{i, selectedHeight};
    framesij(:, :, 2) = warped{i, selectedHeight};
    implay(framesij, 60);
end