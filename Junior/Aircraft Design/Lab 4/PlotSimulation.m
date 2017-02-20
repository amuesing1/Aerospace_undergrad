% Jeremy Muesing
% ASEN 3128
% PlotSimulation.m
% Created: 2/8/16
% Modified: 2/22/16

function PlotSimulation(time, aircraft_state_array, control_input_array, background_wind_array, col )
% Inputs:
% time = a nx1 vector holding the time corresponding to the nth set of variables 
% aircraft_state_array = a nx12 array of the aircraft state at each moment
% in time
% control_input_array = a nx4 array of the control inputs at each moment in
% time
% background_wind_array = a nx3 array of the  background wind given
% inertial conditions
% col = string which indicates the plotting option used for each plot
%
% Outputs:
% Seven figures in total. Four containing the Inertial Position, Euler
% Angles, Inertial Velocities, and Angular Velocities. One containg each of
% the control input variables. One containing the background wind conditions
% And one that shows the 3D flight path of the
% aircraft.
%
% Purpose:
% Plot the results of a complete simulation once the simulation is
% completed.


figure(1)
hold on
a=subplot(311);
plot(time, aircraft_state_array(1,:), col); hold on;
ylabel('x_E (m)')
subplot(312);
plot(time, aircraft_state_array(2,:), col); hold on;
ylabel('y_E (m)')
subplot(313);
plot(time, -aircraft_state_array(3,:), col); hold on;
ylabel('z_E  (m)')
xlabel('time (s)')
title(a,'Position')
hold off

figure(2)
hold on
b=subplot(311);
plot(time, aircraft_state_array(4,:)*180/pi, col); hold on;
ylabel('\phi (deg)')
subplot(312);
plot(time, aircraft_state_array(5,:)*180/pi, col); hold on;
ylabel('\theta (deg)')
subplot(313);
plot(time, aircraft_state_array(6,:)*180/pi, col); hold on;
ylabel('\psi (deg)')
xlabel('time (s)')
title(b,'Euler Angles')
hold off

figure(3)
hold on
c=subplot(311);
plot(time, aircraft_state_array(7,:), col); hold on;
ylabel('u^E (m/s)')
subplot(312);
plot(time, aircraft_state_array(8,:), col); hold on;
ylabel('v^E (m/s)')
subplot(313);
plot(time, aircraft_state_array(9,:), col); hold on;
ylabel('w^E (m/s)')
xlabel('time (s)')
title(c,'Inertial Velocity')
hold off

figure(4)
hold on
d=subplot(311);
plot(time, aircraft_state_array(10,:)*180/pi, col); hold on;
ylabel('p (deg/s)')
subplot(312);
plot(time, aircraft_state_array(11,:)*180/pi, col); hold on;
ylabel('q (deg/s)')
subplot(313);
plot(time, aircraft_state_array(12,:)*180/pi, col); hold on;
ylabel('r (deg/s)')
xlabel('time (s)')
title(d,'Angular Velocity')
hold off

figure(5)
hold on
e=subplot(411);
plot(time, control_input_array(1,:)*180/pi, col); hold on;
ylabel('\delta_e (deg)')
subplot(412);
plot(time, control_input_array(2,:)*180/pi, col); hold on;
ylabel('\delta_a (deg)')
subplot(413);
plot(time, control_input_array(3,:)*180/pi, col); hold on;
ylabel('\delta_r (deg)')
subplot(414);
plot(time, control_input_array(4,:), col); hold on;
ylabel('\delta_t')
xlabel('time (s)')
title(e,'Control Input Variables')
hold off

% V_B
tmpBodyVel = aircraft_state_array(7:9,:) - TransformFromInertialToBody(background_wind_array', aircraft_state_array(4:6));

% calculate wind angles
tmpAirVals = AirRelativeVelocityVectorToWindAngles(aircraft_state_array(7:9,:));

figure(6)
hold on
f=subplot(311);
plot(time, tmpAirVals(1,:), col); hold on;
ylabel('V (m/s)')
subplot(312);
plot(time, tmpAirVals(2,:)*180/pi, col); hold on;
ylabel('\beta (deg)')
subplot(313);
plot(time, tmpAirVals(3,:)*180/pi, col); hold on;
ylabel('\alpha (deg)')
xlabel('time (s)')
title(f,'Wind Angles')
hold off

figure(7)
hold on
plot3(aircraft_state_array(2,:),aircraft_state_array(1,:),-aircraft_state_array(3,:)); hold on;
plot3(aircraft_state_array(2,1),aircraft_state_array(1,1),-aircraft_state_array(3,1),'gO'); hold on;
plot3(aircraft_state_array(2,end),aircraft_state_array(1,end),-aircraft_state_array(3,end),'rO'); hold on;
grid on
xlabel('South to North')
ylabel('West to East')
zlabel('Up to Down')
title('Aircraft Flight Path')

end

