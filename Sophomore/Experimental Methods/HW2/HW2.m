%Jeremy Muesing
%HW2 MATLAB
%2.17
%Sep 15th, 2014

%Setup: You are attempting to validate the relation between Power and
%current as P=RI^2 by using different measured values of power an current
%through a constant unknown resistance.
%
%A student is sending different currents through a resistance in a cup of
%water and meausres the rise in teperature of the water.

%Data are summarized: (negligible uncertainty for current)

% Current I (amps) | Power P (watts) | Power Uncertainty (+/- watts)
%        1.5               270                     50
%        2.0               380                     50
%        2.5               620                     50
%        3.0               830                     50
%        3.5               1280                    50
%        4.0               1600                    50

%Determine the Resistance by plotting P against I^2 and P against I and see
%if it remains constant.

close all;
clear all;
figure;

%Prepare source data
%current values
current = [1.5 2.0 2.5 3.0 3.5 4.0]';
current2 = current.^2;


%power with errors
power = [270 380 620 830 1280 1600]';
pow_err = (50 .* ones(1, length(current)))';

%Add multiple plots to the figure
hold on;


Best = polyfit(power, current, 2); % to produce a second-order fit
Best2 = polyfit(power, current2, 1); % first order fit

xlim([0, 2000]);
ylim([1, 5]);
%Plot each of our fits first, so that the legend doesn't get confused about
%what line color goes to what data
subplot(1,2,1);
title('P vs. I');
xlabel('Power (Watts)');
ylabel('Current (amps)');
x=power;
y=Best(1,1).*power.^2+Best(1,2).*power+Best(1,3);
plot(x,y);
hold on;
%Plot horizontal error bars
herrorbar(power, current, pow_err, '.');

subplot(1,2,2);
title('P vs. I^2');
xlabel('Power (Watts)');
ylabel('Current Squared (amps^2)');
t=power;
v=Best2(1,1).*power+Best2(1,2);
plot(t,v);
hold on;
%Plot horizontal error bars
herrorbar(power, current2, pow_err, '.');

hold off;

%The line of best fit for the P vs. I^2 does fit witin the error bars
%meaning that it matchs the expected result of a linear relationship. Since
%it was comparing P to I^2 it means the exponential relationship between
%the two is accurate also represented by plot 1.