function  [rects] = ms_run( filepath, ext, option, use_gt, display )
% option: 'bg_scale', 'scale', 'normal'
if nargin < 5
    display = true;
end
if nargin < 4
    use_gt = false;
end
if nargin < 3
    option = 'bg_scale';
end
if nargin < 2
    ext = 'jpg';
end
myfile=dir([filepath,'*.', ext]);  
len_file =length(myfile);  
I=imread([filepath,myfile(1).name]);  
if ~ use_gt
% retrieve initial bounding box
    I=imread([filepath,myfile(1).name]);  
    figure(1);  
    imshow(I);  
    [I_crop,rect]=imcrop(I);  
    rect(3:4) = ceil(rect(3:4));
    close;
else
    [data] = textread(fullfile(filepath, '..', 'groundtruth_rect.txt'),'','delimiter',',');
    [sample, dim] = size(data);
    if dim ~= 4
       [data] = textread(fullfile(filepath, '..', 'groundtruth_rect.txt'),'','delimiter',' ');
    end
    rect = data(1,:);
    rect(3:4) = ceil(rect(3:4));
    I_crop = imcrop(I, rect );  
end
fprintf('Initial rect:\n');
disp(rect);
target_rect = rect;
[target_hist, ~, ~]=gen_hist(option, I,rect);
rects = [rect];
for l = 2:len_file
    if ~display
        clc;
        disp(sprintf('Processing frame %d/%d', l, len_file));
    end
    Im=imread([filepath,myfile(l).name]);  
    switch option
        case 'normal'
            [ can_hist, rect ] = meanshift(Im , rect, target_hist, option);
            im_title = 'Fixed bounding box size';
            hist_title = 'Color distribution groundtruth vs predicted';
        case 'scale'
            [can_hist,rect] = scale(Im, rect, target_hist,option);
            im_title = sprintf('Bounding box size: %.2f * %.2f', rect(3),rect(4));
            hist_title = 'Color distribution groundtruth vs predicted';
        case 'bg_scale'
            [can_hist,rect] = scale(Im, rect, target_hist,option);
            im_title = sprintf('Bounding box size: %.2f * %.2f', rect(3),rect(4));
            hist_title = 'Color distribution groundtruth vs predicted';

        case 'bg_scale_amp'
            [can_hist,rect] = scale(Im, rect, target_hist,option);
            im_title = sprintf('Bounding box size: %.2f * %.2f', rect(3),rect(4));
            hist_title = 'Color distribution groundtruth vs predicted';
        case 'bg_scale_lb'
            [can_hist,rect] = scale(Im, rect, target_hist,option);
            im_title = sprintf('Bounding box size: %.2f * %.2f', rect(3),rect(4));
            hist_title = 'Color distribution groundtruth vs predicted';
        case 'kalman_fv'
            if l == 2
                last_x = [ rect(1) + rect(3)/2, rect(2) + rect(4)/2, 0.5, 0.5]';
                last_P = [100,0,0,0;0,100,0,0;0,0,100,0;0,0,0,100];
            end
            [ can_hist, this_rect ] = scale(Im, rect, target_hist,'scale');
            [ last_x ,last_P ] = exec_kalman( last_x, last_P, Im, target_rect, this_rect, option); 
            %fprintf('tracker computed rect: (%f,%f,%f,%f)\n',this_rect(1),this_rect(2), this_rect(3),this_rect(4));
            rect = [ last_x(1) - this_rect(3)/2, last_x(2) - this_rect(4)/2, this_rect(3:4)];
            %fprintf('kalman corrected rect: (%f,%f,%f,%f)\n',rect(1),rect(2), rect(3),rect(4));
            im_title = sprintf('Bounding box size: %.2f * %.2f', rect(3),rect(4));
            hist_title = 'Color distribution groundtruth vs predicted';
            if display
                plot_tracking( Im, target_hist, can_hist, rect, im_title, hist_title, 1, this_rect);
            end
        case 'kalman_adv'
            if l == 2
                last_x = [ rect(1) + rect(3)/2, rect(2) + rect(4)/2, 0.5, 0.5]';
                last_P = [100,0,0,0;0,100,0,0;0,0,100,0;0,0,0,100];
            end
            [ can_hist, this_rect ] = scale(Im, rect, target_hist,'scale');
            [ last_x ,last_P ] = exec_kalman( last_x, last_P, Im, target_rect, this_rect, option); 
            fprintf('tracker computed rect: (%f,%f,%f,%f)\n',this_rect(1),this_rect(2), this_rect(3),this_rect(4));
            rect = [ last_x(1) - this_rect(3)/2, last_x(2) - this_rect(4)/2, this_rect(3:4)];
            fprintf('kalman corrected rect: (%f,%f,%f,%f)\n',rect(1),rect(2), rect(3),rect(4));
            im_title = sprintf('Bounding box size: %.2f * %.2f', rect(3),rect(4));
            hist_title = 'Color distribution groundtruth vs predicted';
            if display
                plot_tracking( Im, target_hist, can_hist, rect, im_title, hist_title, 1, this_rect);
            end
        otherwise
            fprintf('Not supported option;\n');
    end
    rects = [rects; rect]; 
    if display
        plot_tracking( Im, target_hist, can_hist, rect, im_title, hist_title, 1);
    end
end


end


