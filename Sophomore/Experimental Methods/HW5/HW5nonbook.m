function HW5(nonbook)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
clc
clear all
y=[4 3 1 0];
t=[-2 -1 0 2];
[delta,A,B,sum_t,sum_t2,sum_y,sum_yt]=parta(y,t);
[uncer_y]=partb(y,t,A,B);
[uncer_A,uncer_B]=partc(uncer_y,y,sum_t2,delta);
[x]=partd(y,t,sum_t,sum_t2,sum_y,sum_yt);
[uncer_y_poly]=parte(y,x,t);
[sigma_A,sigma_B,sigma_C]=partf(y,uncer_y_poly);
partg(t,y,A,B,x);
parth(uncer_A,uncer_B,sigma_A,sigma_B,sigma_C);
end

