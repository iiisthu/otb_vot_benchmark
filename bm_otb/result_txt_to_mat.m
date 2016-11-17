function results = result_txt_to_mat(tracker, text_path, res_path, video)
Nrows = numel(textread(text_path,'%1c%*[^\n]'));
res.res = dlmread(text_path);
res.type = 'rect';
res.fps = -1;
res.len = Nrows;
res.annoBegin = 1;
res.startFrame = 1;
results = {res};
end