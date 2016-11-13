function [ output_args ] = benchmark(  )
clear all;
close all;
%BENCHMARK Summary of this function goes here
%   Detailed explanation goes here
root_path = '../data/vot2016/';
show = 0;
ext = 'jpg';
final.fps = [];
final.err = [];
final.id = [];
files = dir(root_path);
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));
for i=1:length(directoryNames)
  folder=directoryNames{i};
  final.id = [final.id, {folder}];
  [fps, err] = demo(folder, root_path, ext, show);
  final.fps = [final.fps; fps];
  final.err = [final.err; err];
end
end

