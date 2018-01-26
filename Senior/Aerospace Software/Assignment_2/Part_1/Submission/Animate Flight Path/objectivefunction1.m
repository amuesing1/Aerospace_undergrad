function f = objectivefunction1(x)
% objectivefunction1.m
% Aaron McCusker and Jeremy Muesing
%
% This function is used to minimize the delta V needed to save the
% astronauts.
%
% Input:
% x -- [dx, dy] = delta Vx and delta Vy being attempted for the simulation
%
% Output
% f -- The function to be minimized. f will be smallest when the astronauts
% are saved and the delta V has the smallest magnitude

% Call spacecraft_simulator.m with the proper inputs, the delta Vx and
% delta Vy for this simulation. Return IE, the ending index from the
% simulation
[~,~,IE] = spacecraft_simulator(x(1),x(2));

% IE represents whether the spacecraft hit the earth, the moon, or was lost
% in space

% If IE is 1, they were returned safely
if IE == 1
    scalar = 0;
    
% If IE is 2, they hit the moon. Rest in peace, astronauts.
elseif IE == 2
    scalar = 1E8;
    
% If IE is 3, they were lost in space. Rest in peace, astronauts.
elseif IE == 3
    scalar = 1E8;
% If IE isn't 1, 2, or 3, something went wrong. Throw out an error.
else
    error('Something wrong with IE')
end

% Find f using scalar and the magnitude of delta V
f = scalar + sqrt(x(1)^2 + x(2)^2);

end