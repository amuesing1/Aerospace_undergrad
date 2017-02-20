close all
clear all
clc

for i=1:100
    x(i)=500*rand;
    y(i)=500*rand;
end

figure
scatter(x,y);
xlim([0 500]);
ylim([0 500]);
title('Problem 3-c-i')
xlabel('Distance (km)')
ylabel('Distance (km)')
