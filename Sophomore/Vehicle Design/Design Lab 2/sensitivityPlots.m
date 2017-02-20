% ASEN 2004 Design Lab 2
% Cody Gondek
% Date Created: 25 February 2015
% Date Modified: 25 February 2015

% Creates sensitivity plots for 5 variables and how they affect payload
% weight. 




% Payload weight calculated by:
% Wtakeoff - Wempty - Wfuel

Ct = linspace(0.1,1,10);
AR = linspace(2.5,5,10);
cruiseMach = linspace(0.7,1.3,10);
wAirframe = linspace(7000,12000,10);
S = linspace(200,400,10);

payloadCt = [14153, 13545, 12942, 12343, 11748, 11158, 10572, 9990, 9411, 8836];
payloadAR = [ 9014, 8993, 8652, 10216, 9619, 10841, 10478, 9380, 8970, 8538];
payloadCruiseMach = [8661, 8756, 8823, 8730, 8426, 8114, 8179, 8146, 8103, 8053];
payloadWAirframe = [17844, 17288, 16733, 16177, 13925, 13369, 12814, 12258, 11703, 11147];
payloadS = [13329, 13089, 12252, 10542, 10650, 8729, 8368, 8142, 7493, 7251];

baselineCt = [4614 4088 3567 3049 2535 2024 1517 1014 514 17];
baselineAR = [361 183 -29 -312 -632 -977 -1345 -1736 -2151 -2588];
baselineCruiseMach = [-2693 -2634 -2595 -2693 -2972 -3255 -3203 -3244 -3291 -3342];
baselineWAirframe = [5631 5075 4520 3964 3409 2853 2298 1742 1187 631];
baselineS = [677 570 440 293 126 -85 -294 -508 -725 -955];



figure;
plot(Ct,payloadCt)
title('Ct V. Payload');
xlabel('Thrust Specific Fuel Consumption (lb/ lbf *hr)');
ylabel('Payload (lb)');

figure
plot(Ct,baselineCt,'-r')
title('Ct V. Baseline Payload');
xlabel('Thrust Specific Fuel Consumption (lb/ lbf *hr)');
ylabel('Payload (lb)');

figure;
plot(AR,payloadAR)
title('AR V. Payload');
xlabel('Aspect Ratio');
ylabel('Payload (lb)');


figure
plot(AR,baselineAR,'-r')
title('AR V. Baseline Payload');
xlabel('Aspect Ratio');
ylabel('Payload (lb)');

figure;
plot(cruiseMach, payloadCruiseMach)
title('Cruise Mach V. Payload');
xlabel('Cruise Mach');
ylabel('Payload (lb)');

figure
plot(cruiseMach,baselineCruiseMach,'-r')
title('Cruise Mach V. Baseline Payload');
xlabel('Cruise Mach');
ylabel('Payload (lb)');

figure;
plot(wAirframe, payloadWAirframe)
title('Airframe Weight V. Payload');
xlabel('Airframe Weight (lb)');
ylabel('Payload (lb)');

figure
plot(wAirframe,baselineWAirframe,'-r')
title('Aiframe Weight V. Baseline Payload');
xlabel('Airfame Weight (lb)');
ylabel('Payload (lb)');

figure;
plot(S, payloadS)
title('Wing Area V. Payload');
xlabel('Wing Area (ft^2)');
ylabel('Payload (lb)');

figure
plot(S,baselineS,'-r')
title('Wing Area V. Baseline Payload');
xlabel('Wing Area (ft^2)');
ylabel('Payload (lb)');

