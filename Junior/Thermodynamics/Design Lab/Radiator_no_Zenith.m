close all
clear all
clc
% ASEN 3113 Design Lab 1


%% Set the scene with some situational values
% Backload_Status = 'Equinox';
time_step = 30; % sec
Time_Period = 24; % hours
Time_Period = Time_Period*3600; % seconds
Counter = 1;
% Other constants
Instrument_Conduction = 20; % W
SBconstant = 5.6704*(10^(-8)); % W/(m^2 K^4)
axial_tilt = 23.44; % degrees
axial_tilt = degtorad(axial_tilt); % rad
Solar_Constant = 1.366 * (10^3); % W/m^2

% Aluminum as a body, white paint coating
emissivity = 0.85; % Constant [Value for WHITE PAINT]
solar_absorbtivity = 0.2; % Constant [Value for WHITE PAINT]
IR_absorbtivity = 0.85; % [Value for WHITE PAINT]
specific_heat = 0.91; % kJ/(kg*K) [Value for ALUMINUM]
density = 2700; % kg/m^3 [Value for ALUMINUM]

%% Pick Variable to change
Chosen_Volume = 0.0021; % m^3
% Chosen_Thickness = 0.2; % m
Chosen_Status = [1 2 3];
figure
hold on
%% Run the actual loop to find the temperatures throughout the orbit
for Chosen_Variable = Chosen_Status
    clear Backload_Status
    if Chosen_Variable == 1
        Backload_Status = 'Winter Solstice';
    elseif Chosen_Variable == 2
        Backload_Status = 'Summer Solstice';
    elseif Chosen_Variable == 3
        Backload_Status = 'Equinox';
    else
        error('Wrong Backload Status!!');
    end
    % Find the Backload Radiation and radius to sun based on the satellite's
    % position in orbit
    if 1 == strcmp(Backload_Status,'Winter Solstice')
        Backload_main = 88; % W/m^2
        R_to_sun = 0.983; % AU
    end
    if 1 == strcmp(Backload_Status,'Summer Solstice')
        Backload_main = 63; % W/m^2
        R_to_sun = 1.017; % AU
    end
    if 1 == strcmp(Backload_Status,'Equinox')
        Backload_main = (88+63)/2; % W/m^2
        R_to_sun = 1; % AU
    end
    
    %% Find the incident angles (Only dependent on time of year!!)
    incidents = Exp_Orbit(Time_Period/time_step,Backload_Status);
    
    op_count = 1;
    Sensitive_Var(Counter) = Chosen_Variable;
    % Radiatior Size
    Base = Chosen_Volume^(1/3); % m
    Height = Chosen_Volume^(1/3); % m
    Thickness = Chosen_Volume^(1/3); % m
    Base_Area = Base*Height; % m^2
    
    Volume = Base_Area*Thickness; % m^3
    Mass = density*Volume; % kg
    Surface_Area = Base*Height + 2*Height*Thickness + 2*Base*Thickness; % m^2
    
    %% Find the heat exchanges and temperature changes
    J = size(incidents);
    for i = 1:J(1)
        for j = 1:J(2)
            if incidents(i,j) < 0
                incidents(i,j) = 0;
            end
        end
    end
    Temperature(1) = 293; % K
    i = 1;
    for time = linspace(0,Time_Period,Time_Period/time_step) % seconds
        
        incident_dot_back = incidents(i,2);
        incident_dot_top = incidents(i,3);
        incident_dot_bottom = incidents(i,4);
        incident_dot_left = incidents(i,5);
        incident_dot_right = incidents(i,6);
        if incidents(i,:) == 0
            Backload_main = 11;
        elseif 1 == strcmp(Backload_Status,'Winter Solstice')
            Backload_main = 88; % W/m^2
        elseif 1 == strcmp(Backload_Status,'Summer Solstice')
            Backload_main = 63; % W/m^2
        elseif 1 == strcmp(Backload_Status,'Equinox')
            Backload_main = (88+63)/2; % W/m^2
        end
        
        Solar_intensity(i) = Solar_Constant*(R_to_sun^2);
        
        QdS_back = Solar_intensity(i)*incident_dot_back*solar_absorbtivity*Base_Area; % Panel Opposing Velocity Vector
        
        QdS_top = Solar_intensity(i)*incident_dot_top*solar_absorbtivity*Base*Thickness; % Panel pointing up toward north pole
        
        QdS_bottom = Solar_intensity(i)*incident_dot_bottom*solar_absorbtivity*Base*Thickness; % Panel pointing up toward south pole
        
        QdS_left = Solar_intensity(i)*incident_dot_left*solar_absorbtivity*Height*Thickness; % Panel pointing up toward earth
        
        QdS_right = Solar_intensity(i)*incident_dot_right*solar_absorbtivity*Height*Thickness; % Panel pointing up toward space
        
        Q_dot_Solar_absorb(i) = QdS_back + QdS_top + QdS_bottom + QdS_left + QdS_right;
        
        Q_dot_SC_absorb = IR_absorbtivity*Backload_main*Surface_Area + Instrument_Conduction;
        
        Solar_Flux(i) = Q_dot_Solar_absorb(i)/Surface_Area;
        
        Q_dot_emit = emissivity*SBconstant*Surface_Area*(Temperature(i)^4); % Heat exchange from the radiator
        if Temperature(i) <= 294 && Backload_main > 11
            Q_dot_added(i) = 10;
        elseif Temperature(i) <= 233 && Backload_main == 11
            Q_dot_added(i) = 10;
        else
            Q_dot_added(i) = 0;
        end
        Q_dot_total = Q_dot_Solar_absorb(i) + Q_dot_SC_absorb + Q_dot_added(i) - Q_dot_emit; % Total heat exchange per second
        
        Heat_Exchange(i) = Q_dot_total*time_step; % Total heat exchange
        
        Temperature_Change = Heat_Exchange(i)/(specific_heat*1000*Mass); % Temperature change
        
        Temperature(i+1) = Temperature(i) + Temperature_Change; % New Temperature
        
        i = i + 1;
    end
    
    Counter = Counter + 1;
    
    plot(linspace(0,Time_Period,Time_Period/time_step)/3600,Temperature(1:end - 1))
end
title('Temperature Over Time','FontSize',26)
xlabel('Hour','FontSize',22)
ylabel('Temperature (K)','FontSize',22)
ylim([289 303])
h_legend = legend('Winter Solstice','Summer Solstice','Equinox');
set(h_legend,'FontSize',18)
hold off
% average_wattage = mean(Q_dot_added);
% Energy_Given = mean(Q_dot_added)*time_step*length(Q_dot_added);
% figure
% hold on
% plot(Sensitive_Var,MAX_T_op,'red')
% plot(Sensitive_Var,MIN_T_op,'blue')
% title('Max and Min Temps')
% xlabel('Sensitivity')
% ylabel('Temperature (K)')
% axis([min(Sensitive_Var) max(Sensitive_Var) 200 350])
% line([min(Sensitive_Var) max(Sensitive_Var)],[293 293])
% line([min(Sensitive_Var) max(Sensitive_Var)],[303 303])
% hold off

% figure
% plot(linspace(0,Time_Period,Time_Period/time_step)/3600,Temperature(1:end-1))
% xlabel('Time (Hours)')
% ylabel('Temperature (K)')
% figure
% hold on
% plot(linspace(0,Time_Period,Time_Period/time_step)/3600,Temperature(1:end-1) - 273);
% title('Temperature Over Time')
% xlabel('Time (Hours)')
% ylabel('Temperature (C)')
% hold off
%
% figure
% hold on
% plot(linspace(0,Time_Period,Time_Period/time_step)/3600,Solar_Flux);
% title('Solar Intensity')
% xlabel('Time (Hours)')
% ylabel('W/m^2')
% hold off
%
% figure
% hold on
% plot(linspace(0,Time_Period,Time_Period/time_step)/3600,Heat_Exchange);
% title('Heat Exchange')
% xlabel('Time (Hours)')
% ylabel('W')
% hold off