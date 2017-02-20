function [deltav,ISP] = Isp( mf,me,data )

global g

% change lbf to N
data=4.44822*data;

% crateing time array from sample rate
sample_rate=1.652000*1000;
time_int=sample_rate^-1;
time=[1:size(data)]*time_int;

% picking start of thrust based on change in data
for i=1:size(data)
    if data(i)<=1.5
        change(i)=data(i+1)-data(i);
    else
        change(i)=0;
    end
end
% assigning column to start at for integration
[value1,col1]=max(change);
% assigning column to end at for integration
[value2,col2]=min(data(:,3));

% create baseline zero force because the zero force changes as the bottle
% loses weight. Takes the starting and ending points and creates linear line
% between them.
slope=(data(col2,3)-data(col1,3))/(time(col2)-time(col1));
baseline=slope*(time-time(col2))+data(col2,3);

% Area between the baseline zero and the data
force=data(:,3)-baseline';

x=time(1,col1:col2);
y=force(col1:col2);

% taking the integral to find Isp
ISP=trapz(x,y)/(mf*g);

% using Isp to find deltaV
deltav=ISP*g*log(mf/me);

end

