%% Design Lab 1
% Group 6
% Last Updated: 28 January

clc
clear all
close all

%% Variables
n=20;
Mach = 1.8;
R = 4000; %nm
Payload = 4000; %lbs
AR = 4;
Alt = 35000;
Ct = 0.8;
E = .5; %hours
S = .5:(.2/n):.7;

i=1;
for Mach = .2:(1.8/n):2
Wto_Mach(i,:) = mainFunction1(Mach,R,S,AR,Alt,Payload,Ct,E);
Mach_array(i)=Mach;
i=i+1;
end
Mach=1.8;

i=1;
for R = 3000:(2000/n):5000
Wto_R(i,:) = mainFunction1(Mach,R,S,AR,Alt,Payload,Ct,E);
R_array(i)=R;
i=i+1;
end
R=4000;

i=1;
for Payload = 3000:(2000/n):5000
Wto_Payload(i,:) = mainFunction1(Mach,R,S,AR,Alt,Payload,Ct,E);
Payload_array(i)=Payload;
i=i+1;
end
Payload=4000;

i=1;
for AR = 1:(14/n):15
Wto_AR(i,:) = mainFunction1(Mach,R,S,AR,Alt,Payload,Ct,E);
AR_array(i)=AR;
i=i+1;
end
AR=4;

i=1;
for Alt = 25000:(20000/n):45000
Wto_Alt(i,:) = mainFunction1(Mach,R,S,AR,Alt,Payload,Ct,E);
Alt_array(i)=Alt;
i=i+1;
end
Alt=35000;

%% Graphing

figure
surf(S,Mach_array,Wto_Mach)
xlabel('Structural Factor')
ylabel('Mach Number')
zlabel('Take off Weight (lbs)')
title('Varying Mach Number')

figure
surf(S,R_array,Wto_R)
xlabel('Structural Factor')
ylabel('Range (nm)')
zlabel('Take off Weight (lbs)')
title('Varying Range')

figure
surf(S,Payload_array,Wto_Payload)
xlabel('Structural Factor')
ylabel('Payload (lbs)')
zlabel('Take off Weight (lbs)')
title('Varying Payload')

figure
surf(S,AR_array,Wto_AR)
xlabel('Structural Factor')
ylabel('Aspect Ratio')
zlabel('Take off Weight (lbs)')
title('Varying Aspect Ratio')

figure
surf(S,Alt_array,Wto_Alt)
xlabel('Structural Factor')
ylabel('Cruising Altitude (ft)')
zlabel('Take off Weight (lbs)')
title('Varying Cruise Altitude')

