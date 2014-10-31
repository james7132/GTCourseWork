function [ HarrisValues ] = Harris( I_x, I_y, WindowSize, alpha)
    [size_r, size_c] =  size(I_x);
    w = (WindowSize - 1)/ 2;
    gradX = padarray(I_x, [w, w], 'both');
    gradY = padarray(I_y, [w, w], 'both');
    Window = fspecial('gaussian', WindowSize, 1);
    HarrisValues = im2double(I_x * 0.0);
    for i = w + 1 : size_r + w 
        for j = w + 1: size_c + w
            GradXWindow = gradX(i - w: i + w, j - w: j + w);
            GradYWindow = gradY(i - w: i + w, j - w: j + w);
            M = ComputeM(GradXWindow, GradYWindow, Window);
            HarrisValues(i - w, j - w) = det(M) - alpha * trace(M) ^ 2;
        end
    end
end

function [ M ] = ComputeM( GradX, GradY, Window )
    [size_Gr, size_Gc] = size(GradX);
    M = zeros([2, 2]);
    for x = 1 : size_Gr
        for y = 1 : size_Gc
            I_x = GradX(x, y);
            I_y = GradY(x, y);
            M = M + Window(x, y) * [I_x ^ 2, I_x * I_y; I_x * I_y, I_y ^ 2];
        end
    end
end