% This script can be used to interactively inspect the results

addpath('/Users/shenh10/Documents/CodingPath/cv/tracker_benchmarks/bm_vot'); toolkit_path; % Make sure that VOT toolkit is in the path

[sequences, experiments] = workspace_load();

trackers = tracker_load('MEEM');

workspace_browse(trackers, sequences, experiments);

