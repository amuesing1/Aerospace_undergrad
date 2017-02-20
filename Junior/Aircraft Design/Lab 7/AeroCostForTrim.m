function cost = AeroCostForTrim(trim_variables, trim_definition, aircraft_parameters)
%
%
% trim_definition = [V0; gamma0; h0]
%
% trim_variables = [alpha0; de0; dt0];
%
ap = aircraft_parameters;
[aircraft_state0, control_surfaces_trim] = trimVarDefToAircraftState( trim_variables, trim_definition ); %STUDENTS COMPLETE

%%% Determine aerodynamic forces and moments
rho=stdatmo(trim_definition(3));
[aero_forces,aero_moments] = AeroForcesAndMoments_BodyState_WindCoeffs(aircraft_state0, control_surfaces_trim,[0;0;0], rho, ap); %STUDENTS COMPLETE

%%% Determine total force vector
euler = aircraft_state0(4:6);

weightVecInertial = [0; 0; ap.W];
weightVecBody = TransformFromInertialToBody(weightVecInertial,euler);
force_total = aero_forces + weightVecBody;  % 

%%% Determine costs
cost = norm(force_total) + norm(aero_moments);