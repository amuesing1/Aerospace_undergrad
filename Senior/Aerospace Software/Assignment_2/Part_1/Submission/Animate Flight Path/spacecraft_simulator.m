function [end_time,y,IE] = spacecraft_simulator(dx,dy)
% spacecraft_simulator.m
% Aaron McCusker and Jeremy Muesing
%
% This function is used to find the trajectory of the astronauts as well as
% the moon during the simulation given delta Vx and delta Vy of the
% spacecraft at t0.
%
% Input:
% dx -- [dx, dy] = delta Vx [m/s]
% dy -- [dx, dy] = delta Vx [m/s]
%
% Output
% end_time -- Time of end of simulation [s]
% y(1) = X component of Spacecraft Velocity [m/s]
% y(2) = Y component of Spacecraft Velocity [m/s]
%
% y(3) = X component of Moon Velocity [m/s]
% y(4) = Y component of Moon Velocity [m/s]
%
% y(5) = X coordinate of Spacecraft position (Earth is origin) [m];
% y(6) = Y coordinate of Spacecraft position (Earth is origin) [m];
% 
% y(7) = X coordinate of Moon position (Earth is origin) [m];
% y(8) = Y coordinate of Moon position (Earth is origin) [m];
% 
% y(9) = X coordinate of Earth position [m]
% y(10) = Y coordinate of Earth position [m]


%% Assign Initial Coniditons
% Mass of moon, earth, and spacecraft
m_M = 7.34767309E22; % kg
m_E = 5.97219E24; % kg
m_S = 28833; % kg

% Distances between Earth and Spacecraft/Moon
d_ES = 340000000; % m
d_EM = 384403000; % m

% Universal Gravitational Constant
G = 6.674E-11;

% Flight path angles of spacecraft and Moon at t0
theta_M = 42.5; % deg
theta_S = 50; % deg;

% Velocity magnitudes of spacecraft and Moon at t0
v_S = 1000; % m/s
v_M = sqrt((G*m_E^2)/((m_E + m_M)*d_EM));

% Find X and Y coordinates of spacecraft at t0
x_S = d_ES*cosd(theta_S);
y_S = d_ES*sind(theta_S);
SC_Coord = [x_S, y_S];

% Find X and Y coordinates of Moon at t0
x_M = d_EM*cosd(theta_M);
y_M = d_EM*sind(theta_M);
Moon_Coord = [x_M, y_M];

% Designate X and Y coordinates of Earth at t0
x_E = 0;
y_E = 0;
Earth_Coord = [x_E, y_E];

% Find moon velocity components at t0
v_Mx = -v_M*sind(theta_M);
v_My = v_M*cosd(theta_M);
Moon_Vel = [v_Mx, v_My];

% Find velocity of spacecraft at t0 using the delta Vx and delta Vy passed
% in with the function
v_Sx = v_S*cosd(theta_S) + dx;
v_Sy = v_S*sind(theta_S) + dy;

SC_Vel = [v_Sx, v_Sy];

% Create the y vector for use in ODE45
y(1) = SC_Vel(1);
y(2) = SC_Vel(2);

y(3) = Moon_Vel(1);
y(4) = Moon_Vel(2);

y(5) = SC_Coord(1);
y(6) = SC_Coord(2);

y(7) = Moon_Coord(1);
y(8) = Moon_Coord(2);

y(9) = Earth_Coord(1);
y(10) = Earth_Coord(2);

% Set ODE options
options = odeset('Events',@Event_Check,'RelTol',1E-6);

% Run ode45 to find time at which sim ends and status of astronauts at sim
% end
[~,y,end_time,~,IE]=ode45(@(t,y) odefcn(t,y,m_S,m_M,m_E),[0 2.628E10],[v_Sx,v_Sy,v_Mx,v_My,x_S,y_S,x_M,y_M,x_E,y_E],options);

end

