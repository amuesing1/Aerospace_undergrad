clearvars
clc

fun = @Mole_Solver;
x0 = [0,0,0,0,0];
x = fsolve(fun,x0);