function [ aircraft_state, control_surfaces_trim ] = trimVarDefToAircraftState( trim_variables, trim_definition )


% trim_definition = [V0; gamma0; h0]
%
% trim_variables = [alpha0; de0; dt0];
xi = 0;
yi = 0;
zi = -trim_definition(3);
roll = 0;
pitch = trim_definition(2) + trim_variables(1);
yaw = 0;
V = trim_definition(1);
beta = 0;
alpha = trim_variables(1);
velocity_body = WindAnglesToAirRelativeVelocityVector([V; beta; alpha]);
u = velocity_body(1);
v = velocity_body(2);
w = velocity_body(3);
p = 0;
q = 0;
r = 0;
aircraft_state = [xi, yi, zi, roll, pitch, yaw, u, v, w, p, q, r]';
control_surfaces_trim = [trim_variables(2), 0, 0, trim_variables(3)]';
end

