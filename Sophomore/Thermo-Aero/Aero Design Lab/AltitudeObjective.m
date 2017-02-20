function [height,t,y,data] = AltitudeObjective(initialValues)

%initialValues(1) = pairI
%initialValues(2) = initial volume fraction
%initialValues(3) = drag coefficient
%initialValues(4) = angle of launch
%initialValues(5) = max time
%initialValues(6) = initial velocity


% user chosen values
launchAngle = initialValues(4);                 %deg
data.vB = 0.002;                                %m^3
volumePercentage = initialValues(2);            %percentage
gaugePressure = initialValues(1)*6894.8;        %pascals (psi->pascals)


% weather conditions
data.TairI = 300;                       %Kelvin
data.pa = 12.5*6894.8;                  %ambient pressure pascals

% fixed values
data.CD = initialValues(3);             %drag coefficient
data.cd = 0.9;                          %discharge coefficient
data.g0 = 9.794;                        %gravity (m/s^2)
data.mB = 0.15;                         %mass of bottle (kg)
data.AB = 0.008659;                     %area bottle (10.5cm diameter)
data.At = 0.00034636;                   %nozzle area (2.1cm diameter)
data.R = 287;                           %gas constant
data.rhowater = 998;                    %density of water
data.gamma = 1.4;

% calculated values
data.massWater = (volumePercentage/100)*data.vB*data.rhowater;
volumeWater = data.massWater/data.rhowater;
data.vairI = data.vB - volumeWater;
data.pairI = gaugePressure + data.pa;
data.mairI = (data.pairI*data.vairI)/(data.R*data.TairI);
data.mRI = data.mB + data.massWater + data.mairI;
data.rhoair = data.pa/(data.R*data.TairI);
data.stageTwoStartMass = data.mB + data.rhoair*data.vB;
angle = launchAngle/180*pi;

startStop = [0 initialValues(5)];
initialValues = [initialValues(6), angle, 0, 0.01, data.mRI, data.vairI, 0, 0, 0];
opts = odeset('RelTol',1e-7,'AbsTol',1e-8);
[t,y] = ode45(@Trajectory,startStop,initialValues,opts,data);
height = max(y(:,4));

end

