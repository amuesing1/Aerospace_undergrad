close all
clearvars
clc

G=6.67408E-11;
k=1.38064852E-23;
amu2kg=1.6605E-27;

% Mercury;Venus;Earth;Mars;Jupiter;Saturn;Uranus;Neptune;Pluto;Moon;Titan
% AU, Radius(km), Mass(kg), |Molecular Mass(amu)|, Surface Temp(K), surface
% pressure (bar)
table = [.387 2440 .3302E24 NaN NaN NaN; .723 6051.8 4.8685E24 44.0095 737 92; ...
    1 6371 5.9736E24 28.0134 288 1.013; 1.524 3389.9 .64185E24 44.0095 215 .00636;...
    5.203 71492 1898.6E24 2.016 165 1; 9.543 54364 568.46E24 2.016 134.8 1;...
    19.19 25559 86.832E24 2.016 76.4 1; 30.07 24766 102.43E24 2.016 71.5 1;...
    39.482 1153 1305E19 NaN NaN NaN; 1 1737.53 734.9E20 NaN NaN NaN; 9.543 2575 ...
    1345.7E20 28.0134 93.7 1.47];

% Had to do this because who knows how much I'm going to have to look up
% each week?
[~,y] = size(table);

for i=1:length(table)
    % gravitational acceleration (m/s^2)
    table(i,y+1) = (G*table(i,3))/((table(i,2)*1E3)^2);
    % escape speed (km/s)
    table(i,y+2) = sqrt((2*G*table(i,3))/(table(i,2)*1E3))/1E3;
    % scale height (m)
    table(i,y+3) = (k*table(i,5))/(table(i,4)*amu2kg*table(i,y+1));
    % ratio of planetary radius to scale height
    table(i,y+4) = 1E3*table(i,2)/table(i,y+3);
    % surface atmospheric density (cm^-3)
    table(i,y+5) = 1E-6*(table(i,6)*1E5)/(k*table(i,5));
    % column density
    table(i,y+6) = table(i,y+5)*table(i,y+3)*1E2;
    % total mass (kg)
    table(i,y+7) = amu2kg*table(i,4)*table(i,y+6)*4*pi*(table(i,2)*1E5)^2;
end

x=linspace(1,100000);
H=table(3,8);
P=1.01325*exp(-x/H);
P2=P/2;