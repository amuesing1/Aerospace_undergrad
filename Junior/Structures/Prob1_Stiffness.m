% Aaron McCusker
% Jeremy Muesing
% Dustin Fishelman

%% Define Constants
E = 3000;
L = 30;
P = -100;
A14 = 2;
A24 = 4;
A34 = 3;
Force = -100; % Y dir

%% Globalize
psi = degtorad(0);
L_14 = L;
c = cos(psi);
s = sin(psi);

K_temp = [c^2 s*c -c^2 -s*c; ...
    s*c s^2 -s*c -s^2; ...
    -c^2 -s*c c^2 s*c; ...
    -s*c -s^2 s*c s^2];
K14 = K_temp*((E*A14)/L_14);
T_14 = [c s 0 0; ...
    -s c 0 0; ...
    0 0 c s; ...
    0 0 -s c];

psi = degtorad(30);
L_24 = sqrt(L^2 + (L/sqrt(3))^2);
c = cos(psi);
s = sin(psi);

K_temp = [c^2 s*c -c^2 -s*c; ...
    s*c s^2 -s*c -s^2; ...
    -c^2 -s*c c^2 s*c; ...
    -s*c -s^2 s*c s^2];
K24 = K_temp*((E*A24)/L_24);
T_24 = [c s 0 0; ...
    -s c 0 0; ...
    0 0 c s; ...
    0 0 -s c];

psi = degtorad(120);
L_34 = sqrt(L^2 + (L/sqrt(3))^2) * (sin(degtorad(30)) / sin(degtorad(60)));
c = cos(psi);
s = sin(psi);

K_temp = [c^2 s*c -c^2 -s*c; ...
    s*c s^2 -s*c -s^2; ...
    -c^2 -s*c c^2 s*c; ...
    -s*c -s^2 s*c s^2];
K34 = K_temp*((E*A34)/L_34);
T_34 = [c s 0 0; ...
    -s c 0 0; ...
    0 0 c s; ...
    0 0 -s c];

%% Merge

K_Big_14 = zeros(8,8);
K_Big_14(1:2,1:2) = K14(1:2,1:2); % GOOD
K_Big_14(1:2,7:8) = K14(1:2,3:4); % GOOD
K_Big_14(7:8,1:2) = K14(3:4,1:2); % GOOD
K_Big_14(7:8,7:8) = K14(3:4,3:4); % GOOD

K_Big_24 = zeros(8,8);
K_Big_24(3:4,3:4) = K24(1:2,1:2); % GOOD
K_Big_24(3:4,7:8) = K24(1:2,3:4); % GOOD
K_Big_24(7:8,3:4) = K24(3:4,1:2); % GOOD
K_Big_24(7:8,7:8) = K24(3:4,3:4); % GOOD

K_Big_34 = zeros(8,8);
K_Big_34(5:6,5:6) = K34(1:2,1:2); % GOOD
K_Big_34(5:6,7:8) = K34(1:2,3:4); % GOOD
K_Big_34(7:8,5:6) = K34(3:4,1:2); % GOOD
K_Big_34(7:8,7:8) = K34(3:4,3:4); % GOOD

Master_Stiffness = K_Big_14 + K_Big_24 + K_Big_34;

%% Generate Boundary Conditions and Displacement Solution

U_Matrix = zeros(8,1);
U34 = Master_Stiffness(7:8,7:8)\[0; Force];
U_Matrix(7:8,1) = U34;

%% Find Reaction Forces
f = Master_Stiffness*U_Matrix;

%% Find The U Bar Values
U_14_Hold = [U_Matrix(1:2); U_Matrix(7:8)];
U_Bar_14 = T_14*U_14_Hold;

U_24_Hold = [U_Matrix(3:4); U_Matrix(7:8)];
U_Bar_24 = T_24*U_24_Hold;

U_34_Hold = [U_Matrix(5:6); U_Matrix(7:8)];
U_Bar_34 = T_34*U_34_Hold;

%% Find Internal Forces

d1 = U_Bar_14(3) - U_Bar_14(1);
F1 = (E*A14*d1)/L_14;

d2 = U_Bar_24(3) - U_Bar_24(1);
F2 = (E*A24*d2)/L_24;

d3 = U_Bar_34(3) - U_Bar_34(1);
F3 = (E*A34*d3)/L_34;