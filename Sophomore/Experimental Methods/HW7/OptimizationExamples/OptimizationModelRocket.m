% Optimizing the launch angle of a model rocket considering only friction
% and gravitational effects

function OptimizationModelRocket
clear;

% Set inital parameters
V0 = 150; %m/s
m = 0.12; %kg

% Set the range for optimization of the angle theta
xL = 26; %degrees
xU = 50; %degrees

% Call the optimization function to find the minimum
[xOpt,fopt] = fminbnd(@modelRocketRange,xL,xU);

fprintf('The optimum angle is %5.2f deg and the range is %4.2f m \n',xOpt,-fopt)


function fx = modelRocketRange(x)
% function to calculate the range as a function of angle, x

% set up the initial conditions
y0(1) = V0*sind(x); %initial vertical velocity
y0(2) = 0; %initial height
y0(3) = V0*cosd(x); %initial horizontal velocity
y0(4) = 0; %initial range

% set integration time span
tspan = [0 9.6]; %seconds

% call ode45 to intergate the system of equations
[t,y] = ode45('modelRocketSystemOfODEs',tspan,y0);

% retrive the height informtion
height = y(:,2);
nmax = size(height);

% determine the index number just before the rocket hit the ground i.e.
for i = 1:nmax
    if height(i)*height(i+1)<0
        ifin = i;
        break;
    end
end

% use similar triangles to find the fraction where the rocket hits the
% ground
fract = (y(ifin,2)-0)/(y(ifin,2)-y(ifin+1,2));

% calculate the range that will be outputted, note the minus sign to
% account for the fact that the optimization function only computes the
% minimum
fx = -(y(ifin,4)+fract*(y(ifin+1,4)-y(ifin,4)));
end


end