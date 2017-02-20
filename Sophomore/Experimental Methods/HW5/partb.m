function[uncer_y]=partb(y,t,A,B)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
i=1;
sum_in=0;
while i<=length(y)
    in=(y(i)-A-B*t(i)).^2;
    sum_in=sum_in+in;
    i=i+1;
end
uncer_y=sqrt((1/(length(y)-2))*sum_in);

fileID = fopen('partb.txt','w');
crap='uncertainty of y = %1f';
fprintf(fileID,crap,uncer_y);
fclose(fileID);
end

