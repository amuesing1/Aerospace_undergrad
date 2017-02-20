function f = objectivefunction2(x)
% objectivefunction2.m
% Aaron McCusker and Jeremy Muesing
%
% This function is used to minimize the time back to Earth.
%
% Input:
% x -- [dx, dy] = delta Vx and delta Vy being attempted for the simulation
%
% Output
% f -- The function to be minimized. f will be smallest when the astronauts
% are saved and the time has the smallest value.

dx = x(1);
dy = x(2);

% Call spacecraft_simulator.m with the proper inputs, the delta Vx and
% delta Vy for this simulation. Return IE, the ending index from the
% simulation, and t, the time for completion
[t,~,IE] = spacecraft_simulator(dx,dy);

if IE == 1
    scalar = 0;
elseif IE == 2
    scalar = 1E8;
elseif IE == 3
    scalar = 1E8;
else
    error('Something wrong with IE')
end

if sqrt(dx^2 + dy^2) > 100
    scalar2 = 1E9;
else
    scalar2 = 0;
end

f = scalar + scalar2 + t;

end