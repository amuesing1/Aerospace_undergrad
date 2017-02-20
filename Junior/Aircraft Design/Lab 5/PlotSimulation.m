% Sarah Levine, Jaevyn Faulk, Griffin Esposito
% ASEN 3128
% RunSimLab3.m
% Created: 2/8/16
% Modified: 2/22/16

function PlotSimulation(time, aircraft_state_array, control_input_array, background_wind_array, col)
% Inputs: 
%       time = vector containing time corresponding the nth set of variables
%       aircraft_state_array = (12xn) array of aircraft state variables
%       control_input_array  = (4xn) array of control inputs
%       background_wind_array = (3xn) vector of the wind angles given in
%       inertial coordinates
%       col = string whcih indicates the poltting option used
%
% Outputs:
%       6 separate plots displaying inertial position, velocity, euler
%       angles, angle rates, control surface inputs and flight path over
%       the specified time.

asa = aircraft_state_array;
cia = control_input_array;
bwa = background_wind_array; 

question = input('What problem number is this?\n','s');

% Plot of Inertial Position as a fn. of time:
figure(1);
hold on
subplot(311);
plot(time, asa(1, :), col); hold on;
ylabel('X')
title('Inertial Position - [m]', 'fontsize',18)
set(gca, 'fontsize',14)
subplot(312);
plot(time, asa(2, :), col); hold on;
ylabel('Y')
set(gca, 'fontsize',14)
subplot(313);
plot(time, -asa(3, :), col); hold on;
ylabel('Z')
xlabel('Time [s]')
% hold off
set(gca, 'fontsize',14)
position=strcat('position_',question);
print(position,'-dpng')

% Plot of Euler Angles as a fn. of time:
figure(2);
hold on
subplot(311);
plot(time, asa(4, :), col); hold on;
ylabel('\Phi')
title('Euler Angles - [rad]', 'fontsize',18)
set(gca, 'fontsize',14)
subplot(312);
plot(time, asa(5, :), col); hold on;
ylabel('\Theta')
set(gca, 'fontsize',14)
subplot(313);
plot(time, asa(6, :), col); hold on;
ylabel('\Psi')
xlabel('Time [s]')
set(gca,'fontsize',14)
% hold off
euler=strcat('euler_',question);
print(euler,'-dpng')

% Plot of Inertial Velocity as a fn. of time
figure(3);
hold on
subplot(311);
plot(time, asa(7, :), col); hold on;
ylabel('X')
title('Inertial Velocity - [m/s]', 'fontsize',18)
set(gca, 'fontsize',14)
subplot(312);
plot(time, asa(8, :), col); hold on;
ylabel('Y')
set(gca, 'fontsize',14)
subplot(313);
plot(time, asa(9, :), col); hold on;
ylabel('Z')
xlabel('Time [s]')
set(gca, 'fontsize',14)
%hold off
velocity=strcat('inertial_velocity_',question);
print(velocity,'-dpng')

% Plot of Antular Rates as a fn. of time:
figure(4);
hold on
subplot(311);
plot(time, asa(10, :), col); hold on;
ylabel('\Phi Rate')
title('Angular Rates - [rad/s^{2}]', 'fontsize',18)
set(gca, 'fontsize',14)
subplot(312);
plot(time, asa(11, :), col); hold on;
ylabel('\Theta Rate')
set(gca, 'fontsize',14)
subplot(313);
plot(time, asa(12, :), col); hold on;
ylabel('\Psi Rate')
xlabel('Time [s]')
set(gca, 'fontsize',14)
%hold off
angular=strcat('angular_rate_',question);
print(angular,'-dpng')

% Plots of control surface inputs over time:
figure(5);
hold on
subplot(411);
plot(time, cia(1, :), col); hold on;
ylabel({'Elevator' , 'Deflection', '[rad]'})
title('Control Inputs', 'fontsize',18)
set(gca, 'fontsize',14)
subplot(412);
plot(time, cia(2, :), col); hold on;
ylabel({'Aileron', 'Deflection', '[rad]'})
set(gca, 'fontsize',14)
subplot(413);
plot(time, cia(3, :), col); hold on;
ylabel({'Rudder','Deflection', ' [rad]'})
set(gca, 'fontsize',14)
subplot(414);
plot(time, cia(4, :), col); hold on;
xlabel('Time [s]')
ylabel('Throttle')
set(gca, 'fontsize',14)
%hold off
surfaces=strcat('control_surfaces_',question);
print(surfaces,'-dpng')

% Plot of wind angles 
for i=1:length(aircraft_state_array(1,:)) %convert from inertial wind to body
    wind_body(:,i) = TransformFromInertialToBody(bwa,asa(4:6,i)); %convert from rad to deg
    velocity_air_relative(:,i) = asa(7:9,i) - wind_body(:,i);
    wind_angles(:,i) = AirRelativeVelocityVectorToWindAngles(velocity_air_relative(:,i));
end
figure(6)
hold on
subplot(311);
plot(time, wind_angles(1,:), col); hold on;
ylabel('V [m/s]')
title('Wind Angles', 'fontsize',18)
set(gca, 'fontsize',14)
subplot(312);
plot(time, wind_angles(2,:)*180/pi, col); hold on;
ylabel('\beta [deg]')
set(gca, 'fontsize',14)
subplot(313);
plot(time, wind_angles(3,:)*180/pi, col); hold on;
ylabel('\alpha [deg]')
xlabel('Time [s]')
set(gca, 'fontsize',14)
wind=strcat('wind_angles_',question);
print(wind,'-dpng')

% Plot of Aircraft path with indicated starting and ending positions:
figure(7);
hold on
n = length(time);
plot3(asa(1, :), asa(2, :), -asa(3, :),col); hold on;
title('Flight Path of Aircraft', 'fontsize',18)
plot3(asa(1, 1), asa(2, 1), -asa(3, 1), 'g*'); hold on;
plot3(asa(1, n), asa(2, n), -asa(3, n), 'r*'); hold on;
grid on
xlabel('North [m]')
ylabel('East [m]')
zlabel('Height [m]')
legend('Flight Path', 'Start', 'Finish')
%hold off
path=strcat('flight_path_',question);
print(path,'-dpng')

end

