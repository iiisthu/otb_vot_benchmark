function results=run_MEANSHIFT(seq, res_path, bSaveImage)

close all;


addpath('./MEANSHIFT')
%featureName kernelName param svmC svmBudgetSize searchRadius seed
%featureName: raw haar histogram
%kernelName: linear gaussian intersection chi2
%seed: default - 0
[res] = ms_run( seq.path,seq.ext, 'scale', true, bSaveImage );


results.res = res;

results.type='rect';
results.fps=0;