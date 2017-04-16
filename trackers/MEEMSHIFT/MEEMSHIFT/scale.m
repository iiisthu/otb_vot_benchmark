function [can_hist,rect] = scale( Im, rect, target_hist, option )
scale_num = 5;
gamma = 0.1;
ro = zeros(scale_num, 1);
can_hist_s = zeros(scale_num, length(target_hist));
rect_s = zeros(scale_num, 4);
for i_scale = 1:scale_num
    can_rects = gen_rect('scale', rect, i_scale, scale_num);
    [ can_hist, can_rect ] = meanshift(Im , can_rects, target_hist,option );
    can_hist_s(i_scale,:) =  can_hist;
    rect_s(i_scale,:) = can_rect;
    ro(i_scale) = sum(sqrt(target_hist.*can_hist));
end
[rou, max_i] = max(ro);

new_rect = rect_s(max_i,:);
rect = new_rect * gamma +  rect* (1-gamma); 
[ can_hist, rect ] = meanshift(Im , rect , target_hist, option );
fprintf('value: %f, scale: %d\n', rou, max_i);


end

