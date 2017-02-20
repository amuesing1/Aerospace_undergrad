%Jeremy Muesing
%HW2 MATLAB
%2.18
%Sep 15th, 2014

%Setup: You are attempting to validate the accepted vaule of gravity by
%comparing speeds at which a stone drops and the height it reaches.
%
%A student is throwing a rock and messuring height and velocity upwards.

%Data are summarized:

% height (m) | h Uncertainty (+/- m) | velocity squared | v^2 Uncertainty (+/- m^2/s^2)
%     0.4               0.05                   7                    3
%     0.8               0.05                   17                   3 
%     1.4               0.05                   25                   3
%     2.0               0.05                   38                   4
%     2.6               0.05                   45                   5  
%     3.4               0.05                   62                   5
%     3.8               0.05                   72                   6

%Determine gravity by plotting v^2 against h.

close all;
clear all;
figure;

%Prepare source data
%velocity values
velocity2 = [7 17 25 38 45 62 72];
v_err = [3 3 3 4 5 5 6];


%hight with errors
height = [0.4 0.8 1.4 2.0 2.6 3.4 3.8];
h_err = (0.05 .* ones(1, length(velocity2)));

%Add multiple plots to the figure
hold on;

max_h = height + h_err;
min_h = height - h_err;

max_v = velocity2 + v_err;
min_v = velocity2 - v_err;

max_slope.x = [max(min_v) min(max_v)];
max_slope.y = [max(max_h) min(min_h)];
max_slope.m = (max_slope.y(2) - max_slope.y(1)) / (max_slope.x(2) - max_slope.x(1));

min_slope.x = [min(min_v) max(max_v)];
min_slope.y = [min(max_h) max(min_h)];
min_slope.m = (max_slope.y(2) - max_slope.y(1)) / (max_slope.x(2) - max_slope.x(1));


Best = polyfit(height, velocity2, 1); % first order fit

xlim([0, 4]);
ylim([0, 100]);

title('h vs. v^2');
xlabel('Height (m)');
ylabel('Velocity Squared (m^2/s^2)');
x=height;
y=Best(1,1).*height+Best(1,2);
plot(x,y);
plot(max_slope.y, max_slope.x, 'r*-');
plot(min_slope.y, min_slope.x, 'r*-');

%Plot the vertical error bars
errorbar(height, velocity2, v_err, '.');
hold on;
%Plot horizontal error bars
herrorbar(height, velocity2, h_err, '.');

Slope=Best(1,1)


hold off;

%The line of best fit lies within the min and max slopes. The slope
%determined by the line of best fit is 18.3487 m/s^2 which the accepted
%error range is between 3 & 6 meaning it falls in the range of 19.6. These
%are accurate messurements.