function dydx = modelRocketSystemOfODEs(t,y)
% function to integrate the system of equations for the model rocket
% trajectory

dydx(1) = (-9.81-0.000626*sign(y(1))*y(1)*sqrt(y(1)^2+y(3)^2))/0.12;
dydx(2) = y(1);
dydx(3) = (-0.000626*y(3)*sign(y(3))*sqrt(y(1)^2+y(3)^2))/0.12;
dydx(4) = y(3);

dydx = dydx';

end