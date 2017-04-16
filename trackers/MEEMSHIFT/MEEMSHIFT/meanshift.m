function [can_hist, rect]  = meanshift( Im, rect, target_hist, option )
m = 4096;
Y = [2,2];
max_iter = 20;
iter = 0;
while(norm(Y)^2 >0.5) && iter< max_iter
    iter = iter + 1;
    [row, col, ~] = size(imcrop(Im, rect));
    [can_hist,can_bin, can_bg]=gen_hist(option, Im, rect); 
    % weight vector
    w = zeros(1,m);                                              
    for i=1:m  
        if(can_hist(i)~=0) 
                w(i)=can_bg(i)*sqrt(target_hist(i)/can_hist(i)); 
                %w(i)= sqrt(target_hist(i)/can_hist(i)); 
        else  
            w(i)=0;  
        end  
    end

    xw=[0,0];  
    sum_w = 0;
    for i=1:row;  
        for j=1:col
            sum_w=sum_w+w(can_bin(i,j)+1);  
            xw=xw+w(can_bin(i,j)+1)*[i-row/2-0.5,j-col/2-0.5];  
        end  
    end  
    Y_new =xw/sum_w;  
%    fprintf('newY: [%f, %f]\n', Y_new(1), Y_new(2) );
    rect(1)=rect(1)+Y_new(2);  
    rect(2)=rect(2)+Y_new(1);
%    disp(rect);
end
end


