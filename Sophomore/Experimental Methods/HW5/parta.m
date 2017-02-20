function[delta,A,B,sum_t,sum_t2,sum_y,sum_yt]=parta(y,t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

sum_t2=sum(t.^2);
sum_t=sum(t);
sum_y=sum(y);
sum_yt=sum(y.*t);
delta=length(y)*sum_t2-sum_t.^2;
A=(sum_t2*sum_y-sum_t*sum_yt)/delta;
B=(length(y)*sum_yt-sum_t*sum_y)/delta;

fileID = fopen('parta.txt','w');
crap='y = %1f + %1f t';
fprintf(fileID,crap,A,B);
fclose(fileID);
end

