%%Longitudinal Matrix

Alon = [X_u/m X_w/m 0 -g*cos(theta0);...
    Z_u/(m-Z_w_dot) Z_w/(m-Z_w_dot) (Z_q + m*u0)/(m - Z_w_dot) -m*g*sin(theta0)/(m-Z_w_dot);...
    1/ap.Iy*(M_u + M_w_dot*Z_u/(m - Z_w_dot)) 1/ap.Iy*(M_w + M_w_dot*Z_w/(m-Z_w_dot))...
    1/ap.Iy*(M_q + M_w_dot*(Z_q + m*u0)/(m-Z_w_dot))...
    -M_w_dot*m*g*sin(theta0)/(ap.Iy*(m-Z_w_dot));
    0 0 1 0];
DeltaX_E = zeros(4,1);
DeltaZ_E = [X_z/m; Z_z/m; 1/ap.Iy*(M_z + M_w_dot*Z_z/(m - Z_w_dot)); 0];

Aad = [Alon, DeltaX_E, DeltaZ_E; ...
       1 0 0 0 0 0;...
       0 1 0 -u0 0 0];
Bad = zeros(6,1);

%%Lateral Matrix

Alat = [Yv/m Yp/m (Yr/m - u0) g*cos(theta0);...
    Gamma3*Lv+Gamma4*Nv Gamma3*Lp+Gamma4*Np Gamma3*Lr+Gamma4*Nr 0;...
    Gamma4*Lv+Gamma8*Nv Gamma4*Lp+Gamma8*Np Gamma4*Lr+Gamma8*Nr 0;...
    0 1 tan(theta0) 0];
Ayaw = [Alat zeros(4,2);...
    0 0 sec(theta0) 0 0 0;...
    1 0 0 0 u0*cos(theta0) 0];

Byaw = zeros(6,1);
