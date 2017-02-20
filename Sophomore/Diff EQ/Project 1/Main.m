% Aaron McCusker, Jeremy Muesing, and Alex Bertman
% APPM 2360 Project 1
% February 18th, 2015

clear all
close all
clc

% Constants describing how well the locals catch fish
p = 1.2;
q = 1;

% Growth rate of all fish
r = .65; % (1/day)

% Carrying capacities of the fish (hundreds)
L_Rainbow = 5.4; % Carrying capacities of the fish (hundreds)
L_Brown = 8.1; % Carrying capacities of the fish (hundreds)
L_Bass = 16.3; % Carrying capacities of the fish (hundreds)

y_1 = 0; % Fish Population (Hundreds)
y_2 = 8; % Fish Population (Hundreds)
dy = 0.1; % Fish Population (Hundreds)
y_span = y_1:dy:y_2; % Fish Population (Hundreds)

t_1 = 0; % Days
t_2 = 14; % Days
dt = 1; % Days
t_span = t_1:dt:t_2; % Days

for L = [L_Rainbow L_Brown L_Bass]
    i = 1;
    clear Y
    f = @(t,y) r*(1-(y/L))*y - (p*(y^2))/(q+(y^2));
    title2 = strcat('Direction Field for L = ',num2str(L));
    dirfield(f,t_span,y_span,title2,p,q,L,r);
    for y = y_span
        Y(i) = r*(1-(y/L))*y - (p*(y^2))/(q+(y^2));
        i = i + 1;
    end
    figure
    plot(y_span,Y)
    hold on
    line([0 y_2],[0 0]);
    title2 = strcat('f(y) for L = ',num2str(L));
    title(title2)
    ylabel('f(y), (hundreds of fish / day)')
    xlabel('y, population of fish (hundreds of fish)')
end

Bifurcation1 = 13; % Yup, from 2 to 3 (When going from high to low)
Bifurcation2 = 6.7; % Yup, from 3 to 1 (When going from high to low)