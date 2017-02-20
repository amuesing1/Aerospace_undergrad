clear all;
close all;
clc;

% Set up values
E = 2*10^11; 
H = 3;
c1 = 2.20;
c2 = 400;
F = 3.6*10^7;
rho = 784;

% Set up function
f = @(D) (10*F*H^3*rho*c1)/((pi*D)^2*E)+(c2*D*H);

% Set up the constraints for D 
Dmin = 0;
Dmax = 5;

% Call optimization
[diam,POpt] = fminbnd(f,Dmin,Dmax);

% determine t
t=(10*F*H^2)/((pi*diam)^3*E);

fileID = fopen('HW7output2.txt','w');
fprintf(fileID,'Solving for t W in terms of D is:\n W=(10*F*H^3*rho)/((pi*D)^2*E)\n');
fprintf(fileID,'Diameter of column = %f meters\n',diam);
fprintf(fileID,'Thickness of the wall = %f meters\n',t);
fprintf(fileID,'Minimum Cost for Column = $%f\n',POpt);
fclose(fileID);

