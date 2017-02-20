function [Aad, Bad, Ayaw, Byaw] = AircraftLinearModel(trim_state,...
    trim_inputs, aircraft_parameters)
%% This function computes the longitudinal and lateral natrices for 
% the linear longitudinal and lateral responses.
%
% Author(s): Aaron Mccusker, Brandon Noirot and David Varley
% Created: 3/7/2016
% Updated: 3/12/2016
%
%%% Inputs: ANGLES IN RADIANS
%   ~ trim_state: [~, ~, -h0, 0, theta0, ~, u0, 0, w0, 0, 0, 0]'
%   ~ trim_inputs: [de0, 0, 0, dt0]'
%   ~ aircraft_parameters: struct defining the parameters of the aircraft
%%% Outputs:
%   ~ Aad: 6x6 longitudinal matrix augmented to account for the air 
%       density vertical gradient 
%   ~ Bad: 6x6 zero matrix
%   ~ Ayaw: 6x6 lateral matrix augmented with yaw and y-position
%       perturbations
%   ~ Byaw: 6x6 zero matrix
%% Code Begin
ap = aircraft_parameters; % ---> for ease of use
%%% List of variables:
rho = stdatmo(-trim_state(3));
g = ap.g;
% Aircraft parameters
m = ap.m;
b = ap.b;
S = ap.S;
Sprop = ap.Sprop;
Cprop = ap.Cprop;
km = ap.kmotor;
K = ap.K;
c = ap.c;

CLalpha = ap.CLalpha;
CDmin = ap.CDmin;

Ix = ap.Ix;
Iz = ap.Iz;
Ixz = ap.Ixz;
Iy = ap.Iy;

kappa = (4.2*10^(-5)) * 3.28084; % [1/ft --> 1/m]

% Trim constants
theta0 = trim_state(5);
u0 = sqrt(trim_state(7)^2 + trim_state(9)^2);
V = u0;
dt0 = trim_inputs(4);
Cw0 = m*g/(0.5*rho*V^2*S);
CL0 = Cw0*cos(theta0);
CD0 = CDmin + K * CL0^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% LONGITUDINAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Longitudinal A-matrix
Alon = zeros(4);

% List of Coefficients
CYbeta = ap.CYbeta;
Clbeta = ap.Clbeta;
Cnbeta = ap.Cnbeta;

CYp = ap.CYp;
Clp = ap.Clp;
Cnp = ap.Cnp;

CYr = ap.CYr;
Clr = ap.Clr;
Cnr = ap.Cnr;

Cxu = 2*(Sprop/S)*Cprop*km/u0*dt0*(2*dt0 - 1 - (2*dt0*km)/u0);
Czu = 0; % for subsonic flight
Cmu = 0;

CLq = ap.CLq;
Czq = -CLq; % slide 31 of Stability Derivatives REV1
Cmq = ap.Cmq;

Czalpha = -(CLalpha + CD0);
Cmalpha = ap.Cmalpha;
Cxalpha = CL0*(1 - 2*K*CLalpha);

CLalphadot = ap.CLalphadot;
Cmalphadot = ap.Cmalphadot; 
Czalphadot = -CLalphadot; % slide 40 of Stability Derivatives REV1

% Derivatives
Xz = 0;
Xw = (1/2)*rho*u0*S*Cxalpha;
Xu = rho*u0*(S*Cw0*sin(theta0) + (1/2)*S*Cxu);

Zu = rho*u0*(-S*Cw0*cos(theta0) + (1/2)*S*Czu);
Zw = (1/2)*rho*u0*S*Czalpha;
Zwdot = (1/4)*rho*c*S*Czalphadot;
Zq = (1/4)*rho*u0*c*S*Czq;
Zz = -m*g*kappa;

Mu = (1/2)*rho*u0*c*S*Cmu;
Mw = (1/2)*rho*u0*c*S*Cmalpha;
Mwdot = (1/4)*rho*c^2*S*Cmalphadot;
Mq = (1/4)*rho*u0*c^2*S*Cmq;
Mz = 0;

%%% Alon
Alon(1,:) = [Xu/m, Xw/m, 0, -g*cos(theta0)];

Alon(2,1) = Zu/(m - Zwdot);
Alon(2,2) = Zw/(m - Zwdot);
Alon(2,3) = (Zq + m*u0)/(m - Zwdot);
Alon(2,4) = -m*g*sin(theta0)/(m - Zwdot);

Alon(3,1) = (1/Iy)*(Mu + Mwdot*Zu/(m - Zwdot));
Alon(3,2) = (1/Iy)*(Mw + Mwdot*Zw/(m - Zwdot));
Alon(3,3) = (1/Iy)*(Mq + Mwdot*(Zq + m*u0)/(m - Zwdot));
Alon(3,4) = -Mwdot*m*g*sin(theta0)/(Iy*(m - Zwdot));

Alon(4,3) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% LATERAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lateral A-matrix
Alat = zeros(4);

% List of Coefficients
Yv = (1/2)*rho*u0*S*CYbeta;
Yp = (1/4)*rho*u0*b*S*CYp;
Yr = (1/4)*rho*u0*b*S*CYr;

Lv = (1/2)*rho*u0*b*S*Clbeta;
Lp = (1/4)*rho*u0*b^2*S*Clp;
Lr = (1/4)*rho*u0*b^2*S*Clr;

Nv = (1/2)*rho*u0*b*S*Cnbeta;
Np = (1/4)*rho*u0*b^2*S*Cnp;
Nr = (1/4)*rho*u0*b^2*S*Cnr;

% Gammas
Gamma = (Ix*Iz) - (Ixz)^2;

Gamma3 = Iz / Gamma;
Gamma4 = Ixz / Gamma;
Gamma8 = Ix / Gamma;

%%% Alat
Alat(1,1) = Yv / m;
Alat(1,2) = Yp / m;
Alat(1,3) = (Yr / m) - u0;
Alat(1,4) = g*cos(theta0);

Alat(2,1) = Gamma3*Lv + Gamma4*Nv;
Alat(2,2) = Gamma3*Lp + Gamma4*Np;
Alat(2,3) = Gamma3*Lr + Gamma4*Nr;

Alat(3,1) = Gamma4*Lv + Gamma8*Nv;
Alat(3,2) = Gamma4*Lp + Gamma8*Np;
Alat(3,3) = Gamma4*Lr + Gamma8*Nr;

Alat(4,2) = 1;
Alat(4,3) = tan(theta0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% LINEAR MATRICES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aad from definition 
Aad = zeros(6);

Aad(1:4,1:4) = Alon;

Aad(1,6) = Xz/m;
Aad(2,6) = Zz/m;
Aad(3,6) = (1/Iy)*(Mz + (Mwdot*Zz)/(m - Zwdot));

Aad(5,1) = 1;

Aad(6,2) = 1;
Aad(6,4) = -u0;

% Bad from definition
Bad = zeros(6,2);

% Ayaw from definition
Ayaw = zeros(6);

Ayaw(1:4,1:4) = Alat;

Ayaw(5,3) = sec(theta0);

Ayaw(6,1) = 1;
Ayaw(6,5) = u0*cos(theta0);

% Byaw from definition
Byaw = zeros(6,2);

end