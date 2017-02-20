% Jeremy Muesing
% ASEN 4057
% problem1.m
% Created: 1/23/17
% Modified: 1/23/17

close all
clear all
clc

% Prompt user for inputs
theta = input('What is the launch angle in deg?\n'); %degrees
V = input('What is the initial velocity in m/s?\n'); %m/s

% Find time until it hits the ground
time=time_2_impact(theta,V,0);

% Turn that time into a vector as well as x and y coordinates
[time_vec,x,y]=trajectory(theta,V,time);

% Graph both with respect to time
figure
subplot(2,1,1)
plot(time_vec,x)
ylabel('Horizontal Position (m)')
title('Ball Trajectory Over Time')

subplot(2,1,2)
plot(time_vec,y)
ylabel('Vertical Position (m)')
xlabel('Time(s)')