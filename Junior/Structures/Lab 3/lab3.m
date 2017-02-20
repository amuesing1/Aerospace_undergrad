%% ASEN 3112 Lab 3 Code
% Author: Jeremy Muesing
% Date: 9/25/15

close all
clear all
clc

data_set_1=load('mode1');
data_set_2=load('mode2');
data_set_3=load('mode3');
data_set_4=load('mode4');
data_set_5=load('mode5');

%% set constants
rho=0.0002505; %lb-sec^2/in^4
MT=1.131*rho;
ST=0.5655*rho;
IT=23.124*rho;
L=12; %in
w=1; %in
h=1/8; %in
E=10175000; %psi
A=w*h;
cM2=(rho*A*L)/100800;
I_zz=(w*h^3)/12;
cK2=(4*E*I_zz)/(L^3);
cM4=(rho*A*L)/806400;
cK4=(8*E*I_zz)/L^3;


%% Two Element Method

addition=zeros(6);
addition(5,5)=MT;
addition(5,6)=ST;
addition(6,5)=ST;
addition(6,6)=IT;
M2=cM2*[19272 1458*L 5928 -642*L 0 0; 1458*L 172*L^2 642*L -73*L^2 0 0; 5928 ...
    642*L 38544 0 5928 -642*L; -642*L -73*L^2 0 344*L^2 642*L -73*L^2; ...
    0 0 5928 642*L 19272 -1458*L; 0 0 -642*L -73*L^2 -1458*L 172*L^2]+ ...
    addition;
K2=cK2*[24 6*L -24 6*L 0 0; 6*L 2*L^2 -6*L L^2 0 0; -24 -6*L 48 0 -24 6*L; ...
    6*L L^2 0 4*L^2 -6*L L^2; 0 0 -24 -6*L 24 -6*L; 0 0 6*L L^2 -6*L 2*L^2];
% reduced mass and stiffness matrix
M2=M2(3:6,3:6);
K2=K2(3:6,3:6);
omega_two_element=sqrt(eig(K2,M2));
freq_two_element=omega_two_element/(2*pi);
% omega_two_element=sqrt(M2\K2);
% freq_two_element=omega_two_element/(2*pi);


%% Four Element Method

addition2=zeros(10);
addition2(9,9)=MT;
addition2(9,10)=ST;
addition2(10,9)=ST;
addition2(10,10)=IT;
M4=cM4*[77088 2916*L 23712 -1284 0 0 0 0 0 0; 2916*L 172*L^2 1284*L ...
    -73*L^2 0 0 0 0 0 0; 23712 1284*L 154176 0 23712 -1284*L 0 0 0 0; ...
    -1284*L -73*L^2 0 344*L^2 1284*L -73*L^2 0 0 0 0; 0 0 23712 1284*L ...
    154176 0 23712 -1284*L 0 0; 0 0 -1284*L -73*L^2 0 344*L^2 1284*L ...
    -73*L^2 0 0; 0 0 0 0 23712 1284*L 154176 0 23712 -1284*L; 0 0 0 0 ...
    -1284*L -73*L^2 0 344*L^2 1284*L -73*L^2; 0 0 0 0 0 0 23712 1284*L ...
    77088 -2916*L; 0 0 0 0 0 0 -1284*L -73*L^2 -2916*L 172*L^2]+addition2;
K4=cK4*[96 12*L -96 12*L 0 0 0 0 0 0; 12*L 2*L^2 -12*L L^2 0 0 0 0 0 0; ...
    -96 -12*L 192 0 -96 12*L 0 0 0 0; 12*L L^2 0 4*L^2 -12*L L^2 0 0 0 0; ...
    0 0 -96 -12*L 192 0 -96 12*L 0 0; 0 0 12*L L^2 0 4*L^2 -12*L L^2 0 0; ...
    0 0 0 0 -96 -12*L 192 0 -96 12*L; 0 0 0 0 12*L L^2 0 4*L^2 -12*L L^2; ...
    0 0 0 0 0 0 -96 -12*L 96 -12*L; 0 0 0 0 0 0 12*L L^2 -12*L 2*L^2];
% reduced mass and stiffness matrix
M4=M4(3:10,3:10);
K4=K4(3:10,3:10);
omega_four_element=sqrt(eig(K4,M4));
freq_four_element=omega_four_element/(2*pi);
% omega_four_element=sqrt(M4\K4);
% freq_four_element=omega_four_element/(2*pi);

%% grabbing values

fprintf('The three smallest frequencies using the two element method are %3.3fHz, %3.3fHz, %3.3fHz\n',...
    freq_two_element(1), freq_two_element(2), freq_two_element(3)); 

fprintf('The three smallest frequencies using the four element method are %3.3fHz, %3.3fHz, %3.3fHz\n',...
    freq_four_element(1), freq_four_element(2), freq_four_element(3)); 

%% frequency of experimental data

for i=1:5
    clear diff
    number=num2str(i);
    set=strcat('data_set_',number);
    set=eval(set);
    for j=1:length(set)-1
        diff(j)=set(j+1,1)-set(j,1); %find time step
    end
    avg_diff=mean(diff);
    [pks,locs]=findpeaks(set(:,9)); %find number of cycles (change column # if 1st chan was not used for each trial, consult notes)
    time_indicies=max(locs)-min(locs);
    total_time=time_indicies*avg_diff;
    
    exp_freq(i)=length(pks)/total_time; %frequency of body
end
fprintf('The experimentally found frequencies for trials #2 and #5 are %3.3fHz, %3.3fHz respectively\n',...
    exp_freq(2), exp_freq(5));
