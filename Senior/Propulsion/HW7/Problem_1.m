% Compute exit conditions of the combustor for secondary air ratio from 0
% to 1 at intervals of 0.05. First compute the stagnation temperature ratio
% across the combustor for various values of secondary air ratio using the
% enthalpy balance across the combustor. Once this is known, use Eqns 5.4.4
% and 5.4.7 to compte M4 for each value. Once M4 is known, all other exit
% properties can be found.

clearvars
clc
close all

Cp = 1.37; % kJ/kg*K
Cp = Cp*1000; % J/kg*K
Cpc = Cp; % Assumption
T3 = 500; % C
T3 = T3 + 273; % K
P3 = 1; % MPa
P3 = P3*(10^6); % Pa
Rho3 = P3/(287.25*T3); % Assumption (Ideal Gas)
V3 = 150; % m/s
gamma3 = 1.27;
gamma4 = gamma3; % Assumption
a3 = sqrt(gamma3*287.25*T3);
M3 = V3/a3;
eta_b = .96;
HV = 44; % MJ/kg
HV = HV*(10^6); % J/kg
Mbar3 = 28.96; % g/mol [Molar mass of air]
Molar_Mass_Fuel = 44.10; % g/mol [Assuming hydrocarbon fuel is gaseous octane]
Mbar4 = (1-.066)*Mbar3 + 0.066*Molar_Mass_Fuel;

Mbar_Ratio = Mbar4/Mbar3;

m_dot_a = 1; % kg/s

Tt3 = T3*(1 + ((gamma3 - 1)/2)*(M3^2));

mach_count = 50000;
M4 = linspace(0.001,2,mach_count);

%% Constant Area
j = 1;
for ratio = 0:0.05:1
    
    m_dot_as = ratio*m_dot_a; % kg/s
    m_dot_ap = m_dot_a - m_dot_as; % kg/s
    m_dot_f = 0.066*m_dot_ap; % kg/s
    
    Stag_Temp_Ratio = (m_dot_a)*(1 + (m_dot_f*HV*eta_b)/(Tt3*Cpc*m_dot_a))/(m_dot_a + m_dot_f);
    
    for i = 1:(mach_count-1)
        
        Stag_Temp_Ratio_Const_Area(i) = (gamma4*Mbar4*(M4(i)^2)*((1 + gamma3*(M3^2))^2)*(1 + ((gamma4 - 1)/2)*(M4(i)^2)))/...
            (gamma3*Mbar3*(M3^2)*((1 + gamma4*(M4(i)^2))^2)*(1 + ((gamma3 - 1)/2)*(M3^2)));
        
        Stag_Temp_Ratio_Const_Area(i+1) = (gamma4*Mbar4*(M4(i+1)^2)*((1 + gamma3*(M3^2))^2)*(1 + ((gamma4 - 1)/2)*(M4(i+1)^2)))/...
            (gamma3*Mbar3*(M3^2)*((1 + gamma4*(M4(i+1)^2))^2)*(1 + ((gamma3 - 1)/2)*(M3^2)));
        
        if Stag_Temp_Ratio_Const_Area(i) < Stag_Temp_Ratio && Stag_Temp_Ratio_Const_Area(i+1) > Stag_Temp_Ratio
            break
        end
        
    end
    
    Exit_Mach(j) = M4(i);
    
    j = j+1;
end


figure(1)
hold on
subplot(2,3,1)
plot(0:0.05:1,Exit_Mach,'red')
xlabel('Secondary Air Ratio')
ylabel('Exit Mach Number')
title('Mach')
hold off

Pressure_Ratio = (1 + gamma3*(M3^2))./(1 + gamma4*(Exit_Mach.^2));
Density_Ratio = (gamma3*(M3^2)*(1 + gamma4*(Exit_Mach.^2))./...
    (gamma4*(Exit_Mach.^2)*(1 + gamma3*(M3^2))));
Temperature_Ratio = (gamma4*Mbar4*(Exit_Mach.^2)*(1 + gamma3*(M3^2))./...
    (gamma3*Mbar3*(M3^2)*(1 + gamma4*(Exit_Mach.^2))));

Exit_Pressure = Pressure_Ratio.*P3;
Exit_Density = Density_Ratio.*Rho3;
Exit_Temperature = Temperature_Ratio.*T3;
Exit_Velocity = Exit_Mach.*sqrt(1.27*287.*Exit_Temperature);

subplot(2,3,2)
plot(0:0.05:1,Exit_Pressure,'red')
xlabel('Secondary Air Ratio')
ylabel('Exit Pressure (Pa)')
title('Pressure')


subplot(2,3,3)
plot(0:0.05:1,Exit_Density,'red')
xlabel('Secondary Air Ratio')
ylabel('Exit Density (kg/m^3)')
title('Density')


subplot(2,3,4)
plot(0:0.05:1,Exit_Temperature,'red')
xlabel('Secondary Air Ratio')
ylabel('Exit Temperature (K)')
title('Temp')


subplot(2,3,5)
plot(0:0.05:1,Exit_Velocity,'red')
xlabel('Secondary Air Ratio')
ylabel('Exit Velocity (m/s)')
title('Velocity')

suptitle('Constant Area Combustor with Varied Secondary Air Ratio');
%% Constant Pressure
j = 1;
for ratio = 0:0.05:1
    
    m_dot_as = ratio*m_dot_a; % kg/s
    m_dot_ap = m_dot_a - m_dot_as; % kg/s
    m_dot_f = 0.066*m_dot_ap; % kg/s
    
    Stag_Temp_Ratio = (m_dot_a)*(1 + (m_dot_f*HV*eta_b)/(Tt3*Cpc*m_dot_a))/(m_dot_a + m_dot_f);
    
    for i = 1:(mach_count-1)
        
        Stag_Temp_Ratio_Const_Pressure(i) = (gamma3*Mbar4*(M3^2)*(1 + ((gamma4-1)/2)*(M4(i)^2)))/...
        (gamma4*Mbar3*(M4(i)^2)*(1 + ((gamma3-1)/2)*(M3^2)));
    
        Stag_Temp_Ratio_Const_Pressure(i+1) = (gamma3*Mbar4*(M3^2)*(1 + ((gamma4-1)/2)*(M4(i+1)^2)))/...
        (gamma4*Mbar3*(M4(i+1)^2)*(1 + ((gamma3-1)/2)*(M3^2)));
        
        if Stag_Temp_Ratio_Const_Pressure(i) > Stag_Temp_Ratio && Stag_Temp_Ratio_Const_Pressure(i+1) < Stag_Temp_Ratio
            break
        end
        
        
    end
    
    Exit_Mach(j) = M4(i);
    
    j = j+1;
    
end

Pressure_Ratio = 1; % Constant Pressure Combuster
Density_Ratio = (gamma3*(M3^2)*(1 + gamma4*(Exit_Mach.^2))./...
    (gamma4*(Exit_Mach.^2)*(1 + gamma3*(M3^2))));
Temperature_Ratio = (gamma4*Mbar4*(Exit_Mach.^2)*(1 + gamma3*(M3^2))./...
    (gamma3*Mbar3*(M3^2)*(1 + gamma4*(Exit_Mach.^2))));

figure
hold on
subplot(2,2,1)
plot(0:0.05:1,Exit_Mach,'red')
xlabel('Secondary Air Ratio')
ylabel('Exit Mach Number')
title('Mach')
hold off

Exit_Pressure = Pressure_Ratio.*P3;
Exit_Density = Density_Ratio.*Rho3;
Exit_Temperature = Temperature_Ratio.*T3;
Exit_Velocity = Exit_Mach.*sqrt(1.27*287.*Exit_Temperature);

subplot(2,2,2)
plot(0:0.05:1,Exit_Density,'red')
xlabel('Secondary Air Ratio')
ylabel('Exit Density (kg/m^3)')
title('Density')

subplot(2,2,3)
plot(0:0.05:1,Exit_Temperature,'red')
xlabel('Secondary Air Ratio')
ylabel('Exit Temperature (K)')
title('Temp')

subplot(2,2,4)
plot(0:0.05:1,Exit_Velocity,'red')
xlabel('Secondary Air Ratio')
ylabel('Exit Velocity (m/s)')
title('Velocity')

suptitle('Constant Pressure Combustor with Varied Secondary Air Ratio');