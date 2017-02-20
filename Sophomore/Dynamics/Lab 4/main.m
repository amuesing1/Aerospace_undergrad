%Lab 4 - 2003 Dynamics & Systems
%Chad Eberl
%Jeremy Muesing
%Josh Mellin

%Purpose:  This is the main script for lab 4 for ASEN 2003

%housekeeping
clear all
close all
clc

where = [.1 .1 .5 .5]; %Where the plots are displayed on the screen
nbins = 20; %number of bins for the histograms
class_numgroups = 5; %number of data files being read for the class
ours_numgroups = 3; %number of data files for our own data
titlefont = 16; %font size for the title
axesfont = 14; %font size for the axes

balance = 1; %If balance == 1, then the system is balanced

%define initial variables
M = 11.7; %[kg]
M0 = 0.7; %[kg]
m = 3.4; %[kg]
R = 0.235; %[m]
r = 0.178; %[m]
k = 0.203; %[m]
beta = 5.5; %[deg]
g = 9.81; %[m/s^2]
tau = 1.05; %[N*m]

fprintf('%50s\n','Mean Angular Velocity Residuals [rad/sec]')

plot_data(class_numgroups,M,M0,m,R,g,beta,r,k,tau,1); %reads the class data set
plot_data(ours_numgroups,M,M0,m,R,g,beta,r,k,tau,2); %reads our data set








