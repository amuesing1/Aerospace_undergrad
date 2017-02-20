function [Output] = Exp_Orbit(n, Backload_Status)
% ASEN 3113 Design Lab 1
% Gerardo Pulido and David Barker
% input:     time of year, number of desired points
% output:    incident angle(dot product) for evey side relative the sun

%clear all
%clc
%close all

% Constants

Day_L = 1*(24)*(60)*(60); %[sec] day>hour>min>sec
Tilt = 24.5; %[deg]
r_s = 42164*10^3; %[m]
r_e = 6.371*10^6; %[m]
sun = [-1, 0, 0];

% inputs
%n = 50;
%n = Day_L/60; % number of points
%Backload_Status = 'Equinox';

%Time of the year String
%Time = -1; %1=winter solstice, -1=summmer solstice
if 1 == strcmp(Backload_Status, 'Summer Solstice')
    Time = -1;
end
if 1 == strcmp(Backload_Status, 'Winter Solstice')
    Time = 1;
end
if 1 == strcmp(Backload_Status, 'Equinox')
    Time = 0;
end

% Derived Values
time = 0:Day_L/n:Day_L;
r = 35*10^6;
theta = time*2*pi/Day_L;

% x, y, & z values relative to function
x = r*cos(Time*Tilt*pi/180)*cos(theta);
y = r*cos(Time*Tilt*pi/180)*sin(theta);
z = r*sin(Time*Tilt*pi/180)*cos(theta);

% dx, dy, & dz derived from change in x, y & z
dx(1) = (x(2)-x(end-1))/2;
dy(1) = (y(2)-y(end-1))/2;
dz(1) = (z(2)-z(end-1))/2;
for i = 2:length(theta)-1
    dx(i) = (x(i+1) - x(i-1))/2;
    dy(i) = (y(i+1) - y(i-1))/2;
    dz(i) = (z(i+1) - z(i-1))/2;
end
dx(length(theta)) = dx(1);
dy(length(theta)) = dy(1);
dz(length(theta)) = dz(1);

%velocity length
vl = (dx.^2 + dy.^2 + dz.^2).^(1/2);


%unit vector derivations
for i = 1:length(vl)
    direction(i, 1) = dx(i)/vl(i);
    direction(i, 2) = dy(i)/vl(i);
    direction(i, 3) = dz(i)/vl(i);
end

%panel vectors
front = direction;
back = -direction;
for i = 1:length(x)
    top(i, 1) = x(i)/r;
    top(i, 2) = y(i)/r;
    top(i, 3) = z(i)/r;
end
bot = -top;
%cross back to top for left
for i = 1:length(x)
    right(i, :) = cross(back(i, :), top(i, :));
end
left = -right;

%incidence
for i = 1:length(vl)
    front_i(i, 1) = dot(sun, front(i, :));
    back_i(i, 1) = dot(sun, back(i, :));
    top_i(i, 1) = dot(sun, top(i, :));
    bot_i(i, 1) = dot(sun, bot(i, :));
    left_i(i, 1) = dot(sun, left(i, :));
    right_i(i, 1) = dot(sun, right(i, :));
end

%darkness
dark_a = asin(r_e/r_s);


% Output = [front, back, top, bot, left, right]

Output = [front_i, back_i, top_i, bot_i, left_i, right_i];

if 1 == strcmp(Backload_Status, 'Equinox')
    for i = 1:n+1
        if theta(1, i) <= dark_a
            Output(i, :) = 0;
        elseif theta(1, i) >= (2*pi)-dark_a
            Output(i, :) = 0;
        end
    end
end

end
