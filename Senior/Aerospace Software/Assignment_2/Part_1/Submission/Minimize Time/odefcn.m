function d_everything = odefcn(~,y,m_S,m_M,m_E)
% odefcn.m
% Aaron McCusker and Jeremy Muesing
%
% This function is called to run ODE45 in the spacecraft simulation
%
% Input:
% y:
% SC_Vel_x = y(1)
% SC_Vel_y = y(2)
% 
% Moon_Vel_x = y(3)
% Moon_Vel_y = y(4)
% 
% SC_Coord_x = y(5)
% SC_Coord_y = y(6)
% 
% Moon_Coord_x = y(7)
% Moon_Coord_y = y(8)
% 
% Earth_Coord_x = y(9)
% Earth_Coord_y = y(10)
%
% m_S -- mass of spacecraft [kg]
% m_M -- mass of moon [kg]
% m_E -- mass of earth [kg]
%
% Output
% d_everything -- rate of change of all objects within y (input)

% Define d_everything so it isn't changing sizes all over the place
d_everything = zeros(10,1);

% Find forces between all relevant objects
F_MS = force_g([y(7),y(8)],[y(5),y(6)],m_M,m_S); % N
F_ES = force_g([y(9),y(10)],[y(5),y(6)],m_E,m_S); % N
F_EM = force_g([y(9),y(10)],[y(7),y(8)],m_E,m_M); % N
F_SM = force_g([y(5),y(6)],[y(7),y(8)],m_S,m_M); % N

% Assign acceleration as rate of change of velocity of spacecraft
d_everything(1) = (F_MS(1) + F_ES(1))/m_S;
d_everything(2) = (F_MS(2) + F_ES(2))/m_S;

% Assign acceleration as rate of change of velocity of moon
d_everything(3) = (F_EM(1) + F_SM(1))/m_M;
d_everything(4) = (F_EM(2) + F_SM(2))/m_M;

% Assign velocity of spacecraft as rate of change of position
d_everything(5) = y(1);
d_everything(6) = y(2);

% Assign velocity of moon as rate of change of position
d_everything(7) = y(3);
d_everything(8) = y(4);

end