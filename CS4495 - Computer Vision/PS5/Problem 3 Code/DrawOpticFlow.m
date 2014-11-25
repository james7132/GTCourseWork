function [ ] = DrawOpticFlow( U, V )
    figure
    subplot(2,1,1), imagesc(U)
    colormap default
    colorbar
    subplot(2,1,2),imagesc(V)
    colormap default
    colorbar
    %figure
    %[sr, sc] = size(U);
    %[X, Y] = meshgrid(1 : sc, 1 : sr);
    %quiver(X, Y, U, -V)
end

