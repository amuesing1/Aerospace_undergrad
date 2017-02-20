% 2003 Lab 3
% Josh Whipkey
% Jeremy Muesing
% Chris Chamberlain
% Purpose: Doing lab 3 for ASEN2003
% Date Written: 2/16/15

clc; close all; clear all;

r = 0.075; % [m] Distance from disk center and bar pin
d = 0.1529; % [m] Hor distance b/w shaft and center of disk
l = 0.254; % [m] Length of bar

volts = [6 8 10 11];
for i=1:length(volts);
    [std_res(i,1), mean_res(i,1), std_mean_res(i,1),...
     obs(i,1), num_res_3(i,1)] = execute(volts(i),r,d,l);
end
T = table(['06';'08';'10';'11'],std_res,mean_res,std_mean_res,obs,num_res_3,...
    'VariableNames',{'Voltage' 'ResidualSTD' 'ResidualMean' 'ResidualSEM' 'NumberofObservations' 'Residuals3STD'})