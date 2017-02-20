function [deltav] = Isp(mf, me, file)
global g

data = load(file);
data = data(:,3);
% change lbf to N
data = convforce(data, 'lbf', 'N');

% crateing time array from sample rate
sample_rate=1.652000e3;
time_int=sample_rate^-1;
time=(1:size(data))*time_int;

%Find where to start the numerical integration
start = find(data >= 3);
start = start(1) - 15;

%find the smallest value in the data set 
minVal = min(data(start+100:end));
ending = find(data == minVal);

%concatinate data set and plot
data = data(start:ending(1));

%Create a zero line
line = linspace(0, minVal, length(data));
time = linspace(0, length(data)*time_int, length(data));

%perform integration
ISP = 0;
for i = 1:length(data)-1
    h = data(i+1) - line(i+1);
    ISP = ISP + h*time_int;    
end
ISP = ISP/((1)*g);

% using Isp to find deltaV
deltav=ISP*g*log(mf/me);

%fprintf('%s | ISP: %.2f | dV: %.2f\n', file, ISP, deltav)
end

