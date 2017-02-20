% Inputs: Mass of bar (kg), length of bar (meters), acceleration due to
% gravity (m/s^2), initial angle of bar (rad/s), initial angular velocity
% (rad/s), time interval step size (seconds)
% Outputs: Time (s), Angular velocity (rad/s), Angular Acceleration
% (rad/s^2), Normal Force at A (Newtons), Normal Force at B (Newtons)
function [ t,omega,theta,alpha,normal_A,normal_B,pos ] = fun( mass,l,g,theta0,omega0,step )

% set inital values in array
t(1)=0;
theta(1)=theta0;
omega(1)=omega0;
alpha(1)=(3*g*sin(theta0))/(2*l);
ax(1)=.5*l*(alpha(1)*cos(theta0)-omega0^2*sin(theta0));
ay(1)=-.5*l*(alpha(1)*sin(theta0)+omega0^2*cos(theta0));
normal_A(1)=mass*ax(1);
normal_B(1)=mass*g+mass*ay(1);
pos(1,1)=18*cosd(5);
pos(1,2)=18*sind(5);
i=1;

% terminate when the normal forces at A are 0
while normal_A(i)>0
    t(i+1)=t(i)+step;
    omega(i+1)=omega(i)+alpha(i)*step;
    theta(i+1)=theta(i)+omega(i)*step;
    alpha(i+1)=(3*g*sin(theta(i)))/(2*l);
    
    % acceleration in each direction
    ay(i+1)=-.5*l*(alpha(i)*sin(theta(i))+omega(i)^2*cos(theta(i)));
    ax(i+1)=.5*l*(alpha(i)*cos(theta(i))-omega(i)^2*sin(theta(i)));

    % normal forces at each point
    normal_A(i+1)=mass*ax(i);
    normal_B(i+1)=mass*g+mass*ay(i);
    
    % position of each point
    pos(i+1,1)=18*cos(theta(i+1));
    pos(i+1,2)=18*sin(theta(i+1));
    i=i+1;
end
end
