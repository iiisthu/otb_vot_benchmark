close all; 
clear all;  
clc;
dataset = 'Walking';
video_path = fullfile(['../../../../cv/tracker_benchmarks/data/otb100/',dataset,'/img/']);
data_path = fullfile(['../data/results/',dataset,'/']);
if ~exist(data_path)
    mkdir(data_path);
end
%cases = [ {'scale'},{'normal'}, {'bg_scale'},{'bg_scale_amp'},{'bg_scale_lb'},{'kalman_fv'},{'kalman_adv'}];
cases = [ {'scale'},{'normal'}];
colors = 'wrbgmkcy';
%cases = [{'kalman_adv'}];
%colors = colors(1:1+length(cases));
predict = 1;
if predict
for c = 1: length(cases)
    fname = fullfile([ data_path, cases{c}, '.mat']);
    if exist(fname)
        continue;
    end
    disp(cases{c});
    [rects] = ms_run( video_path , 'jpg', cases{c}, true, true );
    save(fname, 'rects');
end
end

case_name = ['groundtruth',cases];
% load groundtruth
[gt] = textread(fullfile(video_path, '..', 'groundtruth_rect.txt'),'','delimiter',',');
[sample, dim] = size(gt);
if dim ~= 4
   [gt] = textread(fullfile(video_path, '..', 'groundtruth_rect.txt'),'','delimiter',' ');
end
rects_all = zeros(length(case_name), 4, length(gt));
rects_all(1,:,:) = gt';
for i = 1:length(cases)
    load(fullfile([ data_path, cases{i}, '.mat']));
    rects_all(i+1,:,:) = rects(1:length(gt),:)';
end
plot_compare(video_path, rects_all, case_name, colors, data_path, 1);


