close all
clear all
clc

%% Part A

% Known Values
K = [1000 -1000; -1000 2000]; % kips/in
M = [2 0; 0 3]; % kip-sec^2/in

% syms Omega_Squared
% det(K - (Omega_Squared)*M)

% Frequencies
omega1 = 10*sqrt(5/3);
omega2 = 10*sqrt(10);

f1 = omega1/(2*pi);
f2 = omega2/(2*pi);

T1 = 1/f1;
T2 = 1/f2;

%% Part B

% Find the eigenvectors
[xi, lambda] = eig(K,M);

% Solve for eigenvalues, phi
Holder_Matrix = (K - (omega1^2)*M);
% syms U12
% Holder_Matrix * [1; U12]
U11 = 1;
U12 = (2/3);
Phi1 = [U11; U12];

Holder_Matrix2 = (K - (omega2^2)*M);
% syms U22
% Holder_Matrix2 * [1; U22]

U21 = 1;
U22 = -1;
Phi2 = [U21; U22];

% Check if orthogonal
if Phi1'*M*Phi2 < 1E-9 && Phi1'*K*Phi2 < 1E-9
    fprintf('Orthogonal to M and K\n')
end

M1 = Phi1'*M*Phi1;
M2 = Phi2'*M*Phi2;
K1 = Phi1'*K*Phi1;
K2 = Phi2'*K*Phi2;

c1 = sqrt(3/10);
c2 = sqrt(1/5);
Phi1 = Phi1*c1;
Phi2 = Phi2*c2;

Nodal_Matrix = [Phi1(1) Phi2(1); Phi1(2) Phi2(2)];

%% Part C

% Particular = (F/(omega^2 - Omega^2))*(sin(Omega*t) - (Omega/omega)*sin(omega*t));
u_0 = [2;1];
v_0 = [0;0];
eta_0 = Nodal_Matrix'*M*u_0;

eta_dot_0 = Nodal_Matrix'*M*v_0;

% syms t
% eta_H_1 = eta_0(1)*cos(omega1*t);
% eta_H_2 = eta_0(2)*cos(omega2*t);
% eta_Mat = [eta_H_1; eta_H_2];
% u_t = Nodal_Matrix*eta_Mat

time = linspace(0,2,1000);

u_t_1_vals = cos(10*10^(1/2)*time)/5 + (3*3^(1/2)*5^(1/2)*6^(1/2)*10^(1/2)*cos((10*3^(1/2)*5^(1/2)*time)/3))/50;
u_t_2_vals = (2^(1/2)*5^(1/2)*6^(1/2)*15^(1/2)*cos((10*3^(1/2)*5^(1/2)*time)/3))/25 - cos(10*10^(1/2)*time)/5;
figure
hold on
plot(time,u_t_1_vals)
plot(time,u_t_2_vals)
xlabel('Time (s)')
ylabel('Displacement (in')
title('Displacement of Unforced System (Part C)')
legend('u_1','u_2')
hold off

%% Part D
Omega = 10; % rad/s

% syms t
% F = 24*sin(Omega*t);
% Particular = (F/(omega1^2 - Omega^2))*(sin(Omega*t) - (Omega/omega1)*sin(omega1*t));
% new_u_matrix = Nodal_Matrix*[Particular;0];

u_1_forced = (9*3^(1/2)*10^(1/2)*sin(10*time).*(sin(10*time) - (3^(1/2)*5^(1/2)*sin((10*3^(1/2)*5^(1/2)*time)/3))/5))/250;
u_2_forced = (3*2^(1/2)*15^(1/2)*sin(10*time).*(sin(10*time) - (3^(1/2)*5^(1/2)*sin((10*3^(1/2)*5^(1/2)*time)/3))/5))/125;

figure
hold on
plot(time,u_1_forced)
plot(time,u_2_forced)
xlabel('Time (s)')
ylabel('Displacement (in)')
title('Displacement of the Forced System (Part D)')
legend('u_1','u_2')
hold off

%% Part E
u_0 = [0;0;0];
v_0 = [0;0;0];

% syms t Omega_E
% p2 = 2000*sin(Omega_E*t);
% % Base_Movement = 2*sin(Omega_E*t);
% eta_p2 = (p2/(omega2^2 - Omega_E^2))*(sin(Omega_E*t) - (Omega_E/omega2)*sin(omega2*t));
% U_Earthquake = Nodal_Matrix*[0;eta_p2];
f_number = linspace(0.5,10,100);
j = 1;
for frequency = f_number
    Omega_E = frequency*2*pi;
    i = 1;
    for time = linspace(0,2,100)
U1(i) = -(400*5^(1/2)*sin(Omega_E*time)*(sin(Omega_E*time) - (10^(1/2)*Omega_E*sin(10*10^(1/2)*time))/100))/(Omega_E^2 - 1000);
U2(i) =  (400*5^(1/2)*sin(Omega_E*time)*(sin(Omega_E*time) - (10^(1/2)*Omega_E*sin(10*10^(1/2)*time))/100))/(Omega_E^2 - 1000);
    i = i + 1;
    end
    Max_Disp_1(j) = max(abs(U1));
    Max_Disp_2(j) = max(abs(U2));
%     fprintf('Freq = %2.5f \n',frequency);
    j = j+1;
end

figure
hold on
loglog(f_number*2*pi,Max_Disp_1,'LineWidth',3)
loglog(f_number*2*pi,Max_Disp_2)
xlabel('Frequency (Hz)')
ylabel('Maximum Displacement (in)')
title('Maximum Displacement for Varying Base Frequencies (Part E)')
hold off
