% Computation Lab #2 Problem 2
% Jeremy Muesing
% 102351491
% 9/11/15

close all
clear all
clc

%% Define Domain
xmin=-1;
xmax=3;
ymin=-1.0;
ymax=3;

%% Define Number of Grid Points
nx=100; % steps in the x direction
ny=100; % steps in the y direction

%% Define Flow Parameters

n=999; %number of steps
c=2; %m
alpha=10; %degrees
alpha=alpha*2*pi/360; %rad
V_inf=100; %m/s
p_inf=2.65*10^4; %Pa
rho_inf=0.4135; %kg/m^3
i=1;
%for error analysis
for n=[999,499,99,10]
[Stream(:,:,i), Potential(:,:,i), Pressure(:,:,i)]=computation(c,alpha,V_inf,p_inf,rho_inf,n,xmin,xmax,ymin,ymax,nx,ny);
i=i+1;
end

%% Error analysis
half_data_stream=mean(mean(100*(abs(Stream(:,:,1)-Stream(:,:,2))/Stream(:,:,1))));
tenth_data_stream=mean(mean(100*(abs(Stream(:,:,1)-Stream(:,:,3))/Stream(:,:,1))));
thousandth_data_stream=mean(mean(100*(abs(Stream(:,:,1)-Stream(:,:,4))/Stream(:,:,1))));

half_data_pressure=mean(mean(100*(abs(Pressure(:,:,1)-Pressure(:,:,2))/Pressure(:,:,1))));
tenth_data_pressure=mean(mean(100*(abs(Pressure(:,:,1)-Pressure(:,:,3))/Pressure(:,:,1))));
thousandth_data_pressure=mean(mean(100*(abs(Pressure(:,:,1)-Pressure(:,:,4))/Pressure(:,:,1))));

%% Create mesh over domain using number of grid points specified
[x,y]=meshgrid(linspace(xmin,xmax,nx),linspace(ymin,ymax,ny));
%% Determine color levels for contours
levminpsi = min(min(Stream(:,:))); % defines the color levels -> trial and error to find a good representation
levmaxpsi = max(max(Stream(:,:)));
levelspsi = linspace(levminpsi,levmaxpsi,50)';

levminphi = min(min(Potential(:,:))); % defines the color levels -> trial and error to find a good representation
levmaxphi = max(max(Potential(:,:)));
levelsphi = linspace(levminphi,levmaxphi,50)';

%% Plot streamfunction
figure()
hold on
contour(x,y,Stream(:,:,1),levelspsi)
plot(linspace(0,c,50),0,'k.')
title('Streamlines')
xlabel('Distance from leading edge (m)')
ylabel('Distance from leading edge (m)')
legend('stream lines','airfoil')
hold off
%plot potential
figure()
hold on
contour(x,y,Potential(:,:,1),levelsphi)
plot(linspace(0,c,50),0,'k.')
title('Equipotential Lines')
xlabel('Distance from leading edge (m)')
ylabel('Distance from leading edge (m)')
legend('equipotential lines','airfoil')
hold off
%plot pressure
figure()
hold on
contourf(x,y,max(Pressure(:,:,1),2e4),50) %set upper limit
plot(linspace(0,c,50),0,'r.')
title('Pressure Contour')
xlabel('Distance from leading edge (m)')
ylabel('Distance from leading edge (m)')
legend('pressure values', 'airfoil')
hold off