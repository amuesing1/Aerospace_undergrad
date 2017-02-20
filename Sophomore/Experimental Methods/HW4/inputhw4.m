%Jeremy Muesing
%HW4
%Date 10/1/14


%this code assumses 5 lines of exposition followed by 4 processes
%Engineering Process: Assumptions
function [process] = input(file)
%takes the given file and inputs the values into an array
FID=fopen(file);
words=fgets(FID); %filler words at the beginning
words=fgets(FID);
words=fgets(FID);
words=fgets(FID);
words=fgets(FID);
i=1;
while i<=4
    read=fgets(FID);
    save=str2num(read);
    process(i,1)=save(1,1); %inputs row by row
    process(i,2)=save(1,2);
    process(i,3)=save(1,3);
    i=i+1;
end

