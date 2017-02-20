% Chris Choate
% ASEN 3128
% S_AeroForcesAndMoments.m
% Created: 2/8/16
% Modified: 2/8/16

function [force_moment_vec] = S_AeroForcesAndMoments(u, aircraft_parameters)
% Inputs:
% u = Vector denoting aircraft state and control inputs [16 x 1]
% aircraft_paramters = Structure Containing 44 Aircraft Parameters
%
% Outputs:
% force_moment_vec = Vector indicating Forces/Moments [6 x 1]
%
% Purpose:
% This is a wrapper function for
% AeroForcesAndMoments_BodyState_WindCoeffs.m and should be in the same
% folder path as it


% Divide u to known terms
aircraft_state  = u(1:12,1);
aircraft_surfaces  = u(13:16,1);

% Call AeroForcesAndMoments_BodyState_WindCoeffs.m
[aero_forces, aero_moments] = AeroForcesAndMoments_BodyState_WindCoeffs(aircraft_state, aircraft_surfaces, aircraft_parameters);

force_moment_vec = [aero_forces; aero_moments];

end