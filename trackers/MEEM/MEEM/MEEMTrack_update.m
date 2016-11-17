%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Implemetation of the tracker described in paper
%	"MEEM: Robust Tracking via Multiple Experts using Entropy Minimization", 
%   Jianming Zhang, Shugao Ma, Stan Sclaroff, ECCV, 2014
%	
%	Copyright (C) 2014 Jianming Zhang
%
%	This program is free software: you can redistribute it and/or modify
%	it under the terms of the GNU General Public License as published by
%	the Free Software Foundation, either version 3 of the License, or
%	(at your option) any later version.
%
%	This program is distributed in the hope that it will be useful,
%	but WITHOUT ANY WARRANTY; without even the implied warranty of
%	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%	GNU General Public License for more details.
%
%	You should have received a copy of the GNU General Public License
%	along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%	If you have problems about this software, please contact: jmzhang@bu.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [state, output] = MEEMTrack_update(input,state)

% parse input arguments


% declare global variables
global sampler
global svm_tracker
global experts
global config

sampler = state.sampler;
svm_tracker = state.svm_tracker;
experts = state.experts;
config = state.config;
result = state.result;

output = state.output;

timer = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    main loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% read a frame
I_orig=imread(input);


%% compute ROI and scale image
[I_scale]= getFrame2Compute(I_orig);

%% crop frame
%if svm_tracker.confidence > config.svm_thresh
sampler.roi = rsz_rt(output,size(I_scale),config.search_roi,true);

I_crop = I_scale(round(sampler.roi(2):sampler.roi(4)),round(sampler.roi(1):sampler.roi(3)),:);

%% compute feature images
[BC F] = getFeatureRep(I_crop,config.hist_nbin);
%% tracking part
tic

% testing
if config.display
    figure(1)
    imshow(I_orig);       
    roi_reg = sampler.roi; roi_reg(3:4) = sampler.roi(3:4)-sampler.roi(1:2)+1;
    roi_reg(1:2) = roi_reg(1:2) - config.padding;
    rectangle('position',roi_reg/config.image_scale,'LineWidth',1,'EdgeColor','r');
end
if mod( 1 ,config.expert_update_interval) == 0% svm_tracker.update_count >= config.update_count_thresh
    updateTrackerExperts;
end

expertsDo(BC,config.expert_lambda,config.label_prior_sigma);

if svm_tracker.confidence > config.svm_thresh
    output = svm_tracker.output;
end


if config.display
    figure(1) 
    res = output;
    res(1:2) = res(1:2) - config.padding;
    res = res/config.image_scale;
    if svm_tracker.best_expert_idx ~= numel(experts)
        % red rectangle: the prediction of current tracker
        res_prev = svm_tracker.output_exp;
        res_prev(1:2) = res_prev(1:2) - config.padding;
        res_prev = res_prev/config.image_scale;
        rectangle('position',res_prev,'LineWidth',2,'EdgeColor','r') %
        % yellow rectangle: the prediction of the restored tracker
        rectangle('position',res,'LineWidth',2,'EdgeColor','y')   
    else
        % blue rectangle: indicates no restoration happens 
        rectangle('position',res,'LineWidth',2,'EdgeColor','b') 
    end
end


%% update svm classifier
svm_tracker.temp_count = svm_tracker.temp_count + 1;

if svm_tracker.confidence > config.svm_thresh %&& ~svm_tracker.failure
    train_mask = (sampler.costs<config.thresh_p) | (sampler.costs>=config.thresh_n);
    label = sampler.costs(train_mask) < config.thresh_p;

    skip_train = false;
    if svm_tracker.confidence > 1.0 
        score_ = -(sampler.patterns_dt(train_mask,:)*svm_tracker.w'+svm_tracker.Bias);
        if prod(double(score_(label) > 1)) == 1 && prod(double(score_(~label)<1)) == 1
            skip_train = true;
        end
    end

    if ~skip_train
        costs = sampler.costs(train_mask);
        fuzzy_weight = ones(size(label));
        fuzzy_weight(~label) = 2*costs(~label)-1;
        updateSvmTracker (sampler.patterns_dt(train_mask,:),label,fuzzy_weight);  
    end
else % clear update_count
    svm_tracker.update_count = 0;
end

% toc

timer = timer + toc;

res = output;
res(1:2) = res(1:2) - config.padding;
result.len = result.len + 1;
result.res(result.len,:) = res/config.image_scale;
%% output restuls
result.fps = mean([1/timer,result.fps]);
state.config = config;
state.result = result;
state.sampler = sampler;
state.svm_tracker = svm_tracker;
state.experts = experts;
state.output = output;
output = result.res(result.len,:);
clearvars -global sampler svm_tracker experts config finish 

