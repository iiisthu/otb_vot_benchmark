function weight = kernel( row, col )
%KERNEL Summary of this function goes here
%   Detailed explanation goes here
weight = zeros(row,col);
h = ((row-1)/2)^2 + ((col-1)/2)^2;
for i=1:row 
    for j=1:col  
        dist=(i-row/2-0.5)^2+(j-col/2-0.5)^2;  
        weight(i,j)=1-dist/h;                                          %epanechnikov profile  
    end  
end 
end

