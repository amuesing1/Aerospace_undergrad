%% Anthony Torres
% ASEN 3128 - 011
% Lab 4
% AeroForcesAndMoments_BodyState_WindCoeffs.m
% Created: 2/8/16
% Modified: 2/22/16

function [aero_forces, aero_moments] = AeroForcesAndMoments_BodyState_WindCoeffs(aircraft_state,  aircraft_surfaces,  wind_inertial,  density,  aircraft_parameters)
%
% Inputs:
%     aircraft_state = [xi, yi, zi, roll, pitch, yaw, u, v, w, p, q, r]
%
%     aircraft_surfaces = [de da dr dt];
%
%     wind_inertial = wind velocity given in inertal coordinates
%
%     density = density at given altitude
%
%     aircraft_parameters = parameters generated per specific aircraft
%
% Outputs:
%     aero_forces = aerodynamic forces on aircraft
%
%     aero_moments = aerodynamic moments on aircraft
%
% Methodology:
%     Lift and Drag are calculated in Wind Frame then rotated to body frame
%     Thrust is given in Body Frame
%     Sideforce calculated in Body Frame
%
%


%%% redefine states and inputs for ease of use
ap = aircraft_parameters;
height = -aircraft_state(3,1);

% Take into account the inertial wind velocity together with using the
% wind triangle to calculate the aircraft's velocity expressed in body
% coordinates with wind angles
tmpBodyVel = aircraft_state(7:9) - TransformFromInertialToBody(wind_inertial, aircraft_state(4:6));
tmpAirVals = AirRelativeVelocityVectorToWindAngles(tmpBodyVel);
V = tmpAirVals(1);
beta = tmpAirVals(2);
alpha = tmpAirVals(3);


% Define variables from aircraft_state
p = aircraft_state(10,1);
q = aircraft_state(11,1);
r = aircraft_state(12,1);

de = aircraft_surfaces(1);
da = aircraft_surfaces(2);
dr = aircraft_surfaces(3);
dt = aircraft_surfaces(4);

% Calculate nondimensional p, q, r
pHat = (p*aircraft_parameters.b)/(2*V);
qHat = (q*aircraft_parameters.c)/(2*V);
rHat = (r*aircraft_parameters.b)/(2*V);


%%% Determine aero force coefficients (CL, CD, CT, CY)
CL = aircraft_parameters.CL0 + aircraft_parameters.CLalpha*alpha + aircraft_parameters.CLq*qHat + aircraft_parameters.CLde*de;
CD = aircraft_parameters.CDmin + aircraft_parameters.K*CL^2;

CY = aircraft_parameters.CYbeta*beta + aircraft_parameters.CYp*pHat + aircraft_parameters.CYr*rHat + aircraft_parameters.CYda*da + aircraft_parameters.CYdr*dr;

CT = 2*(aircraft_parameters.Sprop/aircraft_parameters.S)*aircraft_parameters.Cprop*(dt/V^2)*(V + dt*(aircraft_parameters.kmotor - V))*(aircraft_parameters.kmotor - V);

%%% Convert CL, CD, CT into body coordinate coefficients CX and CZ
CX = CT - CD*cos(alpha) + CL*sin(alpha);
CZ = -CD*sin(alpha) - CL*cos(alpha);

%%% Determine aero forces from coeffficients

Q = 1/2*density*V^2;
X = aircraft_parameters.S*Q*CX;
Y = aircraft_parameters.S*Q*CY;
Z = aircraft_parameters.S*Q*CZ;

aero_forces = [X;Y;Z;];


%%% Determine aero moment coefficients
Cl = aircraft_parameters.Clbeta*beta + aircraft_parameters.Clp*pHat + aircraft_parameters.Clr*rHat + aircraft_parameters.Clda*da + aircraft_parameters.Cldr*dr;
Cm = aircraft_parameters.Cm0 + aircraft_parameters.Cmalpha*alpha + aircraft_parameters.Cmq*qHat + aircraft_parameters.Cmde*de;
Cn = aircraft_parameters.Cnbeta*beta + aircraft_parameters.Cnp*pHat + aircraft_parameters.Cnr*rHat + aircraft_parameters.Cnda*da + aircraft_parameters.Cndr*dr;


%%% Determine aero moments from coeffficients
L = aircraft_parameters.b*aircraft_parameters.S*Q*Cl;
M = aircraft_parameters.c*aircraft_parameters.S*Q*Cm;
N = aircraft_parameters.b*aircraft_parameters.S*Q*Cn;

aero_moments = [L;M;N];


