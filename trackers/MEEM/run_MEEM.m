function results=run_MEEM(seq, res_path, bSaveImage)

close all;

x=seq.init_rect(1);
y=seq.init_rect(2);
w=seq.init_rect(3);
h=seq.init_rect(4);
addpath('./MEEM')
%featureName kernelName param svmC svmBudgetSize searchRadius seed
%featureName: raw haar histogram
%kernelName: linear gaussian intersection chi2
%seed: default - 0

res = MEEMTrack(seq.path,seq.ext,0,seq.init_rect);


results.res = res.res;

results.type='rect';
results.fps=res.fps;