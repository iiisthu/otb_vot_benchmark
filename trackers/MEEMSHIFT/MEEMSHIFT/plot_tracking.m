function  plot_tracking( Im, target_hist, can_hist, rect, im_title, hist_title,id, varargin )
if length(varargin) > 0
    target_rect = varargin{1};
end
figure(id);
subplot(121);
imshow(Im);
title(im_title);
hold on;
rectangle('position',rect,'LineWidth',2,'EdgeColor','r');
if length(varargin) > 0
    rectangle('position',target_rect,'LineWidth',2,'EdgeColor','b');
end
subplot(122);
plot(target_hist,'b');
hold on;
plot(can_hist,'r');
title(hist_title);
pause(0.001);
end

