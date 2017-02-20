% Problem 2
clear all
close all
clc
%% Part b
k1 = 1600;
k2 = 600;
k3 = 3200;
m1 = 1;
m2 = 2;
c1 = 0;
c2 = 0;
c3 = 0;
p1 = 0;
p2 = 0;
M = [m1 0; 0 m2];
K = [(k1 + k2) -k2; -k2 (k2 + k3)];
% C = [(c1 + c2) -c2; -c2 (c2 + c3)];
p = [p1;p2];

% syms Omega_Squared
% det(K - (Omega_Squared*M))

omega1 = sqrt(1600);
omega2 = sqrt(2500);

% Solve for eigenvalues, phi
% Holder_Matrix = (K - (omega1^2)*M);
% syms U12 U22
% Holder_Matrix * [1; U12]
U11 = 1;
U12 = 1;
Phi1 = [U11; U12];

% Holder_Matrix2 = (K - (omega2^2)*M);
% syms
% Holder_Matrix2 * [1; U22]
U21 = 1;
U22 = -1/2;
Phi2 = [U21; U22];

% if abs(Phi1'*M*Phi2) < 1E-9 && abs(Phi1'*K*Phi2) < 1E-9
%     fprintf('Orthogonal to M and K\n')
% end

% M1 = Phi1'*M*Phi1;
% M2 = Phi2'*M*Phi2;
% K1 = Phi1'*K*Phi1;
% K2 = Phi2'*K*Phi2;

% syms c1 c2
% c1^2 * Phi1' * M * Phi1 - 1
% c2^2 * Phi2' * M * Phi2 - 1

c1 = sqrt(1/3);
c2 = sqrt(2/3);
Phi1 = Phi1*c1;
Phi2 = Phi2*c2;

Modal_Matrix = [Phi1(1) Phi2(1); Phi1(2) Phi2(2)];

%% Part c

C = (1/3)*[28 -4; -4 52];

a_0 = 40/9;
a_1 = 1/450;

%% Part d

C_g = (Modal_Matrix') * C * Modal_Matrix;