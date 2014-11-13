%f = {imread('shift0.png'), imread('shiftR2.png')};
%f = {imread('yos_img_01.jpg'), imread('yos_img_02.jpg'), imread('yos_img_03.jpg')};
f = {rgb2gray(imread('0.png')), rgb2gray(imread('1.png')), rgb2gray(imread('2.png'))};
ws = 30;
wsig = 13;
bs = 30;
bsig = 13;
frameTransitions = length(f) - 1;
lHeight = 3;
gHeight = lHeight + 1;
selectedHeight = 2;
errorPerPixel = zeros(1, gHeight);
[lPyr, gPyr] = LaplacianSequence(f, lHeight);
U = cell(frameTransitions, gHeight);
V = cell(frameTransitions, gHeight);
warped = cell(frameTransitions, gHeight);
diff = cell(frameTransitions, gHeight);
for i = 1 : frameTransitions
    cFrame = i;
    nFrame = i + 1;
    [u, v] = OpticFlow(gPyr{cFrame, gHeight}, gPyr{nFrame, gHeight}, bs, bsig, ws, bsig);
    U{i, gHeight} = u;
    V{i, gHeight} = v;
    warped{i, gHeight} = Warp(gPyr{nFrame, gHeight}, u, v);
    [sr, sc] = size(warped{i, gHeight});
    diff{i, gHeight} = abs(warped{i, gHeight} - gPyr{i + 1, gHeight});
    errorPerPixel(gHeight) = errorPerPixel(gHeight) + (sum(sum(diff{i, gHeight}))) / (sr * sc);
    for j = gHeight - 1 : -1 : 1
        currentG = gPyr{nFrame, j};
        [sr, sc] = size(currentG);
        expandedWarp = Expand(warped{cFrame, j + 1}, sr, sc);
        [u, v] = OpticFlow(expandedWarp, currentG, bs, bsig, ws, bsig);
        U{i, j} = u;
        V{i, j} = v;
        warped{i, j} = Warp(currentG, u, v);
        diff{i, j} = abs(warped{i, j} - gPyr{i + 1, j});
        errorPerPixel(j) = errorPerPixel(j) + (sum(sum(diff{i, j}))) / (sr * sc);
    end
end
[~, selectedIndex] = find(errorPerPixel == min(min(errorPerPixel)));
frameTime = 1/60;
[sr, sc] = size(warped{1, selectedHeight});
for i = 1 : frameTransitions
    figure, DrawOpticFlow(U{i, selectedHeight}, V{i, selectedHeight});
    figure, imshow(diff{i, selectedHeight});
    sum(sum(diff{i, selectedHeight})) / (sr * sc)
    framesij = zeros(sr, sc, 2);
    framesij(:, :, i) = gPyr{i + 1, selectedHeight};
    framesij(:, :, i + 1) = warped{i, selectedHeight};
    implay(framesij, 60);
end