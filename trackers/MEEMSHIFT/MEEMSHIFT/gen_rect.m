function rects = gen_rect(varargin)
%GEN_RECT Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    return;
end
option = varargin{1};
rect = varargin{2};
switch option
    case 'scale'
        i_scale = varargin{3};
        num_scale = varargin{4};
        rects = zeros(1,4);
        rects(3) = rect(3)+ceil(0.1*(i_scale-(num_scale+1)/2)*rect(3));
        rects(4) = rect(4)+ceil(0.1*(i_scale-(num_scale+1)/2)*rect(4));     
        rects(1) = rect(1)-0.5*0.1*(i_scale-(num_scale+1)/2)*rect(3);
        rects(2) = rect(2)-0.5*0.1*(i_scale-(num_scale+1)/2)*rect(4); 
    case 'bg'
        sigma = 2;
        rects(3) = rect(3)+ceil(sigma*rect(3));
        rects(4) = rect(4)+ceil(sigma*rect(4));     
        rects(1) = rect(1)-0.5*sigma*rect(3);
        rects(2) = rect(2)-0.5*sigma*rect(4); 
end 

end


