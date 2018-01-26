function [value,isterminal,direction] = event_checker(~,y)

% Detect height = 0
value = y(4)-y(5);

% Stop the integration
isterminal = 1;

% Negative direction only
direction = -1;