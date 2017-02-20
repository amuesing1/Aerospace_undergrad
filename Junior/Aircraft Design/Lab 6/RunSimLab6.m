% Eric W. Frew & Nisar Ahmed
% ASEN 3128
% RunSimLab6.m
% Created: 3/27/16
%  
% This is a template file that students can use to complete Lab 6
%

close all;
clear all;

%%% Defines geometry of the aircraft model being displayed
DefineDefaultAircraft;
DRAW_FLAG = 0;

%%% Defines mass parameters and aerodynamic coefficients of the aircraft
%%% being simulated
recuv_tempest;

inertia_matrix = [aircraft_parameters.Ix 0 -aircraft_parameters.Ixz; 0 aircraft_parameters.Iy 0; -aircraft_parameters.Ixz 0 aircraft_parameters.Iz];


%%% STRAIGHT CLIMBING/DESCENDING FLIGHT
%%% Solve for new trim variables
V_trim = 21;
gamma_trim = 0*pi/180;
h_trim = 1609.34;
trim_definition = [V_trim; gamma_trim; h_trim];

[trim_variables, fval] = CalculateTrimVariables([V_trim; gamma_trim; h_trim], aircraft_parameters);

%%% *** Set the aircraft trim state and trim control surfaces from the trim
% definition and calculated trim variables. 

position_inertial = [0;0;-h_trim];
euler_angles = [0; gamma_trim + trim_variables(1); 0];

velocity_air_body =  [0;0;0]; 
% corrects for background wind
 velocity_inertial = WindAnglesToAirRelativeVelocityVector(...
     [V_trim,0,trim_variables(1)]);
velocity_body = velocity_air_body + velocity_inertial;
omega_body = [0;0;0];

aircraft_state0 = [position_inertial;...
          euler_angles; 
          velocity_body; omega_body];

control_surfaces0 = [trim_variables(2); 0; 0; trim_variables(3)]; %STUDENT COMPLETE

%%%Students need to modify function to compute Bad and Byaw using 
%%appropriate control derivatives
%%--> validate modified function with test code provided
[Aad, Bad, Ayaw, Byaw] = AircraftLinearModel(aircraft_state0, control_surfaces0, aircraft_parameters);

%%%Find natural frequencies of phugoid and short period
%%%(may need to use some other functions to compute these)
%%Find Phugoid natural frequency (rad/s):

[Vad, Dad] = eig(Aad);
[freq_Dad, damp_Dad, pole_Dad] = damp(Dad);

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

wn_phug = phugoid_natural_frequency;
z_phug = phugoid_damping_ratio;
%%Find Short period natural frequency (rad/s):
wn_short = short_response_natural_frequency;
z_short = short_response_damping_ratio;

Abig = [Aad zeros(6,6); zeros(6,6) Ayaw];
Bbig = [Bad zeros(6,2); zeros(6,2) Byaw];

%%Set up linear system for simulation
sysLin = ss(Abig, Bbig, eye(12), zeros(12,4));

%%ICs: students complete
x0_long = zeros(6,1);
x0_lat = zeros(6,1);

%%Lump together IC's for augmented long and lat states
x0big = [x0_long; x0_lat];


%%%Set up simulation time vector
tfinal = 100; 
timeVec = 0:0.005:tfinal;

%% Linear simulations: replace with lsim
%%*****Q2 a-b: simulate 10 degree step elevator input response
%%Q2a: Matrix FVT prediction for steady state values
new_Aad=[Aad(1:4,1:4), Aad(1:4,6); Aad(6,1:4), Aad(6,6)];
new_Bad=[Bad(1:4,1); Bad(6,1)];
xss = [-inv(new_Aad)*new_Bad]; %students complete

% %%Q2b: Construct time series for signal in linear model:
% %%This is an example of how to construct a step function input for lsim
% tstep = 1; %offset delay time for step onset (can adjust here and in simulink model)
% stepVal = 10*pi/180; %step amplitude from degs to rads
% dElevator = stepVal*double(timeVec>=tstep);
% dAileron = zeros(1,length(timeVec));
% dRudder = zeros(1,length(timeVec));
% dThrust = zeros(1,length(timeVec));

% %%*****Q2 c-d: simulate 0.1 throttle step input response
% %%Q2c: Matrix FVT prediction for steady state values
% new_Bad=[Bad(1:4,2); Bad(6,2)];
% xss = [-inv(new_Aad)*new_Bad]; %students complete

%%Q2d: Construct time series for signal in linear model 
% tstep = 1; %offset delay time for step onset (can adjust here and in simulink model)
% stepVal = 0.1; %step amplitude
% dElevator = zeros(1,length(timeVec));
% dAileron = zeros(1,length(timeVec));
% dRudder = zeros(1,length(timeVec));
% dThrust = stepVal*double(timeVec>=tstep);

% %%*****Q3 a-b: simulate sine wave input response
% %%Q3a: Determine TFs from elevator angle to pitch rate and height
% %%Compute TFs from dElevator to all outputs
% [num_e,den_e] = ss2tf(Abig,Bbig,eye(12),zeros(12,4),1); %students complete
% tf_eq = tf(num_e(3,:),den_e); %%pull appropriate terms from num_e and den_e to build tf from elevator to q (students complete)
% tf_eh = tf(num_e(6,:),den_e); %%ditto for elevator to height (students complete)
% 
% %generate Bode plots for tf_eq and tf_eh
% figure(6)
% bode(tf_eq,tf_eh);
% 
% %Q3b: Construct sinusoidal time series for signal in linear model
% tstep = 1; %offset delay time for step onset (can adjust here and in simulink model)
% stepVal = 5*pi/180; %step amplitude from degs to rads
% dElevator = stepVal*sin((phugoid_natural_frequency/10)*timeVec);
% dAileron = zeros(1,length(timeVec));
% dRudder = zeros(1,length(timeVec));
% dThrust = zeros(1,length(timeVec));


%*****Q4: Coordinated turn: coupling b/w long and lat inputs/dynamics
%Q4a: Find turn rate omega for turn radius of 600 m 
R=600*3.28084; %meters to feet for found equation
V_trim_calc=V_trim*1.94384;
phi=atan2(V_trim_calc^2,11.26*R); %in rad
omega=(1091*tan(phi))/V_trim_calc;

%Q4b: Determine sideslip, angle of attack, elevator, aileron and rudder
%required for turn in Q4a with zero flight path angle and roll of 20 degs
[Beta,deltar,deltaa,delta_alpha,delta_deltae] = unknown_vars(aircraft_state0, aircraft_parameters, 20, omega, gamma_trim );
delta_deltae=deg2rad(delta_deltae);
delta_alpha=deg2rad(delta_alpha);
tstep = 1; %offset delay time for step onset (can adjust here and in simulink model)
dElevator = delta_deltae*double(timeVec>=tstep);
dAileron = zeros(1,length(timeVec));
dRudder = zeros(1,length(timeVec));
dThrust = zeros(1,length(timeVec));
control_surfaces0=control_surfaces0+[0;deltaa;deltar;0];
aircraft_state0=aircraft_state0+[0;0;0;0;delta_alpha;Beta;0;0;0;0;0;0];

%%Collect perturbed control inputs:
uDelta = [dElevator; dThrust; dAileron; dRudder;]';
uDelta_arrage= [dElevator; dAileron; dRudder; dThrust;];

%%Compute linear simulation with control inputs changing over time:
[Y,T,X]=lsim(sysLin, uDelta, timeVec, x0big);
deltaX(1,:)=Y(:,5);
deltaX(2,:)=Y(:,12);
deltaX(3,:)=Y(:,6);
deltaX(4,:)=Y(:,10);
deltaX(5,:)=Y(:,4);
deltaX(6,:)=Y(:,11);
deltaX(7,:)=Y(:,1);
deltaX(8,:)=Y(:,7);
deltaX(9,:)=Y(:,2);
deltaX(10,:)=Y(:,8);
deltaX(11,:)=Y(:,3);
deltaX(12,:)=Y(:,9);


%%%Students complete: Rearrange resulting states to plot against full nonlinear a/c model:
for i=1:length(T)
    aircraft_state_lin_array(:,i) = aircraft_state0 + deltaX(:,i);
    aircraft_state_lin_array(1,i) = aircraft_state_lin_array(1,i) + V_trim*T(i)*cos(gamma_trim); %moving a/c forward
    aircraft_state_lin_array(3,i) = aircraft_state_lin_array(3,i) - V_trim*T(i)*sin(gamma_trim); %moving a/c height 
    control_surfaces_lin_array(:,i) = control_surfaces0 + uDelta_arrage(:,i); %students complete: control is trim + input perturbations
end
PlotSimulation(T, aircraft_state_lin_array, control_surfaces_lin_array,[0;0;0], 'r')


%% Compare to full nonlinear system reponse
%% Set initial state components:
%%NOTE: MUST ADD BACK PERTURBATION IC'S TO TRIM IC'S OF USUAL FULL A/C STATES!
position_inertial = aircraft_state0(1:3,1) + [x0big(5),x0big(12),x0big(6)]';
euler_angles = aircraft_state0(4:6,1) + [x0big(10),x0big(4),x0big(11)]'; 
velocity_body = aircraft_state0(7:9,1) + [x0big(1),x0big(7),x0big(2)]'; 
omega_body = aircraft_state0(10:12,1)  + [x0big(8),x0big(3),x0big(9)]'; 
%%% Set trim values of control surfaces

control_surfaces_constant = control_surfaces0;

%%% Background wind
wind_inertial = [0;0;0];


%%% Run the model: 
%%STUDENTS: MAKE SURE INPUT SIGNALS IN SIMULINK MODEL ARE CORRECT! 
sim('aircraft_controls',tfinal);

PlotSimulation(aircraft_state_array.time, aircraft_state_array.data', squeeze(control_input_array.data), background_wind_array.data,'b--')
figure(7), legend('linear approx sim','lin start','lin end',...
                  'full nonlinear sim','nonlin start','nonlin end');