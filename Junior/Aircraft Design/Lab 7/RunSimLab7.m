% Eric W. Frew
% ASEN 3128
% RunSimLab7.m
% Revised: 4/10/2016 (Nisar Ahmed)
%  
% This is a template that students can use to complete Lab 6. 
%
%
% 1. delete blocks of code below for part 1

close all;
clear all;
clc

% Plotting Specifications
  line_width = 2;
  font_size  = 18;
  mkr_size   = 8;
  set(0,'DefaultLineLineWidth' ,line_width);
  set(0,'DefaultAxesFontSize'  ,font_size);
  set(0,'DefaultLineMarkerSize',mkr_size);

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
plot(aircraft_state_array.time, control_input_array.data(:,1)*180/pi, 'g--');hold on;

%%
%%%%%%%%%%%%%%%%%%%%%%%
%%% 2. Speed and Flight Path Control

%%PART A.: linear model design 
%%derive the appropriate transfer functions for linear model response
%(need to account for response of speed to both de and dt and 
%                     response of flight path angle to both de and dt)

C2 = [1 0 0 0 0 0;
      0 -1/V_trim 0 1 0 0];

[numPde, denPde] = ss2tf(Aad, B_Elev, C2, zeros(2,1)); %students complete
[numPdt, denPdt] = ss2tf(Aad, B_Throttle, C2, zeros(2,1));
%%...make sure these TFs get picked up in a NEW simulink model
numUe = numPde(1,:);
numGe = numPde(2,:);
numUt = numPdt(1,:);
numGt = numPdt(2,:);
%%% i. select PD gains for speed controller 
%%% (pick signs carefully to ensure stable closed loop poles!)
kpu = 1; %students complete: needs to be tuned!!
kdu = 1;
kiu = 1;
u_com = 1; %%commanded theta step value (m/s) [can use different values]

%%% ii. select PID gains for flight path angle controller
%%% (pick signs carefully to ensure stable closed loop poles!)
kpg = 1; %students complete: needs to be tuned!!
kdg = 1; 
kig = 1;
gamma_com = 1*pi/180; % commanded gamma step value (deg to rads) [can use different values]

%%simulate linear model closed loop response 
%%using appropriate transfer fxns in simulink
tfinal = 50;
T = 0:.025:tfinal;
sim('linear_speed_gamma_control',T); %%students complete: come up with new simulink model for linear part

%%plot linear model closed-loop response
figure(11);clf;
subplot(211);
plot(u.time, u.data, 'b');hold on;
plot([0 tfinal], u_com*[1 1],'r--');
xlabel('Time (s)')
ylabel('Speed (m/s)')
subplot(212);
plot(gamma.time, gamma.data*180/pi+gamma_trim, 'b');hold on;
plot([0 tfinal], gamma_trim+gamma_com*(180/pi)*[1 1],'r--');
xlabel('Time (s)')
ylabel('\gamma response (deg)')

% figure(11);clf;
% subplot(3,1,1);
% plot(u.time, u.data, 'b');hold on;
% plot([0 tfinal], u_com*[1 1],'r--');
% xlabel('Time (s)')
% ylabel('U response')
% subplot(3,1,2);
% plot(gamma.time, gamma.data*180/pi, 'b');hold on;
% plot([0 tfinal], gamma_com*(180/pi)*[1 1],'r--');
% xlabel('Time (s)')
% ylabel('Gamma (deg)')
% subplot(3,1,3);
% plot(throttle.time, throttle.data, 'b');hold on;
% xlabel('Time (s)')
% ylabel('Throttle response')

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
sim('aircraft_feedback_control_R2015a_prob_2',T) %students complete

% PlotSimulation(aircraft_state_array.time, aircraft_state_array.data', control_input_array.data', 'b--');

%%plot nonlinear model closed-loop response
%%...students complete
non_lin_u = aircraft_state_array.data(:,7) - V_trim;
non_lin_gamma = aircraft_state_array.data(:, 5)*180/pi - atan2d(aircraft_state_array.data(:, 9), aircraft_state_array.data(:, 7));

figure(11);
subplot(211);
plot(aircraft_state_array.time, non_lin_u, 'g--');hold on;
subplot(212);
plot(aircraft_state_array.time, non_lin_gamma, 'g--');hold on;

%%
%%%%%%%%%%%%%%%%%%%%%%%
%%% 3. Yaw Damper
[numPdr, denPdr] = ss2tf(Ayaw,B_Rudder,eye(6),zeros(6,1),1);

figure(25)
rlocus(-numPdr,denPdr)
numP_r_from_dr=numPdr(3,:);

kpr = [-7] ;

kpu = [0] ;
kdu = [0] ;
kiu = [0] ;

kpa = [0] ;
kda = [0] ;
kia = [0] ;


yaw_com = 0.5*pi/180; %rad/sec

tfinal = 100;
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

tau_w0=-5;
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

%%% Run the full nonlinear model with PD speed and PID flight path angle feedback control
sim('aircraft_feedback_control_R2015a_prob_3',T); %students complete
figure(12);
subplot(211);
plot(aircraft_state_array.time, aircraft_state_array.data(:,12)*180/pi, 'g--');hold on;
legend('non damped','damped','nonlinear');
subplot(212);
plot(aircraft_state_array.time, control_input_array.data(:,3)*180/pi, 'g--');hold on;
legend('non damped','damped','nonlinear');

% %%
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
