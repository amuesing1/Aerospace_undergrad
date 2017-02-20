%Reset Button

clc; clear all; close all; format compact;

PC = [.1 .3 .2 .25;.6 .2 .1 0;.35 .25 .28 0;.25 .29 .2 .15]';

 

%Part A & B- Profit + Objective function

%Create coefficent of profit vector from each source

Profit= [-5 -3 -6 -8]'; %Profit per barrel of each type

Profit_source1= sum(Profit.*PC(:,1)); % Profit from each 

%refinery

Profit_source2= sum(Profit.*PC(:,2));

Profit_source3= sum(Profit.*PC(:,3));

Profit_source4= sum(Profit.*PC(:,4));

Profit_allSource = [Profit_source1 Profit_source2 Profit_source3 Profit_source4];

 

%Part C - %Total available crude barrels per refinery

TA = [25000 30000 30000 35000]'; 

%Part D- set lower limit

lowlim = [0 0 0 0]';

 

%Part E - Max Demand Constraint  barrels per day

CrudeMaxDemand= [35000 20000 25000 4000]';

 

%Part F - Determine number of barrels to produce from each refinery to maximize profits

[xCoeffs,Total_Profit] = linprog(Profit_allSource,PC,CrudeMaxDemand,[],[],lowlim,TA)