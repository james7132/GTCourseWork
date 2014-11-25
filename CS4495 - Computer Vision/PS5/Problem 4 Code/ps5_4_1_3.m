%f = {imread('shift0.png'), imread('shiftR2.png')};
%f = {imread('shift0.png'), imread('shiftR10.png')};
%f = {imread('shift0.png'), imread('shiftR20.png')};
f = {imread('shift0.png'), imread('shiftR40.png')};
%f = {imread('yos_img_01.jpg'), imread('yos_img_02.jpg'), imread('yos_img_03.jpg')};
%f = {rgb2gray(imread('0.png')), rgb2gray(imread('1.png')), rgb2gray(imread('2.png'))};
ws = 24;
wsig = 4;
bs = 24;
bsig = 4;
frameTransitions = length(f) - 1;
gPyr = GaussianSequence(f);
[~, gHeight] = size(gPyr);
gHeightMax = 7;
assert(gHeight >= gHeightMax + 1);
U = cell(frameTransitions, gHeight);
V = cell(frameTransitions, gHeight);
warped = cell(frameTransitions, gHeight);
for i = 1 : frameTransitions
    U{i, gHeightMax + 1} = 0 * gPyr{i, gHeightMax + 1};
    V{i, gHeightMax + 1} = 0 * gPyr{i, gHeightMax + 1};
    for j = gHeightMax : -1 : 1
        [sr, sc] = size(gPyr{i, j});
        up = Expand(U{i, j + 1}, sr, sc);
        vp = Expand(V{i, j + 1}, sr, sc);
        warped{i, j} = Warp(gPyr{i + 1, j}, 2 * up, 2 * vp);
        [us, vs] = OpticFlow(gPyr{i, j} , warped{i, j}, bs, bsig, ws, bsig);
        U{i, j} = up + us;
        V{i, j} = vp + vs;
    end
    [sr, sc] = size(gPyr{i, 1});
    DrawOpticFlow(U{i, 1}, V{i, 1});
    warp = Warp(gPyr{i + 1, 1}, U{i, 1}, V{i, 1});
    diff = gPyr{i, 1} - warp;
    dis = max([abs(min(min(diff))), abs(max(max(diff)))])
    sum(sum(abs(diff)))
    figure, imagesc(diff);
    colormap default
    colorbar
    [sr, sc] = size(warp);
    framesij = zeros(sr, sc, 2);
    framesij(:, :, 1) = gPyr{i, 1};
    framesij(:, :, 2) = warp;
    %implay(framesij, 60);
end