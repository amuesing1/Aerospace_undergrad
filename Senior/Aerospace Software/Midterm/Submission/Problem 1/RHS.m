function f = RHS(t,y,CD,r,m)

% Density
rho = 1.275;

% Surface Area
A = pi*r^2;

% Gravitational Coefficient
g = -9.81;

% Velocity
vel_x = y(1);
vel_y = y(2);

% Drag
D = 0.5*CD*rho*(vel_x^2+vel_y^2)*A;

% Angle of velocity
theta = atan2(vel_y,vel_x);

% RHS vector
f(1,1) = -D*cos(theta)/m;
f(2,1) = -D*sin(theta)/m+g;
f(3,1) = vel_x;
f(4,1) = vel_y;
f(5,1) = r;
end