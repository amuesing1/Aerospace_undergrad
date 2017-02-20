function cost = AeroCostForTrim(trim_variables, trim_definition, aircraft_parameters)
%
%
% trim_definition = [V0; gamma0; h0]
%
% trim_variables = [alpha0; de0; dt0];
%

V0 = trim_definition(1);
gamma0 = trim_definition(2);
h0 = trim_definition(3);

alpha0 = trim_variables(1);
de0 = trim_variables(2);
dt0 = trim_variables(3);
beta0 = 0;

u = V0*cos(beta0)*cos(alpha0);
v = V0*sin(beta0);
w = V0*cos(beta0)*sin(alpha0);

theta = gamma0+alpha0;

aircraft_state0 = [0;0;-h0;0;theta;0;u;v;w;0;0;0]; %STUDENTS COMPLETE
control_surfaces_trim = [de0;0;0;dt0];
wind_inertial = [0;0;0];

%%% Determine aerodynamic forces and moments
rho=stdatmo(trim_definition(3));
[aero_forces, aero_moments] = AeroForcesAndMoments_BodyState_WindCoeffs(aircraft_state0,...
    control_surfaces_trim, wind_inertial, rho, aircraft_parameters); %STUDENTS COMPLETE

%%% Determine total force vector
WeightInBody = TransformFromInertialToBody([0;0;-aircraft_parameters.W],[0;theta;0]);
force_total = aero_forces-WeightInBody; % STUDENTS COMPLETE

%%% Determine costs
cost = norm(force_total) + norm(aero_moments);