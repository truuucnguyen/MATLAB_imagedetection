% code that runs the portion that is displayed in part 1 of writeup
% testing mygradient function
bowl = imread('bowl.jpg');
bowl_g = im2double(rgb2gray(bowl));
[m, o] = mygradient(bowl_g);
figure, imagesc(m), title('Display of Magnitude') 
colorbar
colormap jet
figure, imagesc(o), title('Display of Orientation')
colorbar
colormap jet

x = imread('test/test0.jpg');
xg = im2double(rgb2gray(x));
% [m, o] = mygradient(xg);
% G = fspecial('gaussian',[5 5], 2);
% xg = imfilter(xg, G,'replicate');
% [mag, ori] = imgradient(xg);
% [dx,dy] = imgradientxy(xg);
% ohist = grad_hist(xg);


