function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
% magnitude given by sqrt (df/dx ^2 + df/dy ^2) at each x,y
% orientation given by atan(df/dy / df/dx)

[y, x] = size(I);

%first use gaussian filter to smooth image I
G = fspecial('gaussian',[5 5], 2);
I = imfilter(I, G,'replicate');
mag = ones(y,x);
ori = ones(y,x);


% sobel filters for dx and dy
mask_dx = [-1 0 1; -2 0 2; -1 0 1];
mask_dy = [1 2 1; 0 0 0; -1 -2 -1];

% resulting filtered image with sobel filters 
dx = imfilter(I, mask_dx,'replicate');
dy = imfilter(I, mask_dy, 'replicate');

% computing magnitude and orientation of gradient at each pixel
for j = 1:y
    for i = 1:x
        mag(j,i) = sqrt(dx(j,i)^2 + dy(j,i)^2);
        ori(j,i) = atand(dy(j,i)/dx(j,i));
    end
end


