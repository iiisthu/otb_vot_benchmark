% This script can be used to perform a comparative analyis of the experiments
% in the same manner as for the VOT challenge
% You can copy and modify it to create a different analyis

addpath('/Users/shenh10/Documents/CodingPath/cv/tracker_benchmarks/bm_vot'); toolkit_path; % Make sure that VOT toolkit is in the path

[sequences, experiments] = workspace_load();

error('Analysis not configured! Please edit run_analysis.m file.'); % Remove this line after proper configuration

trackers = tracker_list('MEEM', 'TODO'); % TODO: add more trackers here

context = create_report_context('report_vot2015_MEEM');

report_article(context, experiments, trackers, sequences, 'spotlight', 'MEEM'); % This report is more suitable for results included in a paper

% report_challenge(context, experiments, trackers, sequences); % Use this report for official challenge report
% report_visualization(context, experiments, trackers, sequences);  % Use this report to generate images of visual (bounding box) results of trackers