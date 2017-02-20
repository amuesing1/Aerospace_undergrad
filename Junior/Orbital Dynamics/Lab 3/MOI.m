%Moment of Inertia calculations plot

figure(1)
hold on
for i = 1:5
    torque_file = ['torque(.' num2str(i) ')'];
    torques(i).data = load(torque_file);
    plot(torques(i).data(:,1), torques(i).data(:,3))
    legendInfo{i} = [num2str(i/10) ' Nm'];
end
xlabel('Time [s]')
ylabel('Angular Velocity [rad/s]')
legend(legendInfo, 'Location', 'best')

% for i = 1:5
%     torques(i).times = torques(i).data(:,1);
%     torques(i).omega = torques(i).data(:,3);
%     torques(i).slopes = diff(torques(i).times)./diff(torques(i).omega);
% end