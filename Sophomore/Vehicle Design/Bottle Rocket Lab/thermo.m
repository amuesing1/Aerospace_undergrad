function [F, dVdt, dmrdt, dmadt] = thermo(vars)
global rho_amb u_k C_D s a_b P_0 V_0 T_0 R v_wind rho_Prop P_a discharge_coeff A_t g Force_x volume_bottle theta thrust launch_length Massair_i
%Thermodynamic model of bottle rocket
x = vars(1);
y = vars(2);
z = vars(3);
vx = vars(4);
vy = vars(5);
vz = vars(6);
V = vars(7);
mair = vars(8);
mr = vars(9);

position = [x,y,z];
velocity = [vx,vy,vz];
%Establish the force of drag
% v_rel =
% q_inf = .5*rho_amb*v_rel^2;
% D = q_inf * C_D * a_b;

%%Phase 1

%Use an if statement that will focus on the volume of air and bottle volume

if V < volume_bottle
	P = P_0 * (V_0/V)^1.4; %New Pressure
	
	T = T_0 * (V_0/V)^(1.4-1);  %New temperature
	
	v_e = sqrt(2*(P - P_a)/rho_Prop); %exit velocity
	if ~isreal(v_e), warning('V_e in Phase 1 went imaginary'), end
	
	mf_prop = discharge_coeff * rho_Prop * A_t * v_e; %mass flow of the propelent
	
	F = mf_prop * v_e; %Thrust of first stage
	
	%Establish the rates of change
	
	dVdt = discharge_coeff * A_t * v_e; %Change in volume of the air
	
	dmrdt = -mf_prop; %Change in the mass of the rocket due to the propelant mass flow
	
	dmadt = 0; %Change in mass of the rocket due to air mass flow
	
	%calculate the isp
	%     temp = (1/g)*sqrt((2/rho_prop)*abs((P - P_a)));
	%
	%     if(isreal(temp))
	%     Isp = [Isp;(1/g)*sqrt((2/rho_prop)*abs((P - P_a)))];
	%     end
	%Record force values
	if F>0
		Force_x = [Force_x;F];
	end
	%Phase 2/3
else
	P_end = P_0*(V_0/volume_bottle)^1.4;
	P_air = P_end*(mair/Massair_i)^1.4; %Pressure of the air
	rho = mair/volume_bottle; %Density of the air
	T_air = P_air/(R*rho); %Temperature of the air
	P_crit = P_air*(2/(1.4+1))^(1.4/(1.4-1)); %Cristical pressure
	% Phase 2
	if P_air > P_a
		%P and T at the end of the water phase
		if P_crit > P_a
			%Flow is choked
			Pe = P_crit; %Exit pressure is equal to the critical pressure
			Me = 1.0; %Exit MAch is 1
			T_e = (2/(1.4+1))*T_air; % Exit temperature
			rho_e = Pe/(R*T_e); %Exit density
		else %P_crit =< P_a
			Pe = P_a; %Exit pressure is equal to the ambient pressure
			%Exit mach number calculated using the inviscid pressure relation
			Me = sqrt((2/(1.4-1)) * ((P_air/P_a)^((1.4-1)/1.4)-1));
			if ~isreal(Me), warning('Me went imaginary'), end
			T_e = T_air*(1 + ((1.4-1)/2)* Me^2); %Exit temperature
			rho_e = P_a/(R*T_e); %Exit density
		end
		
		%Model the forces
		
		v_e = Me*sqrt(1.4*R*T_e); %Velocity at the exit
		if ~isreal(v_e), warning('V_e in Phase 2 went imaginary'), end
		mf_air = discharge_coeff*rho_e*A_t*v_e; %mass flow of the air
		F = mf_air*v_e + (Pe - P_a)*A_t; %Thrust of the rocket
		temp = F/mf_air; %temporary Isp variablle of the second phase
		
		%     if F>0
		%         Force_x = [Force_x;F];%Array of all the forces
		%     end
		
		if(isreal(temp))
			%         Isp = [Isp; F/mf_air];%Array of all the Isp
		end
		p = P_air;
		%Establish the rates of change
		dmrdt = -mf_air; %Change of mass due to the mass flow of the air
		dVdt = 0;
		dmadt = -mf_air; %Change in the mass of air
	% Phase 3
	else
		dmrdt = 0;
		dVdt = 0;
		dmadt = 0;
		F = 0;
		v_e = 0;
		Me = 0;
		mf_air = 0;
	end
end
end