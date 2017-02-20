function [uncer_A,uncer_B] = partc(uncer_y,y,sum_t2,delta)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
uncer_A=uncer_y*sqrt(sum_t2/delta);
uncer_B=uncer_y*sqrt(length(y)/delta);

fileID = fopen('partc.txt','w');
crap='uncertainty of A = %1f\r\n';
fprintf(fileID,crap,uncer_A);
crap='uncertainty of B = %1f';
fprintf(fileID,crap,uncer_B);
fclose(fileID);
end

