% Dylan Richards
% ASEN 3128
% AeroForcesAndMoments_BodyState_WindCoeffs.m
% Created: 2/8/16
% Modified: 2/20/16

function [aero_forces, aero_moments] = AeroForcesAndMoments_BodyState_WindCoeffs(aircraft_state, aircraft_surfaces, aircraft_parameters)
%Inputs:
% aircraft_state = [xi, yi, zi, roll, pitch, yaw, u, v, w, p, q, r];
%
% aircraft_surfaces = [de da dr dt];
%
% aircraft_parameters = structure containing the aerodynamic constants of
% the aircraft
%
% Lift and Drag are calculated in Wind Frame then rotated to body frame
% Thrust is given in Body Frame
% Sideforce calculated in Body Frame
%
%Outputs:
% aero_forces = [X; Y; Z];
% aero_moments = [L; M; N];
%
%Purpose:
% Read in the aerodynamic constants for an aircraft, the aircraft state
% vector, and the aircraft control surface vector, and output the
% aerodynamic forces and moments acting on the aircraft at that instant in time.


%%% redefine states and inputs for ease of use:
ap = aircraft_parameters;

height = -aircraft_state(3,1);
rho = stdatmo(height);
u = aircraft_state(7,1);
v = aircraft_state(8,1);
w = aircraft_state(9,1);

V = sqrt(u^2 + v^2 + w^2); %air relative velocity
beta = asin(v/V); %sideslip angle
alpha = atan2(w,u); %angle of attack

p = aircraft_state(10,1); %roll rate
q = aircraft_state(11,1); %pitch rate
r = aircraft_state(12,1); %yaw rate

%Nondimensionlize p,q,r:
P_hat = p*ap.b/(2*V);
Q_hat = q*ap.c/(2*V);
R_hat = r*ap.b/(2*V);

%Control Surfaces:
de = aircraft_surfaces(1,1);
da = aircraft_surfaces(2,1);
dr = aircraft_surfaces(3,1);
dt = aircraft_surfaces(4,1);

%%% Determine aero force coefficients (CL, CD, CT, CY):
CL = ap.CL0 + ap.CLalpha*alpha + ap.CLq*Q_hat + ap.CLde*de;
CD = ap.CDmin + ap.K*CL^2;
CY = ap.CYbeta*beta + ap.CYp*P_hat + ap.CYr*R_hat + ap.CYda*da + ap.CYdr*dr;
CT = 2*(ap.Sprop/ap.S)*ap.Cprop*(dt/V^2)*(V + (dt*(ap.kmotor-V)))*(ap.kmotor-V);

%%% Convert CL, CD, CT into body coordinate coefficients CX and CZ:
CX = CT - CD*cos(alpha) + CL*sin(alpha);
CZ = -CD*sin(alpha) - CL*cos(alpha);

%%% Determine aero forces from coeffficients:
Q = .5*rho*V^2;
aero_forces = [ap.S*Q*CX; ap.S*Q*CY; ap.S*Q*CZ];


%%% Determine aero moment coefficients:
Cl = ap.Clbeta*beta + ap.Clp*P_hat + ap.Clr*R_hat + ap.Clda*da + ap.Cldr*dr;
Cm = ap.Cm0 + ap.Cmalpha*alpha + ap.Cmq*Q_hat + ap.Cmde*de;
Cn = ap.Cnbeta*beta + ap.Cnp*P_hat + ap.Cnr*R_hat + ap.Cnda*da + ap.Cndr*dr;

%%% Determine aero moments from coeffficients:
aero_moments = [ap.b*ap.S*Q*Cl; ap.c*ap.S*Q*Cm; ap.b*ap.S*Q*Cn];

end


