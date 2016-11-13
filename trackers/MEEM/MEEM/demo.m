%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Implemetation of the tracker described in paper
%	"MEEM: Robust Tracking via Multiple Experts using Entropy Minimization", 
%   Jianming Zhang, Shugao Ma, Stan Sclaroff, ECCV, 2014
%	
%	Copyright (C) 2014 Jianming Zhang
%
%	This program is free software: you can redistribute it and/or modify
%	it under the terms of the GNU General Public License as published by
%	the Free Software Foundation, either version 3 of the License, or
%	(at your option) any later version.
%
%	This program is distributed in the hope that it will be useful,
%	but WITHOUT ANY WARRANTY; without even the implied warranty of
%	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%	GNU General Public License for more details.
%
%	You should have received a copy of the GNU General Public License
%	along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%	If you have problems about this software, please contact: jmzhang@bu.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fps, err] = demo(arg, root_path, ext, show)
if ~exist('show','var')
show = 1;
end
if ~exist('root_path','var')
root_path = '../data/vot2016/'
end
if ~exist('ext','var')
ext = 'jpg';
end
if ~exist('arg','var')
arg = 'motocross1';
end
data_path = strcat(root_path,arg, '/');
gt = strcat(data_path, 'groundtruth.txt');

[x1, y1, x2, y2, x3, y3, x4, y4] = textread(gt, '%f,%f,%f,%f,%f,%f,%f,%f');

xmin = min([x1,x2,x3,x4]')';
ymin = min([y1,y2,y3,y4]')';
xmax = max([x1,x2,x3,x4]')';
ymax = max([y1,y2,y3,y4]')';
width = xmax - xmin;
height = ymax - ymin;

res = MEEMTrack(data_path,ext,show,[xmin(1),ymin(1),width(1),height(1)]);
fps = res.fps;
err = mean(abs(res.res - [xmin,ymin, width, height])./res.res);
str = sprintf('Frame rate(%f fps), mean error(x(%f) y(%f) width(%f) height(%f) ) \n', fps, err);
disp(str);
end