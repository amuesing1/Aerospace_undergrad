function [x,matrix_A] = partd(y,t,sum_t,sum_t2,sum_y,sum_yt)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
sum_t3=sum(t.^3);
sum_t4=sum(t.^4);
sum_yt2=sum(y.*t.^2);
matrix_A=[length(y) sum_t sum_t2; sum_t sum_t2 sum_t3; sum_t2 sum_t3 sum_t4];
matrix_B=[sum_y;sum_yt;sum_yt2];
x=matrix_A\matrix_B;

fileID = fopen('partd.txt','w');
crap='y = %1f + %1f t + %1f t^2\r\n';
fprintf(fileID,crap,x(1),x(2),x(3));
fclose(fileID);
end

