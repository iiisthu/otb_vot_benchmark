function R  = SSD(I, rect, init_rect)
% init_rect = ceil(init_rect);
% rect = ceil(rect);
% target distribution
T = imcrop(I, init_rect);

T = mat2gray(T);

[row,col,~] = size(T);
npoints = 20;
dim = 2;
p = zeros(npoints,dim);
p(1,:) = [ floor( (row + 1)/ 2 ), floor((col + 1)/2) ];
p(2,:) = [ floor( (row + 1)/ 2 ), floor( (col + 1)/ 4 )];
p(3,:) = [ floor( (row + 1)/ 4 ), floor( (col + 1)/ 2 )];
p(4,:) = [ floor( (row + 1)/ 2 ), floor( (col + 1)*3 / 4 )];
p(5,:) = [ floor( (row + 1)* 3 / 4 ), floor( (col + 1)/ 2 )];
for i = 6:npoints
    p(i,:) = [ floor(rand(1,1)*row),  floor(rand(1,1)*col)];
end
% SSD

ssd = zeros(npoints, 1);

for i = 1: npoints
        this_rect = [ rect(1)+ p(i,1) - 1, rect(2)+ p(i,2) - 1 , init_rect(3:4)];
        this_T = imcrop(I, this_rect);
        this_T = mat2gray(this_T);
        [new_row, new_col, ~] = size(this_T);
        i_row = min(row, new_row);
        i_col = min(col, new_col);
        ssd(i) = sum(sum(sum((this_T(1:i_row,1:i_col,:) - T(1:i_row,1:i_col,:)).^2)));
end
k = 0.001;
A = 1;
eps = 0.1;
step = 1;
target = 1;
while abs(summ(A,k,ssd)-1) > eps
    if summ(A,k,ssd) > target
        step = min(1,step) * 3;
        k = k*step;
    end
    if summ(A,k,ssd) < target
        step = min(step,1) * 0.5;
        k = k*step;
    end
end
fprintf('k: %f, sum: %f',k, A*sum(sum(exp(-k*ssd))));
rou = zeros(2,2);
normal = 0;
for i = 2:npoints
rou(1) = rou(1)+  exp(-k*ssd(i))*(p(i,1)-p(1,1))^2;
rou(2) = rou(2)+  exp(-k*ssd(i))*(p(i,1)-p(1,1))*(p(i,2)-p(1,2));
rou(3) = rou(3)+  exp(-k*ssd(i))*(p(i,1)-p(1,1))*(p(i,2)-p(1,2));
rou(4) = rou(4)+  exp(-k*ssd(i))*(p(i,2)-p(1,2))^2;
normal = normal +  exp(-k*ssd(i));
end


R = 0.01*[rou(1)/normal, rou(2)/normal;rou(3)/normal,rou(4)/normal];
disp(R);
function a= summ(A,k,ssd)
   a =  A*sum(sum(exp(-k*ssd)));
end
end


