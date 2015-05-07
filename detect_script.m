% load a training example image

% Itrain = im2double(rgb2gray(imread('test/test2.jpg')));
Itrain = im2double(rgb2gray(imread('gossip.jpg')));
Itrain2 = im2double(rgb2gray(imread('test/test4.jpg')));
Itrain3 = im2double(rgb2gray(imread('test/test5.jpg')));

%have the user click on some training examples.  
% If there is more than 1 example in the training image (e.g. faces), you could set nclicks higher here and average together
nclick = 4;
figure(1); clf;
imshow(Itrain);
[x,y] = ginput(nclick); %get nclicks from the user

%compute 8x8 block in which the user clicked
blockx = round(x/8);
blocky = round(y/8); 

%visualize image patches that the user clicked on
figure(2); clf;

for i = 1:nclick
    patch = Itrain(8*blocky(i)+(-31:32),8*blockx(i)+(-31:32));
    figure(2); subplot(3,2,i); imshow(patch);
end

% compute the hog features
f = grad_hist(Itrain);
%hd = hogdraw(f);
%figure,imshow(hd);

% compute the average template for the user clicks
template = zeros(8,8,9);
for i = 1:nclick
  template = template + f(blocky(i)+(-3:4),blockx(i)+(-3:4),:); 
end
template = template/nclick;


%
% load a test image
%
% Itest= im2double(rgb2gray(imread('test/test3.jpg')));
Itest = im2double(rgb2gray(imread('gossiptest.jpg')));

% find top 5 detections in Itest
ndet = 5;
[x,y,score] = detect(Itest,template,ndet);

%display top ndet detections
figure(3); clf; imshow(Itest);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on; 
  h = rectangle('Position',[x(i)-size(template,2) y(i)-size(template,1) 64 64],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end
