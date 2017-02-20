clc
close all
clear all

filename = fopen('Report_Data.txt','w');

Inviscid = xlsread('Inviscid.xls'); % Col 1 = alpha, Col 2 = C_l, Col 3 = C_d
Turbulent = xlsread('Turbulent.xls'); % Col 1 = alpha, Col 2 = C_l, Col 3 = C_d
Experimental = xlsread('NASA_DATA.xls'); % Col 1 = alpha, Col 2 = C_l
Viscous = xlsread('Viscous.xls'); % % Col 1 = alpha, Col 2 = C_l, Col 3 = C_d

Vortex_Panel(:,1) = [0 2 4 6 8 10 12 14 15];
Vortex_Panel(:,2) = [0.00000 0.23979 0.47928 0.71819 0.95622 1.19309 1.42851 1.66218 1.77828];

Thin_Airfoil(:,1) = linspace(0,15,20);
Thin_Airfoil(:,2) = (Thin_Airfoil(:,1)*pi/180)*2*pi;

%% This Figure plots all of the methods together
% figure
hold on
title('C_l vs \alpha for Various Methods')
xlabel('Angle of Attack (deg)')
ylabel('Coefficient of Lift')
plot(Inviscid(:,1),Inviscid(:,2))
plot(Turbulent(:,1),Turbulent(:,2))
plot(Experimental(:,1),Experimental(:,2))
plot(Vortex_Panel(:,1),Vortex_Panel(:,2))
plot(Thin_Airfoil(:,1),Thin_Airfoil(:,2))
plot(Viscous(:,1),Viscous(:,2))
legend('Inviscid','Turbulent','Experimental','Vortex Panel','Thin Airfoil','Viscous')
hold off

%% Comparison via percentage error

% Turbulent vs Thin Airfoil

Turbulent=Turbulent(2:end,:);
Experimental=Experimental(2:end,:);

for i = 1:(length(Turbulent) - 3)
    slope_turb(i) = (Turbulent(i+1,2) - Turbulent(i,2))/((pi/180)*((Turbulent(i+1,1) - Turbulent(i,1))));
end

Slope_turb = mean(slope_turb);
Thin_Airfoil_Slope = 2*pi;

Percent_Error1 = abs(100*(Slope_turb - Thin_Airfoil_Slope)/(Thin_Airfoil_Slope));
fprintf(filename,'Percent Error in Slope between Thin Airfoil and Turbulent: %3.4f percent\n\n',Percent_Error1);

% Inviscid vs Thin Airfoil

for i = 1:(length(Inviscid) - 1)
    slope_inv(i) = (Inviscid(i+1,2) - Inviscid(i,2))/((pi/180)*(Inviscid(i+1,1) - Inviscid(i,1)));
end

Slope_inv = mean(slope_inv);

Percent_Error2 = abs(100*(Slope_inv - Thin_Airfoil_Slope)/(Thin_Airfoil_Slope));
fprintf(filename,'Percent Error in Slope between Thin Airfoil and Inviscid: %3.4f percent\n\n',Percent_Error2);

% Viscous vs Thin Airfoil

for i = 1:(length(Viscous) - 2)
    slope_visc(i) = (Viscous(i+1,2) - Viscous(i,2))/((pi/180)*(Viscous(i+1,1) - Viscous(i,1)));
end

Slope_visc = mean(slope_visc);

Percent_Error7 = abs(100*(Slope_visc - Thin_Airfoil_Slope)/(Thin_Airfoil_Slope));
fprintf(filename,'Percent Error in Slope between Thin Airfoil and Viscous: %3.4f percent\n\n',Percent_Error7);

% Turbulent vs Vortex Panel

for i = 1:(length(Vortex_Panel) - 1)
    slope_vortex(i) = (Vortex_Panel(i+1,2) - Vortex_Panel(i,2))/((pi/180)*(Vortex_Panel(i+1,1) - Vortex_Panel(i,1)));
end

Slope_vortex = mean(slope_vortex);

Percent_Error3 = abs(100*(Slope_turb - Slope_vortex)/(Slope_vortex));
fprintf(filename,'Percent Error in Slope between Vortex Panel and Turbulent: %3.4f percent\n\n',Percent_Error3);

% Inviscid vs Vortex Panel

Percent_Error4 = abs(100*(Slope_inv - Slope_vortex)/(Slope_vortex));
fprintf(filename,'Percent Error in Slope between Vortex Panel and Inviscid: %3.4f percent\n\n',Percent_Error4);

% Viscous vs Vortex Panel

Percent_Error8 = abs(100*(Slope_visc - Slope_vortex)/(Slope_vortex));
fprintf(filename,'Percent Error in Slope between Vortex Panel and Viscous: %3.4f percent\n\n',Percent_Error8);

% Turbulent vs Experimental

for i = 1:(length(Experimental) - 1)
    slope_exp(i) = (Experimental(i+1,2) - Experimental(i,2))/((pi/180)*(Experimental(i+1,1) - Experimental(i,1)));
end

Slope_exp = mean(slope_exp);

Percent_Error5 = abs(100*(Slope_turb - Slope_exp)/(Slope_exp));
fprintf(filename,'Percent Error in Slope between Experimental and Turbulent: %3.4f percent\n\n',Percent_Error5);

% Inviscid vs Experimental

Percent_Error6 = abs(100*(Slope_inv - Slope_exp)/(Slope_exp));
fprintf(filename,'Percent Error in Slope between Experimental and Inviscid: %3.4f percent\n\n',Percent_Error6);

% Viscous vs Experimental

Percent_Error9 = abs(100*(Slope_visc - Slope_exp)/(Slope_exp));
fprintf(filename,'Percent Error in Slope between Experimental and Viscous: %3.4f percent\n\n',Percent_Error9);

%% Print other pertinent data to file

fprintf(filename,'Lift Slope of Turbulent: %3.5f\n',Slope_turb);
fprintf(filename,'Lift Slope of Inviscid: %3.5f\n',Slope_inv);
fprintf(filename,'Lift Slope of Viscous: %3.5f\n',Slope_visc);
fprintf(filename,'Lift Slope of Experimental: %3.5f\n',Slope_exp);
fprintf(filename,'Lift Slope of Vortex Panel: %3.5f\n',Slope_vortex);
fprintf(filename,'Lift Slope of Thin Airfoil Theory: %3.5f\n',Thin_Airfoil_Slope);

%% Generate Useful Plots

figure
plot(Inviscid(:,1),Inviscid(:,2))
title('Coefficients of Lift for Inviscid Flow')
xlabel('Angle of Attack (deg)')
ylabel('Coefficient of Lift')

figure
plot(Turbulent(:,1),Turbulent(:,2))
title('Coefficients of Lift for Turbulent Flow')
xlabel('Angle of Attack (deg)')
ylabel('Coefficient of Lift')

figure
plot(Viscous(:,1),Viscous(:,2))
title('Coefficients of Lift for Viscous Flow')
xlabel('Angle of Attack (deg)')
ylabel('Coefficient of Lift')

figure
plot(Turbulent(:,3),Turbulent(:,2))
title('Lift vs Drag for Turbulent Flow')
ylabel('Coefficient of Lift')
xlabel('Coefficient of Drag')

figure
plot(Inviscid(:,3),Inviscid(:,2))
title('Lift vs Drag for Inviscid Flow')
ylabel('Coefficient of Lift')
xlabel('Coefficient of Drag')

figure
hold on
title('Lift vs Drag for Viscous Flow')
ylabel('Coefficient of Lift')
xlabel('Coefficient of Drag')
plot(Viscous(:,3),Viscous(:,2))

fclose(filename);