function meem
disp('MEEM tracker running');
% ncc VOT integration example
% 
% This function is an example of tracker integration into the toolkit.
% The implemented tracker is a very simple NCC tracker that is also used as
% the baseline tracker for challenge entries.
%

% *************************************************************
% VOT: Always call exit command at the end to terminate Matlab!
% *************************************************************
cleanup = onCleanup(@() exit() );

% *************************************************************
% VOT: Set random seed to a different value every time.
% *************************************************************
RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', sum(clock)));
% **********************************
% VOT: Get initialization data
% **********************************
[handle, image, region] = vot('rectangle');
% Initialize the tracker
% [pathstr,name,ext] = fileparts(image);
% ext = ext(2:end);
% start_id = str2double(name);
% res = MEEMTrack_init(pathstr, ext,0,region,start_id);
disp('Initializing...');
disp(image);
state = MEEMTrack_init(image,region);
while true
    % **********************************
    % VOT: Get next frame
    % **********************************
    [handle, image] = handle.frame(handle);

    if isempty(image)
        disp('empty image');
        break;
    end;
    
	% Perform a tracking step, obtain new region
    %[state, region] = ncc_update(state, imread(image));
%      [~,name,~] = fileparts(image);
%      disp(image);
%      id = str2double(name);
%      disp(id);
       [state, region] = MEEMTrack_update(image, state );
%      region = res(id - start_id + 1,:);
%       res = FBF_MEEMTrack(image,0,region);
%       region = res.res;
    % **********************************
    % VOT: Report position for frame
    % **********************************
    handle = handle.report(handle, region);
    
end;

% **********************************
% VOT: Output the results
% **********************************
handle.quit(handle);


end
