%ASEN 3200
%Lab A-3
%Ryan Cutter, Jeff Ellenoff, Jeremy Muesing
%Created: 2/26/16
%Modified: 2/26/16

%Plotting Experimental Data

function[] = exp_data(file)

data = load(file);
time = data(:,1);
ref_pos = data(:,2);
actual_pos = data(:,3);
voltage = data(:,4);
torque = 0.05*voltage;
K1 = data(:,5);
K2 = data(:,6);

if isequal(file, 'trial_1')
    trial = 1;
    fig_title = 'Spacecraft Response to 0.5 rad Step Commands';
elseif isequal(file, 'trial_2')
    trial = 2;
    fig_title = 'Spacecraft Response to 0 Reference Angle Command';
elseif isequal(file, 'trial_3')
    trial = 3;
    fig_title = 'Spacecraft Response with High Derivative and Zero Position Gains';
end

figure(trial)
hold on
plot(time, ref_pos, 'r')
plot(time, actual_pos, 'b')
if isequal(trial,1)
    hline(0.55, 'k--', 'Max Overshoot')
    hline(-.05, 'k--')
    hline(0.525, 'g--', 'Settling')
    hline(0.475, 'g--')
end
xlabel('Time [s]')
ylabel('Angular Position [rad]')
legend('Commanded Position', 'Measured Position')
title(fig_title)
end
