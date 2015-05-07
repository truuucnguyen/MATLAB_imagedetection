function [x,y,score] = detect(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%

%initializing returned product
x = zeros(ndet);
y = zeros(ndet);
score = zeros(ndet);


% compute the feature map for the image
f = grad_hist(I);
[h, w, b] = size(f);

nori = size(f,3);


% cross-correlate template with feature map to get a total response
R = zeros(size(f,1),size(f,2));
for i = 1:nori
    % goes up only until template size cannot fit in window anymore
    for x = 1:w-size(template,2)+1
        for y = 1:h-size(template,1)+1
            % for range in size of template will compute dot product
            for j = 1:size(template,2)
                for k = 1:size(template,1)
                    R(y,x) = R(y,x) + (template(k,j,i)*f(k+y-1,x+j-1,i));
                end
            end
        end
    end
end

% now return locations of the top ndet detections

% sort response from high to low
[val,ind] = sort(R(:),'descend');

% work down the list of responses, removing overlapping detections as we go
i = 1;
detcount = 0;
while ((detcount < ndet) && (i < length(ind)))
  % convert ind(i) back to (i,j) values to get coordinates of the block
  xblock = ceil(ind(i)/size(f,1));
  yblock = rem(ind(i),size(f,1));

%   display(i);
%   display(val(i));
%   display(ind(i));
%   display(yblock);
%   display(xblock);
  assert(val(i)==R(yblock,xblock)); %make sure we did the indexing correctly

  % now convert yblock,xblock to pixel coordinates 
  ypixel = 8*yblock;
  xpixel = 8*xblock;

  overlap = 0;
  [ty, tx] = size(template);
  ty = ty*4;
  tx = ty*4;
  % check if this detection overlaps any detections which we've already added to the list
  for o = 1:detcount
      samplex = x(o):x(o)+tx;
      sampley = y(o):y(o)+ty;
      for curx = xpixel:xpixel+tx
          for cury = ypixel:ypixel+ty
              if sum(find(samplex == curx))>0
                  if sum(find(sampley == cury))>0
                      overlap = 1;
                  end
              end
          end
      end
  end
  
  % if not, then add this detection location and score to the list we return
  if (~overlap)
    x(detcount+1) = xpixel;
    y(detcount+1) = ypixel;
    score(detcount+1) = val(i);
    detcount = detcount+1;
  end
  i = i + 1;
end


