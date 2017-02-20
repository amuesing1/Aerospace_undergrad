function [thrust, dmdt] = interpolation( file )

% load file
data = load(file);
data = data(:,3);
% change lbf to N
data=4.44822*data;

% crateing time array from sample rate
sample_rate=1.652000*1000;
time_int=sample_rate^-1;
time=[1:size(data)]*time_int;

%Find where to start the numerical integration
start = find(data >= 3);
start = start(1) - 15;

%find the smallest value in the data set 
minVal = min(data(start+100:end));
ending = find(data == minVal);

%concatinate data set and plot
data = data(start:ending(1));

%Create a zero line
line = linspace(0, minVal,length(data))';
time = linspace(0, length(data)*time_int,length(data))';

% Find mass flow rate
dmdt = (line(end) - line(1))/(time(end) - time(1));

thrust = [time, (data - line)];
end

