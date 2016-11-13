function results=run_SRDCF(seq, res_path, bSaveImage)

close all;

addpath('./SRDCF')
%featureName kernelName param svmC svmBudgetSize searchRadius seed
%featureName: raw haar histogram
%kernelName: linear gaussian intersection chi2
%seed: default - 0
%tic;
%[seqs, ~] = load_video_info(strcat(seq.path,'/../'));
%res = run_SRDCF_inner(seqs);
results = run_SRDCF_inner(seq, res_path, bSaveImage);
%results.res = res;
%duration = toc;
%results.type='rect';
%results.fps=seq.len/duration;