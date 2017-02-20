function [Drag,Cd,Cdtot,V,dy] = computeDrag(filename)

data = load(filename);
c = .00889; %m
P_inf = data(:,1); %Pa
T_inf = data(:,2); %K
rho_inf = data(:,3); %kg/m^3
V_inf = data(:,4); %m/s
Pdynamic = data(:,6); %Pa
dy = data(:,end); %mm
dy = dy./1000; %m
V = sqrt(2.*Pdynamic./rho_inf); %m/s
Drag = abs(rho_inf.*trapz(dy,V.*(V_inf-V))); %N
Cd = Drag./((1/2).*rho_inf.*V.^2*c); %dimensionless

Cdtot = mean(Drag./((1/2).*rho_inf.*V_inf.^2*c)); %dimensionless
end

