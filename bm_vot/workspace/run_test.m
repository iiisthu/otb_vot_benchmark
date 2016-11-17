% This script can be used to test the integration of a tracker to the
% framework.

addpath('/Users/shenh10/Documents/CodingPath/cv/tracker_benchmarks/bm_vot'); toolkit_path; % Make sure that VOT toolkit is in the path

[sequences, experiments] = workspace_load();

tracker = tracker_load('MEEM');

workspace_test(tracker, sequences);

