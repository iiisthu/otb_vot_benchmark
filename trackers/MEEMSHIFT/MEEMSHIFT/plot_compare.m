function plot_compare(image_path, rects, case_name, colors, result_path,write)
[cases, dim, frames] = size(rects);
% load images
myfile=dir([image_path,'*.jpg']); 
if 0
figure(1);
if write
outputVideo = VideoWriter(fullfile(result_path,'demo_all.avi'));
outputVideo.FrameRate = 10;
open(outputVideo); 
end
for i = 1:frames
    I=imread([image_path,myfile(i).name]);  
	imshow(I);
	hold on;
    h = [];
	for j = 1:cases
		h1 = rectangle('position',rects(j,:,i),'LineWidth',2,'EdgeColor', colors(j));
        h = [h, h1];
    end
    if write
        f=getframe(gca);
        [X, map] = frame2im(f);
        writeVideo(outputVideo,I);
    end
    rect_legend(h,case_name);
    f=getframe(gca);
    [X, map] = frame2im(f);
    writeVideo(outputVideo,X);
    pause(0.001);

end
end
figure(2);
gt = squeeze(rects(1,:,:));
ops = zeros(frames,cases);
for i = 1:frames
	for j = 2:cases
        ops(i,j) = overlap(gt(:,i)',rects(j,:,i));
	end
end
h = [];
for i = 2:cases
h1 = plot(ops(1:5:frames,i), colors(i));
h = [h,h1];
hold on;
end
legend(h, case_name(2:end));
    function op = overlap(gt_rect, pd_rect)
        xlc = max(gt_rect(1), pd_rect(1));
        ylc = max(gt_rect(2), pd_rect(2));
        xrc = min(gt_rect(1) + gt_rect(3), pd_rect(1)+ gt_rect(3));
        yrc = min(gt_rect(2) + gt_rect(4), pd_rect(2)+ gt_rect(4));
        if yrc <= ylc || xrc <= xlc
            op = 0;
        else
            op = (yrc - ylc)*(xrc - xlc)/gt_rect(3)/gt_rect(4);
        end
    end
    function rect_legend(h,str)

        p=zeros(length(h),1);
        for n=1:length(h)
        p(n)=plot(nan,nan,'s','markeredgecolor',get(h(n),'edgecolor'),...
        'markerfacecolor',get(h(n),'facecolor'));
        end
        legend(p,str)
    end
end