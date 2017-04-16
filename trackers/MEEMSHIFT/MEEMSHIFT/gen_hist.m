function [ target_hist, target_bin, target_hist_bg  ] = gen_hist( varargin )
%GEN_HIST Summary of this function goes here
%   Detailed explanation goes here
% input:
% normal: I_crop, rect_weight
% bg_scale: I, rect
option = varargin{1};
I = varargin{2};
rect = varargin{3};
if strncmpi(option,'bg',2)
    % generate background coeffients
    rect_bg = gen_rect( 'bg', rect );
    [target_hist_bg, ~]=w_hist(I,rect_bg, 0, ones(1,4096), 1, rect);
    %[target_hist_bg, ~]=w_hist(I,rect_bg, 0);
    target_hist_bg(target_hist_bg ~= 0) = min(target_hist_bg(target_hist_bg~=0))./target_hist_bg(target_hist_bg~=0);
    target_hist_bg(target_hist_bg == 0) = 1;
    if strcmp(option, 'bg_scale_amp')
        target_hist_bg(target_hist_bg ~= 1) = max(target_hist_bg(target_hist_bg ~= 1)*2,1);
        target_hist_bg(target_hist_bg == 0) = 1;
    end
    if strcmp(option, 'bg_scale_lb')
        target_hist_bg(target_hist_bg ~= 1) = min(target_hist_bg(target_hist_bg ~= 1),0.5);
        target_hist_bg(target_hist_bg == 0) = 1;
    end
    % compute background weighted histogram
    [target_hist_sp,target_bin_sp]=w_hist(I,rect, 1, ones(1,4096) );
    [target_hist,target_bin]=w_hist(I,rect, 1, target_hist_bg );
else
    [target_hist,target_bin] = w_hist(I, rect, 1); 
    target_hist_bg = ones(size(target_hist));
end

end


