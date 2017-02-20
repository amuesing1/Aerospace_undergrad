clear all; close all; clc;
%% Part 1

data_high=csvread('Group17_WindTunnelCalibration_high.csv',4,1);
data_low=csvread('Group17_WindTunnelCalibration_low.csv',4,1);
for j=1:5
    for i=1:25
        Pinf_high(j,i)=data_high((j-1)*25+i,1);
        Pinf_low(j,i)=data_low((j-1)*25+i,1);
        VHigh(j,i)=data_high((j-1)*25+i,3);
        VLow(j,i)=data_low((j-1)*25+i,3);
        Qinf_high(j,i)=data_high((j-1)*25+i,2);
        Qinf_low(j,i)=data_low((j-1)*25+i,2);
        Rho_high(j,i)=data_high((j-1)*25+i,10);
        Rho_low(j,i)=data_low((j-1)*25+i,10);
    end
end
%standard deviation


%calculations
for j=1:25
    for i=1:5
        VHighcalc(i,j)=sqrt((2*(Pinf_high(i,j)))/Rho_high(i,j));
        VLowcalc(i,j)=sqrt((2*(Pinf_low(i,j)))/Rho_low(i,j));
    end
end
% standard deviation
sigma_VHighcalc=2*std(VHighcalc,0,2);
sigma_VLowcalc=2*std(VLowcalc,0,2);
sigma_VactualHigh=2*std(VHigh,0,2);
sigma_VactualLow=2*std(VLow,0,2);


%mean for graphs
VHighcalc=mean(VHighcalc',1);
VLowcalc=mean(VLowcalc',1);
VactualHigh=mean(VHigh',1);
VactualLow=mean(VLow',1);

diff_high=VHighcalc-VactualHigh;
diff_low=VLowcalc-VactualLow;

figure()
hold on
plot(VHighcalc,VactualHigh)
plot(VLowcalc,VactualLow)
errorbar(VHighcalc,VactualHigh,sigma_VHighcalc,'.')
errorbar(VLowcalc,VactualLow,sigma_VLowcalc,'.')
herrorbar(VHighcalc,VactualHigh,sigma_VactualHigh,'.')
herrorbar(VLowcalc,VactualLow,sigma_VactualLow,'.')
xlabel('Calculated Velocity')
ylabel('Measured Velocity')
title('Calculated vs. Measured Velocity (m/s)')
legend('Velocity Comparisons High','Velocity Comparisons Low','Error Calc High','Error Calc Low','Error Measured High','Error Measured Low')
hold off

figure()
hold on
plot(VactualHigh,diff_high)
plot(VactualLow,diff_low)
xlabel('Measured Velocity (m/s)')
ylabel('Difference between Calculated and Measured (m/s)')
legend('High','Low')
title('Calculated - Measured Velocities')
hold off
%% Part 2
counter=0;
for group=1:25
    wind={'wind'};
    clean={'clean'};
            [data1,counter,existy]=loadfiles(group,clean,wind,counter);
            if existy==1
                data.clean_wind(:,:,counter)=data1;
            end
end
counter=0;
for group=1:25
    wind={'wind'};
    clean={'loaded'};
            [data1,counter,existy]=loadfiles(group,clean,wind,counter);
            if existy==1
                data.loaded_wind(:,:,counter)=data1;
            end
end
counter=0;
for group=1:25
    wind={'nowind'};
    clean={'clean'};
            [data1,counter,existy]=loadfiles(group,clean,wind,counter);
            if existy==1
                data.clean_nowind(:,:,counter)=data1;
            end
end
counter=0;
for group=1:25
    wind={'nowind'};
    clean={'loaded'};
            [data1,counter,existy]=loadfiles(group,clean,wind,counter);
            if existy==1
                data.loaded_nowind(:,:,counter)=data1;
            end
end

%import NASA data
NASA=csvread('2004NASAdata.csv',1,2);
Cl_NASA=NASA(1,:);
Cd_NASA=NASA(3,:);

%load clean wind data from all groups and separate values into arrays
qinf_clean_wind=data.clean_wind(:,1,:);
Vinf_clean_wind=data.clean_wind(:,2,:);
angle_attack_clean_wind=data.clean_wind(:,3,:);
normal_clean_wind=data.clean_wind(:,4,:);
axial_clean_wind=data.clean_wind(:,5,:);
rho_clean_wind=data.clean_wind(:,9,:);
Pm_clean_wind=data.clean_wind(:,6,:);

%load loaded wind data into arrays
qinf_loaded_wind=data.loaded_wind(:,1,:);
Vinf_loaded_wind=data.loaded_wind(:,2,:);
angle_attack_loaded_wind=data.loaded_wind(:,3,:);
normal_loaded_wind=data.loaded_wind(:,4,:);
axial_loaded_wind=data.loaded_wind(:,5,:);
rho_loaded_wind=data.loaded_wind(:,9,:);
Pm_loaded_wind=data.loaded_wind(:,6,:);

%load clean no wind data into arrays
qinf_clean_nowind=data.clean_nowind(:,1,:);
Vinf_clean_nowind=data.clean_nowind(:,2,:);
angle_attack_clean_nowind=data.clean_nowind(:,3,:);
normal_clean_nowind=data.clean_nowind(:,4,:);
axial_clean_nowind=data.clean_nowind(:,5,:);
rho_clean_nowind=data.clean_nowind(:,9,:);
Pm_clean_nowind=data.clean_nowind(:,6,:);

%load loaded no wind data into array
qinf_loaded_nowind=data.loaded_nowind(:,1,:);
Vinf_loaded_nowind=data.loaded_nowind(:,2,:);
angle_attack_loaded_nowind=data.loaded_nowind(:,3,:);
normal_loaded_nowind=data.loaded_nowind(:,4,:);
axial_loaded_nowind=data.loaded_nowind(:,5,:);
rho_loaded_nowind=data.loaded_nowind(:,9,:);
Pm_loaded_nowind=data.loaded_nowind(:,6,:);

% constants
S=28*(1/48^2); %m^2
A_clean=0.01697; %m
A_loaded=0.01686; %m
c=3.45034*(1/48); %m
c_full=3.45034; %m

%subtract calibration
for i=1:23
    qinf_clean(i,:)=data.clean_wind(i,1,:)-data.clean_nowind(i,1,:);
    Vinf_clean(i,:)=data.clean_wind(i,2,:)-data.clean_nowind(i,2,:);
    angle_attack_clean(i,:)=data.clean_wind(i,3,:);
    normal_clean(i,:)=data.clean_wind(i,4,:)-data.clean_nowind(i,4,:);
    axial_clean(i,:)=data.clean_wind(i,5,:)-data.clean_nowind(i,5,:);
    qinf_loaded(i,:)=data.loaded_wind(i,1,:)-data.loaded_nowind(i,1,:);
    Vinf_loaded(i,:)=data.loaded_wind(i,2,:)-data.loaded_nowind(i,2,:);
    angle_attack_loaded(i,:)=data.loaded_wind(i,3,:);
    normal_loaded(i,:)=data.loaded_wind(i,4,:)-data.loaded_nowind(i,4,:);
    axial_loaded(i,:)=data.loaded_wind(i,5,:)-data.loaded_nowind(i,5,:);
    Pm_clean(i,:)=data.clean_wind(i,6,:)-data.clean_nowind(i,6,:);
    Pm_loaded(i,:)=data.loaded_wind(i,6,:)-data.loaded_nowind(i,6,:);
    rho_clean(i,:)=data.clean_wind(i,9,:);
    rho_loaded(i,:)=data.loaded_wind(i,9,:);
end

%standard deviation
for i=1:23
    lift_clean(i,:)=normal_clean(i,:).*cosd(angle_attack_clean(i,:))+axial_clean(i,:).*sind(angle_attack_clean(i,:));
    drag_clean(i,:)=normal_clean(i,:).*sind(angle_attack_clean(i,:))+axial_clean(i,:).*cosd(angle_attack_clean(i,:));
    Cd_clean(i,:)=drag_clean(i,:)./(qinf_clean(i,:).*S);
    Cl_clean(i,:)=lift_clean(i,:)./(qinf_clean(i,:).*S);
    moment_clean(i,:)=Pm_clean(i,:)-normal_clean(i,:)*A_clean;
    Cm_clean(i,:)=moment_clean(i,:)./(qinf_clean(i,:).*S*c);
    lift_loaded(i,:)=normal_loaded(i,:).*cosd(angle_attack_loaded(i,:))+axial_loaded(i,:).*sind(angle_attack_loaded(i,:));
    drag_loaded(i,:)=normal_loaded(i,:).*sind(angle_attack_loaded(i,:))+axial_loaded(i,:).*cosd(angle_attack_loaded(i,:));
    Cd_loaded(i,:)=drag_loaded(i,:)./(qinf_loaded(i,:).*S);
    Cl_loaded(i,:)=lift_loaded(i,:)./(qinf_loaded(i,:).*S);
    moment_loaded(i,:)=Pm_loaded(i,:)-normal_loaded(i,:)*A_loaded;
    Cm_loaded(i,:)=moment_loaded(i,:)./(qinf_loaded(i,:).*S*c);
end
sigma_Cl_clean=2*std(Cl_clean,0,2);
sigma_Cd_clean=2*std(Cd_clean,0,2);
sigma_Cm_clean=2*std(Cm_clean,0,2);
sigma_Cl_loaded=2*std(Cl_loaded,0,2);
sigma_Cd_loaded=2*std(Cd_loaded,0,2);
sigma_Cm_loaded=2*std(Cm_loaded,0,2);


%average
qinf_clean=mean(qinf_clean',1);
Vinf_clean=mean(Vinf_clean',1);
angle_attack_clean=mean(angle_attack_clean',1);
normal_clean=mean(normal_clean',1);
axial_clean=mean(axial_clean',1);
qinf_loaded=mean(qinf_loaded',1);
Vinf_loaded=mean(Vinf_loaded',1);
angle_attack_loaded=mean(angle_attack_loaded',1);
normal_loaded=mean(normal_loaded',1);
axial_loaded=mean(axial_loaded',1);
Pm_clean=mean(Pm_clean',1);
Pm_loaded=mean(Pm_loaded',1);
rho_clean=mean(rho_clean);
rho_clean=mean(rho_clean);
rho_loaded=mean(rho_loaded);
rho_loaded=mean(rho_loaded);

% Calulations
lift_clean=normal_clean.*cosd(angle_attack_clean)+axial_clean.*sind(angle_attack_clean);
drag_clean=normal_clean.*sind(angle_attack_clean)+axial_clean.*cosd(angle_attack_clean);
Cd_clean=drag_clean./(qinf_clean.*S);
Cl_clean=lift_clean./(qinf_clean.*S);
moment_clean=Pm_clean-normal_clean*A_clean;
Cm_clean=moment_clean./(qinf_clean.*S*c);
lift_loaded=normal_loaded.*cosd(angle_attack_loaded)+axial_loaded.*sind(angle_attack_loaded);
drag_loaded=normal_loaded.*sind(angle_attack_loaded)+axial_loaded.*cosd(angle_attack_loaded);
Cd_loaded=drag_loaded./(qinf_loaded.*S);
Cl_loaded=lift_loaded./(qinf_loaded.*S);
moment_loaded=Pm_loaded-normal_loaded*A_loaded;
Cm_loaded=moment_loaded./(qinf_loaded.*S*c);

% corrections
angle_attack_clean=angle_attack_clean+1.5*Cl_clean;
angle_attack_loaded=angle_attack_loaded+1.5*Cl_loaded;
Cd_clean=Cd_clean+0.02*Cl_clean.^2;
Cd_loaded=Cd_loaded+0.02*Cl_loaded.^2;

% question 3
S_full=28; %m^2
weight_full=100085; %Newtons
weight_model_clean=2.15; %Newtons
weight_model_loaded=2.48; %Newtons
V_landing_model_clean=1.3*sqrt((2*weight_model_clean)/(rho_clean*S*max(Cl_clean)))
V_landing_model_loaded=1.3*sqrt((2*weight_model_loaded)/(rho_loaded*S*max(Cl_loaded)))

% question 4
viscosity=.000017894; %kg/ms
Re_model=(rho_clean*mean(Vinf_clean)*c)/viscosity;
[T,a,p,rholab]=atmosisa(20000); %finding density at height of actual f-16
V_full=(Re_model*viscosity)/(rho_clean*c_full)
V_landing_full_clean=1.3*sqrt((2*weight_full)/(rho_clean*S_full*max(Cl_clean)));

% question 5
Cm_a_clean=(Cm_clean(6)-Cm_clean(5))/(angle_attack_clean(6)-angle_attack_clean(5))
Cm_a_loaded=(Cm_loaded(6)-Cm_loaded(5))/(angle_attack_loaded(6)-angle_attack_loaded(5))

% Cl vs alpha
figure()
hold on
plot(angle_attack_clean,Cl_clean)
plot(angle_attack_loaded,Cl_loaded,'r')
errorbar(angle_attack_clean,Cl_clean,sigma_Cl_clean,'.')
errorbar(angle_attack_loaded,Cl_loaded,sigma_Cl_loaded,'.')
xlabel('Angle of Attack (Deg)')
ylabel('Cl')
legend('Clean','Loaded','Error Clean','Error Loaded')
title('Coeffcient of Lift vs. Angle of Attack')
hold off

% Cd vs Alpha
figure()
hold on
plot(angle_attack_clean,Cd_clean)
plot(angle_attack_loaded,Cd_loaded,'r')
errorbar(angle_attack_clean,Cd_clean,sigma_Cd_clean,'.')
errorbar(angle_attack_loaded,Cd_loaded,sigma_Cd_loaded,'.')
xlabel('Angle of Attack (Deg)')
ylabel('Cd')
legend('Clean','Loaded','Error Clean','Error Loaded')
title('Coeffcient of Drag vs. Angle of Attack')
hold off

%Cm vs Alpha
figure()
hold on
plot(angle_attack_clean,Cm_clean)
plot(angle_attack_loaded,Cm_loaded,'r')
errorbar(angle_attack_clean,Cm_clean,sigma_Cm_clean,'.')
errorbar(angle_attack_loaded,Cm_loaded,sigma_Cm_loaded,'.')
xlabel('Angle of Attack (Deg)')
ylabel('Cm')
legend('Clean','Loaded','Error Clean','Error Loaded')
title('Coeffcient of Moment vs. Angle of Attack')
hold off

%drag polar
figure()
hold on
grid on
plot(Cl_clean,Cd_clean)
plot(Cl_loaded,Cd_loaded,'r')
plot(Cl_NASA,Cd_NASA,'LineWidth',2)
errorbar(Cl_clean,Cd_clean,sigma_Cd_clean,'.')
errorbar(Cl_loaded,Cd_loaded,sigma_Cd_loaded,'.')
xlabel('Cl')
ylabel('Cd')
legend('Clean','Loaded','NASA Data','Error Clean','Error Loaded')
title('Drag Polar')
hold off

% for design lab
% figure()
% for i=1:12
%     lift_clean_wind(:,:,i)=normal_clean_wind(:,:,i).*cosd(angle_attack_clean_wind(:,:,i))+axial_clean_wind(:,:,i).*sind(angle_attack_clean_wind(:,:,i));
%     drag_clean_wind(:,:,i)=normal_clean_wind(:,:,i).*sind(angle_attack_clean_wind(:,:,i))+axial_clean_wind(:,:,i).*cosd(angle_attack_clean_wind(:,:,i));
%     Cd_clean_wind(:,:,i)=drag_clean_wind(:,:,i)./(qinf_clean_wind(:,:,i).*S);
%     Cl_clean_wind(:,:,i)=lift_clean_wind(:,:,i)./(qinf_clean_wind(:,:,i).*S);
%     Cd_comparison_clean(:,:,i)=0.01920+0.1168*(Cl_clean_wind(:,:,i).^2)-.0061*Cl_clean_wind(:,:,i);
%     hold on
%     plot(Cd_clean_wind(:,:,i),Cl_clean_wind(:,:,i))
%     plot(Cd_comparison_clean(:,:,i),Cl_clean_wind(:,:,i))
%     xlabel('Cl')
%     ylabel('Cd')
%     title('Drag Polar Clean')
% end
% hold off
% 
% figure()
% for i=1:13
%     lift_loaded_wind(:,:,i)=normal_loaded_wind(:,:,i).*cosd(angle_attack_loaded_wind(:,:,i))+axial_loaded_wind(:,:,i).*sind(angle_attack_loaded_wind(:,:,i));
%     drag_loaded_wind(:,:,i)=normal_loaded_wind(:,:,i).*sind(angle_attack_loaded_wind(:,:,i))+axial_loaded_wind(:,:,i).*cosd(angle_attack_loaded_wind(:,:,i));
%     Cd_loaded_wind(:,:,i)=drag_loaded_wind(:,:,i)./(qinf_loaded_wind(:,:,i).*S);
%     Cl_loaded_wind(:,:,i)=lift_loaded_wind(:,:,i)./(qinf_loaded_wind(:,:,i).*S);
%     Cd_comparison_loaded(:,:,i)=0.01920+0.1168*(Cl_loaded_wind(:,:,i).^2)-.0061*Cl_loaded_wind(:,:,i);
%     hold on
%     plot(Cd_loaded_wind(:,:,i),Cl_loaded_wind(:,:,i))
%     plot(Cd_comparison_loaded(:,:,i),Cl_loaded_wind(:,:,i))
%     xlabel('Cl')
%     ylabel('Cd')
%     title('Drag Polar Loaded')
% end
% hold off
% 
% %averaged graphs
% lift_clean=normal_clean.*cosd(angle_attack_clean)+axial_clean.*sind(angle_attack_clean);
% drag_clean=normal_clean.*sind(angle_attack_clean)+axial_clean.*cosd(angle_attack_clean);
% Cd_clean=drag_clean./(qinf_clean.*S);
% Cl_clean=lift_clean./(qinf_clean.*S);
% Cd_comparison_clean=0.01920+0.1168*(Cl_clean.^2)-.0061*Cl_clean;
% lift_loaded=normal_loaded.*cosd(angle_attack_loaded)+axial_loaded.*sind(angle_attack_loaded);
% drag_loaded=normal_loaded.*sind(angle_attack_loaded)+axial_loaded.*cosd(angle_attack_loaded);
% Cd_loaded=drag_loaded./(qinf_loaded.*S);
% Cl_loaded=lift_loaded./(qinf_loaded.*S);
% Cd_comparison_loaded=0.01920+0.1168*(Cl_loaded.^2)-.0061*Cl_loaded;
% 
% %Actual F-16 data
% Cd_02=0.0197+0.122*(Cl_clean.^2)-0.007*Cl_clean;
% Cd_875=0.0205+0.128*(Cl_clean.^2)-0.007*Cl_clean;
% Cd_105=0.0444+0.21*(Cl_clean.^2)-0.003*Cl_clean;
% Cd_16=0.0461+0.34*(Cl_clean.^2);
% Cd_2=0.0458+0.122*(Cl_clean.^2);
% 
% 
% 
% figure()
% hold on
% plot(Cd_clean,Cl_clean,'LineWidth',3)
% plot(Cd_comparison_clean,Cl_clean)
% plot(Cd_NASA,Cl_NASA)
% plot(Cd_02,Cl_clean)
% plot(Cd_875,Cl_clean)
% plot(Cd_105,Cl_clean)
% plot(Cd_16,Cl_clean)
% plot(Cd_2,Cl_clean)
% xlabel('Cl')
% ylabel('Cd')
% title('Drag Polar Clean')
% legend('Average Value of all Groups','Calculated Value M=0.1','NASA data M=1.6','Actual M=0.02','Actual M=0.875','Actual M=1.05','Actual M=1.6','Actual M=2')
% hold off
% 
% figure()
% hold on
% plot(Cd_loaded,Cl_loaded,'LineWidth',3)
% plot(Cd_comparison_loaded,Cl_loaded)
% plot(Cd_NASA,Cl_NASA)
% plot(Cd_02,Cl_clean)
% plot(Cd_875,Cl_clean)
% plot(Cd_105,Cl_clean)
% plot(Cd_16,Cl_clean)
% plot(Cd_2,Cl_clean)
% xlabel('Cl')
% ylabel('Cd')
% title('Drag Polar Loaded')
% legend('Average Value of all Groups','Calculated Value M=0.1','NASA data M=1.6','Actual M=0.02','Actual M=0.875','Actual M=1.05','Actual M=1.6','Actual M=2')
% hold off
