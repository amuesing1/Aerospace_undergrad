% Jeremy Muesing
% ASEN 4057
% max_h.m
% Created: 1/23/17
% Modified: 1/23/17
function [max_h] = max_h(r,W_pay,W_bal,MW)
% Computes the maximum height a balloon can achieve

% Inputs: radius of balloon (r), Weight of payload (W_pay), Weight of empty
% balloon (W_bal), Molecular weight of internal gas (MW)

% Outputs: maximum height

% Computes the total weight of the balloon
W_t=total_weight(r,W_pay,W_bal,MW);

% Initial condition to begin while loop. Because it is decreasing, the
% value can't be 0
W_air=W_t+1;
h=0;
while W_air>W_t
    W_air=displace(r,h);
    h=h+10;
end
% Once the value is reached, the loop adds 10 more meters. Those are taken
% away
max_h=h-10;
end

