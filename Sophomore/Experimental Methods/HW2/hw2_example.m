
%Sample code to demonstrate techniques for HW2
%S. McGuire, 3Sept2014

%Setup: You are attempting to validate the speed of sound through air
%Your data are collected by volunteers standing on the football field at
%20-m increments. 
%
%A horn and a light on the scoreboard activate at the same time. Each
%volunteer starts their watch when the light changes and records when they
%hear the horn. 

%Your distances are measured in m from the horn; all of the volunteers
%and the horn are located on a sideline. The error in your distance
%measurement is +/- 1 m, and each volunteer has been carefully screened to
%determine their error in reporting known times. Data are summarized:

% Distance(m) | Time(s) | Time Uncertainty (+/- sec)
%     20          .07        0.02
%     40          .11        0.01
%     60          .17        0.03
%     80          .26        0.02
%    100          .37        0.01
%    

%Determine the speed of sound by plotting time as a function of distance
%and measuring the slope, yielding the 1/(speed) and compare to the accepted
%value of 330 m/s.
% Your plot includes the following lines:
%1. The 'best' estimate, using a linear fit of the data to determine slope
%2. The maximum value, finding the maximum slope
%3. The minimum value, finding the minimum slope 

%This example only includes plots 1 and 2 - plot #3 is left as an exercise
%for the reader. Also, the plot is neither labelled nor includes a legend -
%these are both required items that have been provided as previous
%examples.

close all;
clear all;
figure;

%Prepare source data
%Distances, with uniform error
src_dist = [20 40 60 80 100]';
src_derr = (1 .* ones(1, length(src_dist)))';

%Times, with individual errors
src_time = [0.05 0.11 0.17 0.26 0.37]';
src_terr = [0.02 0.01 0.03 0.02 0.01]';

%Add multiple plots to the figure
hold on;

%Compute the maximum values as well as minimum using the (vertical) errors as given
%Use two iterations of point-slope form: one for the max slope, one for the
%min slope

max_time = src_time + src_terr;
min_time = src_time - src_terr;

max_d = src_dist + src_derr;
min_d = src_dist - src_derr;

max_slope.x = [max(min_d) min(max_d)];
max_slope.y = [max(max_time) min(min_time)];
max_slope.m = (max_slope.y(2) - max_slope.y(1)) / (max_slope.x(2) - max_slope.x(1));

%Use the fit() function to get a linear fit with 'goodness' data
[best_p, best_gof] = fit(src_dist, src_time, 'poly1'); %Constrain to linear fit, 'best'

%Since best_p is a function, not a vector, Matlab defaults to plotting them
%over [0, 1]. This sets the X values to range from 0 to 4

xlim([0, 110]);
ylim([0, 0.5]);
%Plot each of our fits first, so that the legend doesn't get confused about
%what line color goes to what data

plot(max_slope.x, max_slope.y, 'r*-');
plot(best_p,'y');

%Plot the vertical error bars
errorbar(src_dist, src_time, src_terr, '.');
%And then the horizontal, using the provided herrorbar function, from:
% http://www.mathworks.com/matlabcentral/fileexchange/3963-herrorbar

herrorbar(src_dist, src_time, src_derr, '.');

%Extract the coefficients from the cfit object
best_coeff = coeffvalues(best_p);

%Compose some strings for the legend with the r^2 and the linear
%coefficients
max_leg = sprintf('Max fit slope: %2.2f', 1/max_slope.m);
best_leg = sprintf('Best fit slope: %2.2f, r^2: %3.2f', 1/best_coeff(1), best_gof.rsquare);

%Console output 
fprintf('Slope, max: %3.1f\n', 1/max_slope.m);
fprintf('Slope, best: %3.1f, r^2: %3.3f\n', 1/best_coeff(1), best_gof.rsquare);

%Let the next plot() replace our work
hold off;

%Results are not consistent with accepted value.