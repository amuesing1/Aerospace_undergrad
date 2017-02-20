% Eric W. Frew
% ASEN 3128
% RunSimLab4.m
% Created: 2/23/14
% Modified: 2/19/16
%  
% This is a template that students can use to complete Lab 4. 
%
% This script WILL NOT WORK until you have created all assignment
% functions. This code also uses a helper function called 
% TrimConditionFromDefinitionAndVariables.m which is not required 
% by the assignemt, but is recommended 
%

close all;
clear all;


%%% Defines geometry of the aircraft model being displayed
DefineDefaultAircraft;


%%% Defines mass parameters and aerodynamic coefficients of the aircraft
%%% being simulated

modeflier
%recuv_tempest;

inertia_matrix = [aircraft_parameters.Ix 0 -aircraft_parameters.Ixz; 0 aircraft_parameters.Iy 0; -aircraft_parameters.Ixz 0 aircraft_parameters.Iz];

%%% Background wind
wind_inertial = [10;10;0];

%%% STRAIGHT CLIMBING/DESCENDING FLIGHT
%%% Solve for new trim variables
V_trim = 21.0; %aircraft_parameters.u0;
gamma_trim = 0*pi/180;
gamma_a_trim=0*pi/180;
h_trim = 1609.34;
trim_definition = [V_trim; gamma_a_trim; h_trim];

% Returns the trim angle of attack, elevator and throttle
[trim_variables, fval] = CalculateTrimVariables([V_trim; gamma_a_trim; h_trim], aircraft_parameters);



%%% Set initial state components
position_inertial = [0;0;-h_trim];
euler_angles = [0;trim_variables(1)+gamma_a_trim;0];

velocity_air_body = WindAnglesToAirRelativeVelocityVector([V_trim;0;trim_variables(1)]);
%4b
velocity_body = velocity_air_body;
%4c
% velocity_body = velocity_air_body + TransformFromInertialToBody(wind_inertial, euler_angles);

omega_body = [0; 0; 0];

%4d
% course_angle=60;
% unknown_angle=0;
% for i=-pi:0.001:pi
%     euler_angles(3)=i;
%     course_angle_compare=unknown_angle+rad2deg(euler_angles(3));
%     if abs(course_angle_compare-course_angle)>=.1
%         velocity_air_body_inertial=TransformFromBodyToInertial(velocity_air_body, euler_angles);
%         velocity_body_inertial=velocity_air_body_inertial+wind_inertial;
%         mag_vel_body_inertial=norm(velocity_air_body_inertial);
%         mag_vel_inertial=norm(velocity_body_inertial);
%         mag_wind=norm(wind_inertial);
%         unknown_angle=acosd((mag_wind^2-mag_vel_body_inertial^2-mag_vel_inertial^2)/(-2*mag_vel_body_inertial*mag_vel_inertial));
%     else
%         true_angle=euler_angles(3);
%     end
% 
% end
% euler_angles(3)=true_angle;
% velocity_body = velocity_air_body + TransformFromInertialToBody(wind_inertial, euler_angles);

%%% Set trim values of control surfaces
control_surfaces_constant = [trim_variables(2); 0; 0; trim_variables(3)];


%%% Run the model
tfinal=150;
tstep=.1;
sim('aircraft_simulation_env',[0:tstep:tfinal]);

PlotSimulation(aircraft_state_array.time, aircraft_state_array.data', control_input_array.data', background_wind_array.data, 'b')