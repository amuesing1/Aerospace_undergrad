%TestAllFunctions


% 	velocity_body = WindAnglesToAirRelativeVelocityVector(wind_angles)
% 	wind_angles = AirRelativeVelocityVectorToWindAngles(velocity_body)
% 	R321 = RotationMatrix321(euler_angles)
% 	vector_inertial = TransformFromBodyToInertial(vector_body, euler_angles)
% 	vector_body = TransformFromInertialToBody(vector_inertial, euler_angles)
% 	[aero_forces, aero_moments] = AeroForcesAndMoments_BodyState_WindCoeffs(aircraft_state, aircraft_surfaces, wind_inertial, density, aircraft_parameters)
% 	[force_moment_vec] = S_AeroForcesAndMoments(u, aircraft_parameters)
% 	recuv_tempest



close all
clear all
clc

load TestVariablesLab3
clear aircraft_parameters
recuv_tempest

problems = 0;
functions_good = 0; 


%%%%%%%%%%%%%%%%%%%%%%%%%% WindAnglesToAirRelativeVelocityVector %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('-')
disp('WindAnglesToAirRelativeVelocityVector')

%function       
velocity_body_check = WindAnglesToAirRelativeVelocityVector(wind_angles);

if (norm(velocity_body - velocity_body_check) > 1e-10)
    problems = problems+1;
    disp('*** has a problem in velocity_body')
end
if problems == 0
    functions_good = functions_good+1;
    disp('works correctly')
end
problems = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%% AirRelativeVelocityVectorToWindAngles %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('-')
disp('AirRelativeVelocityVectorToWindAngles')

%function       
wind_angles_check = AirRelativeVelocityVectorToWindAngles(velocity_body);

if (norm(wind_angles - wind_angles_check) > 1e-10)
    problems = problems+1;
    disp('*** has a problem in wind_angles')
end
if problems == 0
    functions_good = functions_good+1;
    disp('works correctly')
end
problems = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%% RotationMatrix321 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('-')
disp('RotationMatrix321')

R321_check = RotationMatrix321(euler_angles);

if (norm(R321 - R321_check) > 1e-10)
    problems = problems+1;
    disp('*** has a problem in R321')
end
if problems == 0
    functions_good = functions_good+1;
    disp('works correctly')
end
problems = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%% TransformFromBodyToInertial %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('-')
disp('TransformFromBodyToInertial')

velocity_inertial_check = TransformFromBodyToInertial(velocity_body, euler_angles);

if (norm(velocity_inertial - velocity_inertial_check) > 1e-10)
    problems = problems+1;
    disp('*** has a problem in velocity_inertial')
end
if problems == 0
    functions_good = functions_good+1;
    disp('works correctly')
end
problems = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%% TransformFromInertialToBody %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('-')
disp('TransformFromInertialToBody')

velocity_body_check = TransformFromInertialToBody(velocity_inertial, euler_angles);

if (norm(velocity_body - velocity_body_check) > 1e-10)
    problems = problems+1;
    disp('*** has a problem in velocity_body')
end
if problems == 0
    functions_good = functions_good+1;
    disp('works correctly')
end
problems = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%% AeroForcesAndMoments_BodyState_WindCoeffs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('-')
disp('AeroForcesAndMoments_BodyState_WindCoeffs')

[aero_forces_check, aero_moments_check] = AeroForcesAndMoments_BodyState_WindCoeffs(aircraft_state, control_input, aircraft_parameters);

aero_forces - aero_forces_check;
aero_moments - aero_moments_check;

if (norm(aero_forces - aero_forces_check) > 1e-10)
    problems = problems+1;
    disp('*** has a problem in aero_forces')
end
if (norm(aero_moments - aero_moments_check) > 1e-10)
    problems = problems+1;
    disp('*** has a problem in aero_moments')
end
if problems == 0
    functions_good = functions_good+1;
    disp('works correctly')
end
problems = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%% S_AeroForcesAndMoments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('-')
disp('S_AeroForcesAndMoments')

[force_moment_vec_check] = S_AeroForcesAndMoments([aircraft_state; control_input], aircraft_parameters);


if (norm(force_moment_vec - force_moment_vec_check) > 1e-10)
    problems = problems+1;
    disp('*** has a problem in force_moment_vec')
end
if problems == 0
    functions_good = functions_good+1;
    disp('works correctly')
end
problems = 0;



