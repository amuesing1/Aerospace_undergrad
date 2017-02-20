%% Anthony Torres
% ASEN 3128 - 011
% CalculateSteadyTrim.m
% Lab 4
% Created: 2/22/16
% Modified: 2/22/16

function [alpha_trim, elev_trim] = CalculateSteadyTrim( h0, u0, aircraft_parameters )
%
% Inputs:
%    h0 = trim height (m)
%    u0 = trim body x component of velocity (m/s)
%    aircraft_parameters = aircraft parameters defined for specific
%         aircraft
%
% Outputs:
%    alpha_trim = required angle of attack for trim with given conditions
%    elev_trim = required elevator deflection for trim with given
%                 conditions
%

% Redefine aircraft_parameters to ap for easy assignments
ap = aircraft_parameters;
W = ap.W; %N
S = ap.S; %m^2
rho = stdatmo(h0);

%Define needed variables
C_l_trim = W ./ (.5*rho*u0^2*S);
C_l_delta_e =  ap.CLde;  
C_l_alpha = ap.CLalpha;
C_m_alpha = ap.Cmalpha;
C_m_delta_e = ap.Cmde;
C_m_0 = ap.Cm0;


delta = C_l_alpha *C_m_delta_e - C_l_delta_e*C_m_alpha;
%Answer
alpha_trim =  (C_m_0 * C_l_delta_e + C_m_delta_e * C_l_trim)/delta;
elev_trim = -(C_m_0 * C_l_alpha + C_m_alpha *C_l_trim) / delta;


end