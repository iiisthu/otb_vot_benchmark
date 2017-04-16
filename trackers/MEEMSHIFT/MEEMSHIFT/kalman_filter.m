function [x_vec,P] =  kalman_filter(x0, P0, Y, phi, H, Q, R, f)
% x(t+1) = phi * x(t) + wt + f
% y(t) = H * x(t) + v(t)
% Q = E(w(t)*w(t).T)
% R = E(v(t)*v(t).T)
P = P0;
x = x0;
[vec_len, sample_len] = size(Y);
x_vec = zeros(length(x), sample_len + 1);
x_vec(:,1) = x;
for i = 1: sample_len
ff = f(x);
xba = phi* x + ff;
Pba = phi* P * transpose(phi) + Q;
K = Pba * transpose(H) * inv(H*Pba*transpose(H) + R);
P = ( eye(size(K*H)) - K * H )* Pba;
if vec_len == 1
z = Y(i) - H*xba;
else
z = Y(:,i) - H*xba;
end
x = xba + K*z;
x_vec(:, i+1) = x;
end
end
