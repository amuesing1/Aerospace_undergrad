function [Y] = traj(t, Y0, model)
global rho_amb u_k C_D s a_b P_0 V_0 T_0 R v_wind rho_Prop P_a discharge_coeff A_t g Force_x volume_bottle theta thrust launch_length Massair_i dmdt MassB
%Thermodynamic model of bottle rocket
x = Y0(1);
y = Y0(2);
z = Y0(3);
vx = Y0(4);
vy = Y0(5);
vz = Y0(6);
V = Y0(7);
mair = Y0(8);
mr = Y0(9);

position = [x,y,z];
velocity = [vx,vy,vz];

F = 0;
dVdt = 0;
dmrdt = 0;
dmadt = 0;

switch model
	case 'thermo'
		[F, dVdt, dmrdt, dmadt] = thermo(Y0);
	case 'isp'
		% Do nothing, all are zero
	case 'inter'
		[F, dmrdt] = inter(t);
end

% fprintf('%.4f | %s\n', t, num2str(Y0',3))
if ~isreal(Y0), error('Data went imaginary at t=%f', t), end

if mr <= MassB
	mr = MassB;
	dmrdt = 0;
end

%Use the information just calculated to solve trajectory equations
if z < (launch_length * sin(theta))
	% PRIMED AND READY
	v_rel = [1,0,sin(theta)];
	v_dir = v_rel./norm(v_rel); %Unit vector for the velocity
	q_inf = 0.5*rho_amb*norm(velocity)^2; %Dynamic pressure
	
	%Calculate the resisting forces (Rail friction and Drag)
	N = mr * -g * cos(theta); %Normal force on the bottle
	f_rail = u_k *N; %DEFINE u_k!!! Friction due to the rail
	D = q_inf * a_b * C_D; %MAKE s A GLOBAL!!! Drag due to air
	
	%Add resistive forces
	D = D + f_rail;
else
	%WEEEEEEEEEEEEEEEEEEEEEEEEEEEEE!
	v_rel = velocity - v_wind; %STILL NEED THE WIND make it a global in the constants area
	v_dir = v_rel./norm(v_rel);
	q_inf = 0.5 * rho_amb * norm(v_rel)^2;
	D = q_inf * a_b * C_D;	
end

if z < (launch_length * sin(theta)) && (abs(vz) < 0.1)
	F_G = 0;
else
	F_G = mr*g;
end

%Calculate the forces exxperienced in x,y and z
F_x = (F - D) * v_dir(1);
F_y = (F - D) * v_dir(2);
F_z = (F - D) * v_dir(3) - F_G;

%Find the accelerations in x,y, and z
A_x = F_x./mr;
A_y = F_y./mr;
A_z = F_z./mr;

%Set the velocities equal to the change in position
dxdt = velocity(1);
dydt = velocity(2);
dzdt = velocity(3);

%%Return everything
Y = Y0;
Y(1) = dxdt;
Y(2) = dydt;
Y(3) = dzdt;
Y(4) = A_x;
Y(5) = A_y;
Y(6) = A_z;
Y(7) = dVdt;
Y(8) = dmadt;
Y(9) = dmrdt;
end