% Jeremy Muesing
% ASEN 3128
% unknown_vars.m
% Created: 4/11/16
% Modified: 4/11/16

function [ Beta,deltar,deltaa,delta_alpha,delta_deltae ] = unknown_vars(trim_state, aircraft_parameters, phi, omega, flight_path_angle )
% This is a file that computes 5 missing varriables involved in a banked
% turn given the aircarft, roll angle, speed, turn rate, and flight path
% angle.
% Inputs: 
%       trim_state= the initial state of the aircraft
%       aircraft_parameters = geometric values of the aircraft
%       phi = roll angle
%       omega = turn rate
%       flight_path_angle = flight path angle
%
% Outputs:
%       Beta = Sideslip
%       deltar = rudder deflection
%       deltaa = alieron defelction
%       delta_alpha = change in angle of attack
%       delta_deltae= change in elevator deflection
ap = aircraft_parameters;
density = stdatmo(abs(trim_state(3)));
C_y_beta = ap.CYbeta;
C_l_beta = ap.Clbeta;
C_y_deltar = ap.CYdr;
C_l_deltaa = ap.Clda;
C_l_deltar = ap.Cldr;
C_n_deltar = ap.Cndr;
C_n_deltaa = ap.Cnda;
C_n_beta = ap.Cnbeta;
C_m_deltae = ap.Cmde;
C_L_deltae = ap.CLde;
C_L_alpha = ap.CLalpha;
C_m_alpha = ap.Cmalpha;
C_L_q=ap.CLq;
C_m_q=ap.Cmq;
C_y_p = ap.CYp;
C_y_r = ap.CYr;
C_l_p = ap.Clp;
C_l_r = ap.Clr;
C_n_p = ap.Cnp;
C_n_r = ap.Cnr;
b = ap.b;
c_bar = ap.c;
m = ap.m;
S = ap.S;
g = 9.81;
u_0 = norm(trim_state(7:9));
omega=deg2rad(omega);

%stuff for delta_C_L
p=trim_state(10);
Z=-m*g*cos(phi)-m*p*u_0;
L=-Z;
delta_C_L=(L-m*g)/(.5*density*u_0^2*S);


matrix_1=[C_y_p, C_y_r; C_l_p, C_l_r; C_n_p, C_n_r];
matrix_2=[C_y_beta, C_y_deltar, 0; C_l_beta, C_l_deltar, C_l_deltaa; ...
    C_n_beta, C_n_deltar, C_n_deltaa];
matrix_3=[C_m_q;C_L_q];
matrix_4=[C_m_alpha, C_m_deltae; C_L_alpha, C_L_deltae];

stuff=(matrix_1*[flight_path_angle;-cos(phi)]*((omega*b)/(2*u_0)))'*inv(matrix_2);
Beta=stuff(1);
deltar=stuff(2);
deltaa=stuff(3); clear stuff
stuff=((-matrix_3*((omega*c_bar)/(2*u_0))*sin(phi))+[0;delta_C_L])'*inv(matrix_4);
delta_alpha=stuff(1);
delta_deltae=stuff(2);

end

