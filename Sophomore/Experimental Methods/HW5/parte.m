function [uncer_y_poly ] = parte(y,x,t)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
i=1;
sum_in=0;
while i<=length(y)
    in=(y(i)-x(1)-x(2)*t(i)-x(3)*t(i)^2)^2;
    sum_in=sum_in+in;
    i=i+1;
end
    uncer_y_poly=sqrt((1/(length(y)-2))*sum_in);

fileID = fopen('parte.txt','w');
crap='uncertainty of y = %1f';
fprintf(fileID,crap,uncer_y_poly);
fclose(fileID);
end

