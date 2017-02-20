% Computation Lab #2 Problem 2
% Jeremy Muesing
% 102351491
% 9/11/15

close all
clear all
clc
clf

%% Define Domain
c=2;
xmin=0;
xmax=c;
ymin=-3.0;
ymax=1.5;

%% Define Number of Grid Points
nx=100; % steps in the x direction
ny=100; % steps in the y direction

%% Create mesh over domain using number of grid points specified
[x,y]=meshgrid(linspace(xmin,xmax,nx),linspace(ymin,ymax,ny));

%% Define Flow Parameters

strength(x) = 2*alpha*V_inf*((1+cos(theta(x)))/(sin(theta(x))));
U0 = 5.0;       % Uniform flow velocity
Gamma = strength(x)*dx;   % vortex strength
xGamma = -1.0;  % location of vortex
yGamma = -1.0;
K = 5.0;        % dipole strength
xK = -1.0;      % location of dipole
yK = -1.0;

%% Define a function which calculates the radius.
% Center of circle = (x1,y1)
radius=inline('sqrt((x-x1).^2+(y-y1).^2)','x','y','x1','y1');

%% Calculate psi for uniform stream (pg. 97)
Psi_U0 = U0*y;

%% Calculate psi for dipole (Eq. 4.15)
Psi_K = K*sin(atan2(y-yK,x-xK))./(radius(x,y,xK,yK));

%% Calculate psi for vortex (Eq. 4.18)
Psi_Gamma = Gamma/(2*pi)*log(radius(x,y,xGamma,yGamma));

%% Add all streamfunctions together
StreamFunction = Psi_U0 - Psi_Gamma - Psi_K;

%% Determine color levels for contours
levmin = StreamFunction(1,nx); % defines the color levels -> trial and error to find a good representation
levmax = StreamFunction(ny,nx/2);
levels = linspace(levmin,levmax,50)';

%% Plot streamfunction at levels
contour(x,y,StreamFunction,levels)

%% Plot cylinder on same graph
theta=linspace(0,2*pi);

figure(1)
hold on;
plot(xGamma+cos(theta),yGamma+sin(theta),'k');
hold off;

%% Adjust axis and label figure
axis equal
axis([xmin xmax ymin ymax])
ylabel('y')
xlabel('x')
