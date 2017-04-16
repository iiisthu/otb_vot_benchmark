function  [ last_x ,last_P ] = exec_kalman( last_x, last_P, Im, target_rect, this_rect, option)
%EXEC_KALMAN Summary of this function goes here
%   Detailed explanation goes here
phi = diag(ones(4,1));
H = diag(ones(4,1));
Q = diag(0.01*rand(4,1));
ov = 0.1;
if strcmp(option, 'kalman_fv') == 1
    R = [diag(ov*rand(2,1)),zeros(2,2);zeros(2,2),diag(ov*rand(2,1))];
else
    R  = SSD(Im, this_rect, target_rect);
    R = [R, zeros(size(R));zeros(size(R)),R ];
end
observed(1) = this_rect(1) + this_rect(3)/2;
observed(2) = this_rect(2) + this_rect(4)/2;
observed(3) = observed(1) - last_x(1);
observed(4) = observed(2) - last_x(2);
[last_x,last_P] =  kalman_filter(last_x, last_P, observed', phi, H, Q, R,@(x) f1(x));
last_x = last_x(:,end);
disp(last_x);
function a= f1(x)
    dt = 1;
    a = [x(3)*dt, x(4)*dt, 0, 0]'; 
end
end

