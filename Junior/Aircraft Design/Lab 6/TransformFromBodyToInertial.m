% Sarah Levine, Aspen Coates, Griffin Esposito
% ASEN 3128
% TransformFromInertialtoBody.m
% Date Created:  1/25/2016

% Function name: TransformFromBodyToInertial
%
% Inputs: vector_inertial = vector given body coordinates                   
%         euler_angles = vector of euler angles specifing rotation [rad]
%                        [roll pitch yaw]' = [phi theta psi]'
%
% Outputs: vector_inertial = output vector transformed to inertial coordinates
%
%
% Methodology: Uses the function RotationMatrix321 to transform between
% coordinate frames

function vector_inertial = TransformFromBodyToInertial(vector_body, euler_angles)

R = RotationMatrix321(euler_angles);
vector_inertial = R'*vector_body;

end