function [] = Voltage2Bin( min_voltage, max_voltage, bits )
close all
% min_voltage=0;
% max_voltage=3.3;
% bits=4;
range=max_voltage-min_voltage;
bins=linspace(1,2^bits,2^bits);

voltage=range/(2^bits)*bins;
x=linspace(1,2*pi,2^bits);
wave=1.65+1.65*sin(x);
val = [0 .25 .5 .75 1 1.25 1.5 1.75 2 2.25 2.5 2.75 3 3.25]; %value to find picked by estiamted guess
for i=1:length(val)
    tmp = abs(voltage-val(i));
    [idx idy] = min(tmp); %index of closest value
    closest_bin(i) = bins(idy); %closest value
end


binary=dec2bin(bins(end))

figure
plot(bins(closest_bin),val,'o')
xlabel('Bin #')
ylabel('Voltage')
title('Bin numbers for specific voltage values')

figure
for i=2:length(bins)
    line([bins(i-1) bins(i)],[wave(i) wave(i)])
end
xlabel('Bin #')
ylabel('Voltage')
end

