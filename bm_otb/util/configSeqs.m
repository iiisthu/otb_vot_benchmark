function seq =configSeqs(bm)
files = dir(bm);
directoryNames = {files([files.isdir]).name};
directoryNames = directoryNames(~ismember(directoryNames,{'.','..'}));
seq = [];
for i=1:length(directoryNames)
  folder=directoryNames{i};
  path = strcat(bm,'/',folder); 
  image_path = strcat(path, '/img/');
 
  %files = dir(strcat(image_path,'*.jpg'));
  %endFrame = length(files); 
  if strcmp(folder, 'Jogging') == 1 ||  strcmp(folder, 'Skating2') == 1 ||  strcmp(folder, 'Human4') == 1 
     gts = dir(strcat(path,'/*.txt'));
     gts = [{gts.name}];
     for g=1:length(gts)
        endFrame = numel(textread(strcat(path, '/', gts{g}),'%1c%*[^\n]'));
        if endFrame < 1
            continue;
        end
        seq = [ seq, {struct('name', strcat(folder,'-',num2str(g)),'path', image_path, 'startFrame',1,'endFrame',...
        endFrame,'nz',4,'ext','jpg','init_rect', [0,0,0,0])} ];
     end
  else
    gts = dir(strcat(path,'/*.txt'));
    gts = [{gts.name}];
    endFrame = numel(textread(strcat(path, '/', gts{1}),'%1c%*[^\n]'));
    nz = 4;
    if strcmp(folder, 'Board') == 1
        nz = 5;
    end
    seq = [ seq, {struct('name', folder,'path', image_path, 'startFrame',1,'endFrame',...
      endFrame,'nz',nz, 'ext','jpg','init_rect', [0,0,0,0])} ];
  end
  end
end

