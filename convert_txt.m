function convert_txt()
%CONVERT_TXT Summary of this function goes here
%   Detailed explanation goes here
tracker = 'siamese-fc';
data_set = 'vot15';
dir_path=strcat('results/results_text/',data_set,'/',tracker,'_results');
target_path = strcat('results/results_',data_set);
if ~exist(target_path)
    mkdir(target_path);
end
files = dir(strcat(dir_path,'/',data_set,'*'));
files = [{files.name}];
for i = 1: numel(files)
    [a, b] = strread(files{i}, '%s %s','delimiter', '_');
    [video, ~] = strread(b{1}, '%s %s','delimiter', '.');
    video = video{1};
    text_path = strcat(dir_path, '/',files{i});
    res_path = target_path;
    target_file = strcat(res_path, '/',video,'_',tracker,'.mat');
    results = result_txt_to_mat(tracker, text_path, res_path, video);
    if ~exist(target_file)
        save(target_file, 'results');
    end
end

end

