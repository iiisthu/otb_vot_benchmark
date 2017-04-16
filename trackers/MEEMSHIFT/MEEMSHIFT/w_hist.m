function [histo,bin]=w_hist(I,rect, normal, varargin)
nbins = 4096;
normalize = 16; % invariant for small rgd changes
image = imcrop(I, rect);
[row, col, channel] = size(image);

weight = kernel(row, col);
extra_weight = ones(1,nbins);
ring = 0;
if nargin > 4
    ring = varargin{2};
    if ring
        inner_rect = varargin{3};
        [i_row, i_col, ~] = size(imcrop(I,inner_rect));
    end
end
if nargin > 3
    extra_weight = varargin{1};
end
[row, col] = size(weight);
histo=zeros(1,nbins); 
bin =zeros(row,col);
for i=1:row 
    for j=1:col
        if ring
            if i >= row/2 - i_row/2 && i <=  row/2 + i_row/2  ...
                    && j >= col/2 - i_col/2 && j <=  col/2 + i_col/2
                continue;
            end
        end
            if channel == 1
                q_r=fix(double(image(i,j))/normalize);                               
                q_g=fix(double(image(i,j))/normalize);  
                q_b=fix(double(image(i,j))/normalize); 
            else
                q_r=fix(double(image(i,j,1))/normalize);                               
                q_g=fix(double(image(i,j,2))/normalize);  
                q_b=fix(double(image(i,j,3))/normalize); 
            end
            bin(i,j)=q_r*256+q_g*16+q_b;                                              
            histo(bin(i,j)+1)= histo(bin(i,j)+1)+weight(i,j)* extra_weight(bin(i,j)+1);                
    end
end
if normal
    histo = histo / sum(histo);
end
end

