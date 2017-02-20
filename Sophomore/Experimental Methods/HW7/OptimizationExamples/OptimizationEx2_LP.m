% Example of LP for the furniture example dscussed in class, this routine
% automatically minimizes thus you must multiple the objective by -1 and
% multiple the answer for the optimum by -1 to report
clear all;
close all;
clc;

% Objective function is
% Phi = 1500*x1 + 800*x2
% where x1 = # of tables and x2 = # of chairs


% Constraints x1 > 0 and x2 > 0
% Material constraint: 30*x1 + 18x2 <= 300
% Labour constraint: 20*x1 + 8*x2 <= 160
% use upper limit of 20 for tables and 20 for chairs

% Set coefficients of Objective function
Phi(1,1) = -1500;  
Phi(2,1) = -800;

% coefficients of LHS of constraints
Aineq(1,1) = 30; Aineq(1,2) = 18;
Aineq(2,1) = 20; Aineq(2,2) = 8;

% values on the RHS of constrains
bineq(1,1) = 300; bineq(2,1) = 160;

% set lower limit and upper limit on x1 and x2
lowlim(1,1) = 0;
lowlim(2,1) = 0;
uplim(1,1) = 20;
uplim(2,1) = 20;

% set initial guess for # of tables and chairs
%x0(1,1) = 5;
%x0(2,1) = 5;

% call optimization for LP problem
%[xOpt,PhiOpt] = linprog (Phi,Aineq,bineq,[],[],lowlim,uplim,x0)
[xOpt,PhiOpt] = linprog (Phi,Aineq,bineq,[],[],lowlim,uplim)