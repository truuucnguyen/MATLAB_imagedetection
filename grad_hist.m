function [ohist] = grad_hist(I)
    % I is H x W size
    [h, w] = size(I);
    
    %output is of size H/8, W/8, 9
    ohist = zeros(round(h/8),round(w/8),9);
    
    % 9 equal sized bins b/w -pi/2 and pi/2 (20 degrees): pi/9 away from eachother
    % Bin 1: -pi/2 to -7pi/18; Bin 2: -7pi/18 to -5pi/18, Bin 3: -5pi/18 to
    % -3pi/18; Bin 4: -3pi/18 to -pi/18; Bin 5: -pi/18 to pi/18;
    % Bin 6: pi/18 to 3pi/18; Bin 7: 3pi/18 to 5pi/18; Bin 8: 5pi/18 to
    % 7pi/18; Bin 9: 7pi/18 to pi/2
    
    [mag, ori] = mygradient(I);
    
    % only accounts for orientations with magnitudes over a threshold
    thresh = 0.1*max(mag(:));
    
    % bin size
    binx = w/round(w/8);
    biny = h/round(h/8);
    
    % bin size for orientations are 20 degrees
    ori_binsize = 20;
    
    %for each bin, search image pixels (x,y) for orientation in b and magnitude
    %higher than thresh, mark in ohist -- x in h/8,y in h/8, b += 1
    for y = 1:h
        for x = 1:w
            o = ori(y,x);
            o = o + 90;
            bin_o = ceil(o/ori_binsize);
            if mag(y,x) > thresh
                ohist(ceil(y/biny), ceil(x/binx),bin_o) = ohist(ceil(y/biny), ceil(x/binx),bin_o) + 1;
            end
        end
    end
    
    % normalizes histogram
    totals = sum(ohist,3);
    for i = 1:9
        ohist(:,:,i) = ohist(:,:,i)./totals;
        temp = ohist(:,:,i);
        
        % sets nan values to 0
        temp(isnan(temp)) = 0;
        ohist(:,:,i) = temp;
    end
    
  
