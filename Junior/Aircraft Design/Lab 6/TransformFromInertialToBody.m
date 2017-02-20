% Sarah Levine, Aspen Coates, Griffin Esposito
% ASEN 3128
% TransformFromInertialtoBody.m
% Date Created:  1/25/2016

% Function name: TransformFromInertialtoBody
%
% Inputs: vector_inertial = vector given in inertial coordinates                   
%         euler_angles = vector of euler angles specifing rotation [rad]
%                        [roll pitch yaw]' = [phi theta psi]'
%
% Outputs: vector_body = output vector transformed to body coordinates
%
%
% Methodology: Insert description of function here

function vector_body = TransformFromInertialToBody(vector_inertial, euler_angles)

R = RotationMatrix321(euler_angles);
vector_body = R*vector_inertial;

end