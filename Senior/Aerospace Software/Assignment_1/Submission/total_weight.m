% Jeremy Muesing
% ASEN 4057
% total_weight.m
% Created: 1/23/17
% Modified: 1/23/17
function [W_t] = total_weight(r,W_pay,W_bal,MW)
% Finds the total weight of the balloon

% Inputs: radius of the balloon (r), Weight of the Payload (W_pay), Weight
% of the empty balloon (W_bal), Molecular weight of the internal gas (MW)

% Outputs: Total weight

rho_0=1.225; %kg/m^3
W_g=((4*pi*rho_0*r^3)/3)*(MW/28.966);
W_t=W_g+W_pay+W_bal;
end

