% Script to analyze ANSYS and lab data for ASEN 3112 Lab 2

% clear workspace
close all
clear
clc

% beam properties and equivalent beam calculation
P = 50 * 4.44822;
Lb = .25;
L = 16*Lb;
E = 69.5e9;
A = pi*(.009525/2)^2 - pi*(.009525/2 - .001587)^2;
I = 4*A*(Lb/2)^2;
ue = (P*L^3) / (48*E*I);

% load lab data
data = load('truss_data.txt');

% separate into means
inds = [0; find(diff(data(:,1))~=0); length(data(:,1))];
for k = 1:length(inds)-1
    rng = inds(k)+1:inds(k+1);
    lab.lcase(k) = mean(data(rng,1));
    lab.F0(k) = mean(data(rng,2));
    lab.F1(k) = mean(data(rng,3));
    lab.F2(k) = mean(data(rng,4));
    lab.F3D(k) = mean(data(rng,5));
    lab.LVDT(k) = mean(data(rng,6));
end
clear data

% create vector to linearly interpolate ansys
scalevec = lab.lcase/max(lab.lcase);

% convert units
lab.lcase = lab.lcase * 4.44822; % lb to N
lab.F0 = lab.F0 * 4.44822; % lb to N
lab.F1 = lab.F1 * 4.44822; % lb to N
lab.F2 = lab.F2 * 4.44822; % lb to N
lab.F3D = lab.F3D * 4.44822; % lb to N
lab.LVDT = lab.LVDT * 25.4; % in to mm

% data taken from ANSYS outputs
ansys.F0 = 55.5620 * scalevec;
ansys.F1 = 55.6380 * scalevec;
ansys.F2 = (55.6380 + 55.5620) * scalevec;
ansys.F3D = E*A/Lb * (0.16224e-03 - 0.12697e-03) * scalevec;
ansys.LVDT = 1.8615 * scalevec;

% plotting specifications
line_width = 2;
font_size  = 18;
mkr_size   = 8;
set(0,'DefaultLineLineWidth' ,line_width);
set(0,'DefaultAxesFontSize'  ,font_size);
set(0,'DefaultLineMarkerSize',mkr_size);

% plot results
figure
hold on
plot(lab.lcase,[lab.F0(:) lab.F1(:) lab.F2(:)],'o');
plot(lab.lcase,[ansys.F0(:) ansys.F1(:) ansys.F2(:)],'p:')
grid on
xlabel('Applied Load [N]')
ylabel('Reaction Force [N]')
legend('F0 (lab)','F1 (lab)','F2 (lab)','F0 (ansys)','F1 (ansys)',...
    'F2 (ansys)','Location','Best')
hold off

figure
hold on
plot(lab.lcase,lab.F3D,'o',lab.lcase,ansys.F3D,'p:')
internal_fit=fit(lab.lcase(:),lab.F3D(:),'poly1');
plot(internal_fit,'b:')
grid on
xlabel('Applied Load [N]')
ylabel('Internal Force [N]')
legend('Lab data','Ansys data','Line best fit to lab','Location','Best')
hold off

figure
hold on
plot(lab.lcase,lab.LVDT,'o',lab.lcase,ansys.LVDT,'p:')
deflection_fit=fit(lab.lcase(:),lab.LVDT(:),'poly1');
plot(deflection_fit,'b:')
hline(1000*ue,'k:','Analytic Prediction')
grid on
xlabel('Applied Load [N]')
ylabel('Deflection [mm]')
legend('Lab data','Ansys data','Line best fit to data','Location','Best')