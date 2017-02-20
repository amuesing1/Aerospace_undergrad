% Eric W. Frew
% ASEN 3128
% RunSimLab7.m
% Revised: 4/10/2016 (Nisar Ahmed)
% Revised: 4/26/2016 (Jeremy Muesing)
% This is a template that students can use to complete Lab 6. 
%
%

close all;
clear all;
clc

DRAW_FLAG = 0;


%%% Defines mass parameters and aerodynamic coefficients of the aircraft
%%% being simulated
recuv_tempest;
inertia_matrix = [aircraft_parameters.Ix 0 -aircraft_parameters.Ixz; 0 aircraft_parameters.Iy 0; -aircraft_parameters.Ixz 0 aircraft_parameters.Iz];


%%% STRAIGHT CLIMBING/DESCENDING FLIGHT
%%% Solve for new trim variables
V_trim = 21;
gamma_trim = 0;
h_trim = 1600; %[1 mile!];
trim_definition = [V_trim; gamma_trim; h_trim];

[trim_variables, fval] = CalculateTrimVariables([V_trim; gamma_trim; h_trim], aircraft_parameters);

% Helper function that uses trim_definition and trim_variables to calculate
% the trim condition, ie the trim state and control input vector
[aircraft_state0, control_surfaces0] = trimVarDefToAircraftState(trim_variables, trim_definition);

%%% Linear system matrices and models for simulation
%[Aad, Bad, Ayaw, Byaw] = AircraftLinearModel_lab7_2015(aircraft_state0, control_surfaces0, aircraft_parameters);
[Aad, Bad, Ayaw, Byaw] = AircraftLinearModel(aircraft_state0, control_surfaces0, aircraft_parameters);

Abig = [Aad zeros(6,6); zeros(6,6) Ayaw];
Bbig = [Bad zeros(6,2); zeros(6,2) Byaw];
[Vad,Dad] = eig(Aad);
[Vyaw,Dyaw] = eig(Ayaw);
x0big = zeros(12,1); %legacy from Lab 5, initializing everything at trim for this Lab

% Define different B matrices depending on which input is used
B_Elev = Bad(:,1); %students complete
B_Aileron = Byaw(:,2);
B_Rudder = Byaw(:,1);
B_Throttle = Bad(:,2);

%%
%%%%%%%%%%%%%%%%%%%%%%%
%%% 1. Pitch Attitude Control

%%PART A.: linear model design 
%%derive transfer function for linear model response
[numP, denP] = ss2tf(Aad,Bad,eye(6),zeros(6,2),1); %students complete
numP=numP(4,:);
% G=tf(numP,denP);



%%% select PID gains for simulink simulation 
%%% (pick signs carefully to ensure stable closed loop poles!)
kp = -2; %students complete: needs to be tuned!!
ki = -9;
kd = 7;

% finding roots manually to confirm all are negative for stable response
PID=[kd,kp,ki];
num=conv(PID,numP);
part1=conv([1,0],denP);
part2=conv(PID,numP);
den=part1+part2(2:end);
transfer=tf(num,den);
r=roots(den);


theta_com = .5*pi/180; %%commanded theta step value (rads)

%%simulate linear model closed loop response 
%%using appropriate transfer fxns in simulink
tfinal = 50;
T = [0:0.025:tfinal];
sim('linear_pitch_att_control_R2015a',T);

%%plot linear model closed-loop response
figure(10);
subplot(211);
plot(theta.time, theta.data*180/pi+aircraft_state0(5), 'b');hold on;
plot([0 tfinal], theta_com*(180/pi)*[1 1]+aircraft_state0(5),'r--');
xlabel('Time (s)')
ylabel('\Theta Pitch response (deg)')
subplot(212);
plot(elev.time, elev.data*180/pi, 'b');hold on;
xlabel('Time (s)')
ylabel('Elevator response (deg)')

%%PART B: nonlinear model comparison
%%% Set initial state components
position_inertial = aircraft_state0(1:3,1) + [x0big(5); x0big(12); x0big(6)];
euler_angles = aircraft_state0(4:6,1) + [x0big(10); x0big(4); x0big(11)];
velocity_body = aircraft_state0(7:9,1) + [x0big(1); x0big(7); x0big(2)];
omega_body = aircraft_state0(10:12,1)  + [x0big(8); x0big(3); x0big(9)];


%%% Set trim values of control surfaces
control_surfaces_trim = control_surfaces0;

elev_step_time  = 0;
elev_step_value = 0;

aileron_step_time  = 0;
aileron_step_value = 0;

rudder_step_time  = 0;
rudder_step_value = 0;

throttle_step_time  = 0;
throttle_step_value = 0;


%%% Background wind
wind_inertial = [0;0;0];

%%% Run the full nonlinear model with PID feedback control
sim('aircraft_feedback_control_R2015a',T);

% PlotSimulation(aircraft_state_array.time, aircraft_state_array.data', control_input_array.data', 'b--');

%%plot nonlinear model closed-loop response
figure(10);
subplot(211);
plot(aircraft_state_array.time, aircraft_state_array.data(:,5)*180/pi, 'g--');hold on;
subplot(212);
plot(aircraft_state_array.time, -control_input_array.data(:,1)*180/pi, 'g--');hold on;

%%
%%%%%%%%%%%%%%%%%%%%%%%
%%% 2. Speed and Flight Path Control

%%PART A.: linear model design 
%%derive the appropriate transfer functions for linear model response
%(need to account for response of speed to both de and dt and 
%                     response of flight path angle to both de and dt)

% C2 = [0 -1/V_trim 0 1]; %not used/does nothing
[numPde, denPde] = ss2tf(Aad,B_Elev,eye(6),zeros(6,1),1); %students complete
[numPdt, denPdt] = ss2tf(Aad,B_Throttle,eye(6),zeros(6,1),1);


% making transfer function numerators from arrays
numP_u_from_de=numPde(1,:);
numP_gamma_from_de=numPde(4,:)-numPde(2,:)/V_trim;
numP_u_from_dt=numPdt(1,:);
numP_gamma_from_dt=numPdt(4,:)-numPdt(2,:)/V_trim;

%%% i. select PD gains for speed controller 
%%% (pick signs carefully to ensure stable closed loop poles!)
kpu = [.3] ; %students complete: needs to be tuned!!
kiu = [.5] ;
kdu = [0] ;
u_com = 1; %%commanded theta step value (m/s) [can use different values]

%%% ii. select PID gains for flight path angle controller
%%% (pick signs carefully to ensure stable closed loop poles!)
kpg = [1]; %students complete: needs to be tuned!!
kdg = [.4]; 
kig = [.2];
gamma_com = 2*pi/180;% 0%  %%commanded theta step value (deg to rads) [can use different values]

%%simulate linear model closed loop response 
%%using appropriate transfer fxns in simulink
tfinal = 60;
T = 0:.025:tfinal;
sim('linear_speed_control_R2015a',T); %%students complete: come up with new simulink model for linear part
%%plot linear model closed-loop response
figure(11);clf;
subplot(211);
plot(throt.time, throt.data, 'b');hold on;
plot([0 tfinal], u_com*[1 1],'r--');
xlabel('Time (s)')
ylabel('Throttle response (m/s)')
subplot(212);
plot(gamma.time, gamma.data*180/pi+gamma_trim, 'b');hold on;
plot([0 tfinal], gamma_trim+gamma_com*(180/pi)*[1 1],'r--');
xlabel('Time (s)')
ylabel('\gamma response (deg)')



%%PART B: nonlinear model comparison
%%% Set initial state components
position_inertial = aircraft_state0(1:3,1) + [x0big(5); x0big(12); x0big(6)];
euler_angles = aircraft_state0(4:6,1) + [x0big(10); x0big(4); x0big(11)];
velocity_body = aircraft_state0(7:9,1) + [x0big(1); x0big(7); x0big(2)];
omega_body = aircraft_state0(10:12,1)  + [x0big(8); x0big(3); x0big(9)];


%%% Set trim values of control surfaces
control_surfaces_trim = control_surfaces0;

elev_step_time  = 0;
elev_step_value = 0;

aileron_step_time  = 0;
aileron_step_value = 0;

rudder_step_time  = 0;
rudder_step_value = 0;

throttle_step_time  = 0;
throttle_step_value = 0;


%%% Background wind
wind_inertial = [0;0;0];

%%% Run the full nonlinear model with PD speed and PID flight path angle feedback control
sim('aircraft_feedback_control_R2015a_prob_2',T); %students complete
% 
% % PlotSimulation(aircraft_state_array.time, aircraft_state_array.data', control_input_array.data', 'b--');
% 
%%plot nonlinear model closed-loop response
figure(11);
subplot(211);
plot(aircraft_state_array.time, aircraft_state_array.data(:,4)*180/pi-(aircraft_state_array.data(:,2)*180/pi)/V_trim, 'g--');hold on;
subplot(212);
plot(aircraft_state_array.time, aircraft_state_array.data(:,1)*180/pi, 'g--');hold on;

%%
%%%%%%%%%%%%%%%%%%%%%%%
%%% 3. Yaw Damper
[numPdr, denPdr] = ss2tf(Ayaw,B_Rudder,eye(6),zeros(6,1),1);

% graph the root locus plot in order to investigate roots
figure(25)
rlocus(-numPdr(3,:),denPdr)
% find numerical transfer funciton
numP_r_from_dr=numPdr(3,:);

% proportional gain
kpr = [-7] ;

% yaw rate impulse
yaw_com =5*pi/180; %rad/sec

tfinal = 25;
T = 0:.025:tfinal;
sim('linear_yaw_control_R2015a',T);

%%plot linear model closed-loop response
figure(12);clf;
subplot(211);
plot(yaw_rate.time, yaw_rate.data*180/pi, 'b');hold on;
xlabel('Time (s)')
ylabel('r response (deg/sec)')
subplot(212);
plot(rudder.time, rudder.data*180/pi, 'b');hold on;
xlabel('Time (s)')
ylabel('Rudder response (deg)')

%% Part B

% setting the frequency value to pass through
a=50;
sim('linear_yaw_control_R2015a_part_b',T);

figure(12);
subplot(211);
plot(yaw_rate.time, yaw_rate.data*180/pi, 'c');hold on;
subplot(212);
plot(rudder.time, rudder.data*180/pi, 'c');hold on;


%% Part C

%%% Set initial state components
position_inertial = aircraft_state0(1:3,1) + [x0big(5); x0big(12); x0big(6)];
euler_angles = aircraft_state0(4:6,1) + [x0big(10); x0big(4); x0big(11)];
velocity_body = aircraft_state0(7:9,1) + [x0big(1); x0big(7); x0big(2)];
omega_body = aircraft_state0(10:12,1)  + [x0big(8); x0big(3); x0big(9)];


%%% Set trim values of control surfaces
control_surfaces_trim = control_surfaces0;

elev_step_time  = 0;
elev_step_value = 0;

aileron_step_time  = 0;
aileron_step_value = 0;

rudder_step_time  = 0;
rudder_step_value = 0;

throttle_step_time  = 0;
throttle_step_value = 0;


%%% Background wind
wind_inertial = [0;0;0];

%% Run the full nonlinear model with PD speed and PID flight path angle feedback control
sim('aircraft_feedback_control_R2015a_prob_3',T); %students complete
figure(12);
subplot(211);
plot(aircraft_state_array.time, aircraft_state_array.data(:,12)*180/pi, 'g--');hold on;
legend('non damped','damped','nonlinear');
subplot(212);
plot(aircraft_state_array.time, control_input_array.data(:,3)*180/pi, 'g--');hold on;
legend('non damped','damped','nonlinear');

%%
% %%%%%%%%%%%%%%%%%%%%%%%
% %%% 4. Roll Control
% [numPdr, denPdr] = ss2tf(Ayaw,B_Rudder,eye(6),zeros(6,1),1);
% [numPda, denPda] = ss2tf(Ayaw,B_Aileron,eye(6),zeros(6,1),1);
% 
% 
% numP_p_from_dr=numPdr(2,:);
% numP_r_from_dr=numPdr(3,:);
% numP_phi_from_dr=numPdr(4,:);
% numP_p_from_da=numPda(2,:);
% numP_r_from_da=numPda(3,:);
% numP_phi_from_da=numPda(4,:);
% 
% kpr = [-7] ;
% kpu = [0] ;
% kdu = [0] ;
% kiu = [0] ;
% 
% kpa = [0] ;
% kda = [0] ;
% kia = [0] ;
% 
% 
% phi_com = 5*pi/180; %rad
% 
% tfinal = 100;
% T = 0:.025:tfinal;
% sim('linear_roll_control_R2015a',T);
% 
% %%plot linear model closed-loop response
% figure(13);
% subplot(211);
% plot(roll_rate.time, roll_rate.data*180/pi, 'b');hold on;
% xlabel('Time (s)')
% ylabel('p response (deg/sec)')
% subplot(212);
% plot(rudder.time, rudder.data*180/pi, 'b');hold on;
% xlabel('Time (s)')
% ylabel('\phi response (deg)')
