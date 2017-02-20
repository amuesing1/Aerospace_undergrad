% Eric W. Frew
% ASEN 3128
% RunSimLab5.m
% Created: 2/23/14
% Modified: 3/28/16
%  



close all;
clear all;
clc

%%% Defines geometry of the aircraft model being displayed
DefineDefaultAircraft;
DRAW_FLAG = 0;  % Setting this flag to 1 causes the Simulink model to animate the aircraft udring the simulation



%%% Defines mass parameters and aerodynamic coefficients of the aircraft
%%% being simulated
recuv_tempest;
% modeflier;
inertia_matrix = [aircraft_parameters.Ix 0 -aircraft_parameters.Ixz; 0 aircraft_parameters.Iy 0; -aircraft_parameters.Ixz 0 aircraft_parameters.Iz];


%%% STRAIGHT CLIMBING/DESCENDING FLIGHT
%%% Solve for new trim variables
V_trim = 22.0;
gamma_trim = 0*pi/180;
h_trim = 2438.5;
trim_definition = [V_trim; gamma_trim; h_trim];

[trim_variables, fval] = CalculateTrimVariables([V_trim; gamma_trim; h_trim], aircraft_parameters);


%%% *** Set the aircraft trim state and trim control surfaces from the trim
% definition and calculated trim variables. This might be a good place to
% make a new function. ***
aircraft_state0 = [0; 0; h_trim; 0; trim_variables(1); 0; V_trim; 0; 0; 0; 0; 0]; %STUDENT COMPLETED
control_surfaces0 = [trim_variables(2); 0; 0; trim_variables(3)]; %STUDENT COMPLETED



%%% Create linear matrices using new function written for this lab.
[Aad, Bad, Ayaw, Byaw] = AircraftLinearModel(aircraft_state0, control_surfaces0, aircraft_parameters);

%%% Determine eigenvalues and eigenvectors (mode shapes)
% LONGITUDINAL MODES
[Vad,Dad] = eig(Aad);
[freq_Dad,damp_Dad,pole_Dad] = damp(Dad); % Calculates and displays natural frequency and damping for all modes


min = 10000000;
max = 0;
for i = 1:length(Vad)
    if abs(Dad(i,i)) < min && abs(Dad(i,i)) > 0 && 0 ~= imag(Dad(i,i))
        min = abs(Dad(i,i));
        phugoid = Vad(:,i);
        phugoid_number = i;
    end
    if abs(Dad(i,i)) > max && 0 ~= imag(Dad(i,i))
        max = abs(Dad(i,i));
        short_response = Vad(:,i);
        short_response_number = i;
    end
    if 0 ~= real(Dad(i,i)) && 0==imag(Dad(i,i))
        height = Vad(:,i);
        height_number = i;
    end
end

% Phugoid
phugoid_natural_frequency = freq_Dad(phugoid_number);
phugoid_damping_ratio = damp_Dad(phugoid_number);
if phugoid_damping_ratio<1
    t_half_phugoid = .693/(abs(phugoid_damping_ratio)*phugoid_natural_frequency);
elseif phugoid_damping_ratio>1
    t_double_phugoid = .693/(abs(phugoid_damping_ratio)*phugoid_natural_frequency);
end

% Short Response
short_response_natural_frequency = freq_Dad(short_response_number);
short_response_damping_ratio = damp_Dad(short_response_number);
if short_response_damping_ratio<=1
    t_half_short_response = .693/(abs(short_response_damping_ratio)*short_response_natural_frequency);
elseif short_response_damping_ratio>1
    t_half_double_response = .693/(abs(short_response_damping_ratio)*short_response_natural_frequency);
end

% LATERAL MODES
[Vyaw,Dyaw] = eig(Ayaw);
[freq_Dyaw,damp_Dyaw,pole_Dyaw] = damp(Dyaw); % Calculates and displays natural frequency and damping for all modes

min = 10000000;
max = 0;
for i = 1:length(Vyaw)
    if 0 ~= imag(Dyaw(i,i))
        dutch = Vyaw(:,i);
        dutch_number = i;
    end
    if real(Dyaw(i,i))<0 && 0==imag(Dyaw(i,i))
        roll = Vyaw(:,i);
        roll_number = i;
    end
    if real(Dyaw(i,i))>0 && 0==imag(Dyaw(i,i))
        spiral = Vyaw(:,i);
        spiral_number = i;
    end
end

% dutch
dutch_natural_frequency = freq_Dyaw(dutch_number);
dutch_damping_ratio = damp_Dyaw(dutch_number);
if dutch_damping_ratio<1
    t_half_dutch = .693/(abs(dutch_damping_ratio)*dutch_natural_frequency);
elseif phugoid_damping_ratio>1
    t_double_dutch = .693/(abs(dutch_damping_ratio)*dutch_natural_frequency);
end

%%% Create a single dynamical system for simulation
Abig = [Aad zeros(6,6); zeros(6,6) Ayaw];
sysLin = ss(Abig, zeros(12,1), eye(12), 0);


%%%%%%%%%%%%%%%%%%%%%%%%
%%% *** Determine initial perturbation for simulation. Depending on the
%%% mode you wish to simulate, set x0_long or x0_lat to the real component
%%% of the appropriate eigenvector. The other term will be all zeros, e.g.
%%% when simulating the Short Period mode x0_lat = zeros(6,1). ***
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% STUDENTS COMPLETED
%% Long modes

x0_long=real(phugoid); %3a,b
% x0_long=real(short_response); %3c
% 
x0_lat = zeros(6,1);

%% Lat modes

% x0_lat=real(dutch); %4a
% x0_lat=real(spiral); %4b
% x0_lat=real(roll); %4d
% 
% x0_long = zeros(6,1);


x0big = [x0_long; x0_lat];


%%%
tfinal = 50;

%%%%%%%%%%%%%%%%%%%%%
%%% Linear simulation
%%%%%%%%%%%%%%%%%%%%%

[Y,T,X]=initial(sysLin, x0big, tfinal); % Runs simulation of linear system

X(1,4)=deg2rad(25); %scaling something


% *** Converts the linear simulation into the full state variables. Recall,
% the linear simulation just gives the perturbations, so they must be
% correctly added to the trim condition before plotting.
for i=1:length(T)
    aircraft_state_lin_array(:,i) = aircraft_state0 + [X(i,5);X(i,12);X(i,6);...
        X(i,10);X(i,4);X(i,11);X(i,1);X(i,7);X(i,2);X(i,8);X(i,3);X(i,9)]; %STUDENT COMPLETE BY ADDING PERTURBATIONS TO TRIM STATE
    aircraft_state_lin_array(1,i) = aircraft_state_lin_array(1,i) + V_trim*T(i)*cos(gamma_trim); % Adds pertubtation to trim x-position
    aircraft_state_lin_array(3,i) = aircraft_state_lin_array(3,i) - V_trim*T(i)*sin(gamma_trim); % Adds pertubtation to trim z-position
    control_surfaces_lin_array(:,i) = control_surfaces0;
end
PlotSimulation(T, aircraft_state_lin_array, control_surfaces_lin_array,[0;0;0]', 'r')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Full nonliner simulation (Simulink)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% *** Set initial state components. TO BE CONSISTENT WITH LINEAR SIMULATION
%%% THE FULL AIRCFRAFT STATE SHOULD BE INITIALIZED AS THE TRIM STATE PLUS
%%% INITIAL PERTURBATIONS, I.E. INITIAL CONDITIONS OF LINEAR SIMULATION.***
position_inertial = aircraft_state0(1:3,1) + [X(1,5);X(1,12);X(1,6)]; %STUDENT COMPLETED
euler_angles = aircraft_state0(4:6,1) + [X(1,10);X(1,4);X(1,11)]; %STUDENT COMPLETED
velocity_body = aircraft_state0(7:9,1) + [X(1,1);X(1,7);X(1,2)]; %STUDENT COMPLETED
omega_body = aircraft_state0(10:12,1)  + [X(1,8);X(1,3);X(1,9)]; %STUDENT COMPLETED


%%% Set trim values of control surfaces
control_surfaces_constant = control_surfaces0;

%%% Background wind
wind_inertial = [0;0;0];


%%% Run the model
sim('aircraft_simulation_env_subs',tfinal);

PlotSimulation(aircraft_state_array.time, aircraft_state_array.data', control_input_array.data', background_wind_array.data,'b--')