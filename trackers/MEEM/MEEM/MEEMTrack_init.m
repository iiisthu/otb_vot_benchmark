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

function state = MEEMTrack_init(input,init_rect)

% declare global variables
global sampler
global svm_tracker
global experts
global config
global finish % flag for determination by keystroke

config.display = true;
sampler = createSampler();
svm_tracker = createSvmTracker();
experts = {};
finish = 0;

timer = 0;
result.res = nan(1,4);
result.len = 1;
result.type = 'rect';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    main loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output = zeros(1,4);

%% read a frame
I_orig=imread(input);

%% intialization

% crop to get the initial window
if isequal(init_rect,-ones(1,4))
    assert(config.display)
    figure(1)
    imshow(I_orig);
    [InitPatch init_rect]=imcrop(I_orig);
end
init_rect = round(init_rect);

config = makeConfig(I_orig,init_rect,true,true,true,0);
svm_tracker.output = init_rect*config.image_scale;
svm_tracker.output(1:2) = svm_tracker.output(1:2) + config.padding;
svm_tracker.output_exp = svm_tracker.output;

output = svm_tracker.output;
%% compute ROI and scale image
[I_scale]= getFrame2Compute(I_orig);

%% crop frame
sampler.roi = rsz_rt(svm_tracker.output,size(I_scale),5*config.search_roi,false);


I_crop = I_scale(round(sampler.roi(2):sampler.roi(4)),round(sampler.roi(1):sampler.roi(3)),:);

%% compute feature images
[BC F] = getFeatureRep(I_crop,config.hist_nbin);
%% tracking part
tic

    initSampler(svm_tracker.output,BC,F,config.use_color);
    train_mask = (sampler.costs<config.thresh_p) | (sampler.costs>=config.thresh_n);
    label = sampler.costs(train_mask,1)<config.thresh_p;
    fuzzy_weight = ones(size(label));
    initSvmTracker(sampler.patterns_dt(train_mask,:), label, fuzzy_weight);

    if config.display
        figure(1);
        imshow(I_orig);
        res = svm_tracker.output;
        res(1:2) = res(1:2) - config.padding;
        res = res/config.image_scale;
        rectangle('position',res,'LineWidth',2,'EdgeColor','b')
    end


timer = timer + toc;

res = output;
res(1:2) = res(1:2) - config.padding;
result.res(1,:) = res/config.image_scale;

%% output restuls
result.fps = result.len/timer;
state.config = config;
state.result = result;
state.sampler = sampler;
state.svm_tracker = svm_tracker;
state.experts = experts;
state.output = output;

clearvars -global sampler svm_tracker experts config finish 
