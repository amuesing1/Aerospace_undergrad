function cost = AeroCostForTrim(trim_variables, trim_definition, aircraft_parameters)
%
%
% trim_definition = [V0; gamma0; h0]
%
% trim_variables = [alpha0; de0; dt0];
%

ap = aircraft_parameters;
pitch_angle = trim_variables(1) + trim_definition(2);
 
w_0 = trim_definition(1)*sin(trim_variables(1)); 

aircraft_state0 = [0;0;-trim_definition(3);0;...
    trim_variables(1); 0; trim_definition(1)*cos(trim_variables(1)); 0; w_0; 0; 0; 0 ];

control_surfaces_trim = [trim_variables(2); 0;0;trim_variables(3)];

%%% Determine aerodynamic forces and moments
rho = stdatmo(trim_definition(3));
wind_inertial = [0;0;0];
[aero_forces, aero_moments] = AeroForcesAndMoments_BodyState_WindCoeffs(aircraft_state0,  control_surfaces_trim,  wind_inertial,  rho,  aircraft_parameters);

%%% Determine total force vector
f_gravity = [-ap.W*sin(pitch_angle);ap.W*cos(pitch_angle)*sin(0); ap.W*cos(pitch_angle)];
force_total = aero_forces+f_gravity;

%%% Determine costs
cost = norm(force_total) + norm(aero_moments);