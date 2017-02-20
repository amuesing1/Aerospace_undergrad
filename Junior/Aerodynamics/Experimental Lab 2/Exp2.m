%% ASEN Experimental Lab 2
% Author: Jeremy Muesing
% Date: 11/20/15

close all
clear all
clc


%% Data collection

no_data_strip_one=load('nostrip1');
no_data_strip_one=no_data_strip_one(21:end,:);
no_data_strip_two=load('nostrip2');
data_strip_one=load('strip1');
data_strip_two=load('strip2');

rho_no_strip_one=no_data_strip_one(:,3);
rho_no_strip_two=no_data_strip_two(:,3);
rho_strip_one=data_strip_one(:,3);
rho_strip_two=data_strip_two(:,3);

v_inf_no_strip_one=no_data_strip_one(:,4);
v_inf_no_strip_two=no_data_strip_two(:,4);
v_inf_strip_one=data_strip_one(:,4);
v_inf_strip_two=data_strip_two(:,4);

q_no_strip_one=no_data_strip_one(:,6);
q_no_strip_two=no_data_strip_two(:,6);
q_strip_one=data_strip_one(:,6);
q_strip_two=data_strip_two(:,6);

x_no_strip_one=no_data_strip_one(:,27);
x_no_strip_two=no_data_strip_two(:,27);
x_strip_one=data_strip_one(:,27);
x_strip_two=data_strip_two(:,27);

y_no_strip_one=no_data_strip_one(:,28);
y_no_strip_two=no_data_strip_two(:,28);
y_strip_one=data_strip_one(:,28);
y_strip_two=data_strip_two(:,28);

offset_no_strip_one=min(y_no_strip_one);
offset_no_strip_two=min(y_no_strip_two);
offset_strip_one=min(y_strip_one);
offset_strip_two=min(y_strip_two);

y_no_strip_one=y_no_strip_one-offset_no_strip_one;
y_no_strip_two=y_no_strip_two-offset_no_strip_two;
y_strip_one=y_strip_one-offset_strip_one;
y_strip_two=y_strip_two-offset_strip_two;


%% Constants

mu=1.846E-5; %kg/ms (dynamic viscosity at temp) (engineering toolbox)
v=1.568E-5; %m^2/s (kinematic viscosity at tmep) (engieering toolbox)

i=1;
for trial={'one','two'}
    for strip={'_','_no_'}
        rho=eval(cell2mat(strcat('rho',strip,'strip_',trial)));
        v_inf=eval(cell2mat(strcat('v_inf',strip,'strip_',trial)));
        q=eval(cell2mat(strcat('q',strip,'strip_',trial)));
        x=eval(cell2mat(strcat('x',strip,'strip_',trial)))/1000;
        y=eval(cell2mat(strcat('y',strip,'strip_',trial)))/1000;
        
        Re=rho.*v_inf.*x/mu;
        velocity=sqrt(q.*2.*rho);
        
        
        %% Boundary layer thickness (Question 1)
        strip=cell2mat(strip);
        if strip=='_'
            delta_all=(0.37*x)./((Re).^(1/5));
        elseif strip=='_no_'
            delta_all=(5*x)./sqrt(Re);
        end
        delta(i)=mean(delta_all);
        
        %% Scaled velocity component (Question 2)
        scaled_velocity(:,i)=velocity./v_inf;
        scaled_vertical_distance(:,i)=y.*sqrt(v_inf./(v.*x));
        
        %% Displacement thickness (Question 4)
        delta_star(i)=mean(trapz(y,(1-(velocity/v_inf))));
        delta_star_blasius(i)=mean((1.72.*x)./sqrt(Re));
        
        
        i=i+1;
    end
end


%% Boundary layer transition (Question 3)

Re_cr=500000;
rho=mean(rho_no_strip_one); %density is constant, doesn't matter which one
v_inf=mean(v_inf_no_strip_one);
x_cr=(Re_cr*mu)/(rho*v_inf);


%% Plotting

%stright lines
x_graph_tur=[mean(x_strip_one),mean(x_strip_two)];
x_graph_lam=[mean(x_no_strip_one),mean(x_no_strip_two)];
delta_tur=[delta(1),delta(3)];
delta_lam=[delta(2),delta(4)];
delta_star_lam=[delta_star(2),delta_star(4)];
delta_star_blas_lam=[delta_star_blasius(2),delta_star_blasius(4)];

% Question 1
figure
hold on
plot(x_graph_tur,delta_tur,'*-')
plot(x_graph_lam,delta_lam,'*-')
legend('turbulent','laminar')
xlabel('Distance along Surface (mm)')
ylabel('Boundary Layer Distance (m)')
title('Boundary Layer Thickness')
hold off

% Question 2
figure
hold on
plot(scaled_velocity(:,2),scaled_vertical_distance(:,2),'-.')
plot(scaled_velocity(:,4),scaled_vertical_distance(:,4),'-.')
legend('x=66mm','x=133mm')
xlabel('Scaled velocity component (u/u_e)')
ylabel('Scaled vertical distance \eta')
title('Laminar Velocity Profiles')
hold off

% Question 4
figure
hold on
plot(x_graph_lam,delta_star_lam,'*-')
plot(x_graph_lam,delta_star_blas_lam,'*-')
legend('laminar','Blasius laminar')
xlabel('Distance along Surface (mm)')
ylabel('Displacement Thickness (m)')
title('Displacement Thickness')
hold off
