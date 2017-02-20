clc;
clear all;
close all;
format compact;
rho_air_35km = .0082; % in (kg/m^3)
%k=linspace(1,4,100);
k=3;
payload = 1000; % in kg
rho_gas = .00057; % in (kg/m^3)
%rho_gas = .0011;
tensile_strength = 37000; % in kPa
rho_material = 935; % kg/m^3
[T,a,p,rho_air]= atmoscoesa(35000)




r = (payload ./ ((rho_air_35km*((4/3)*pi) - rho_gas*((4/3)*pi)) - rho_material*(4*pi)*((.05.*k)./(2*tensile_strength)))).^(1/3); 
volume= (4/3)*pi.*r.^3;
thickness=(.05.*k.*r)/(74000);
weight_of_balloon = rho_material.*(4*pi.*r.^3).*((.05.*k)/(2.*tensile_strength));
weight_of_gas = rho_gas*(4/3)*pi.*r.^3;
weight_of_system = payload + weight_of_gas + weight_of_balloon;


figure(1);
plot(k,r);
xlabel('safety factor');
ylabel('radius');

for i=1:1000

    height=30000+(i*10);
    [T,a,p,rho]= atmoscoesa(height);
    rho_mat(i)=(rho);
    
end

hold on;
figure(2);
F_buoyancy=rho_air*4/3*pi*r.^3
Volume=4/3*pi*r.^3
plot(Volume,F_buoyancy,'*')
title('Helium');
xlabel('Volume');
ylabel('Buoyancy Force');
%height=linspace(30000,40000,1000);
%plot(height,rho_mat);