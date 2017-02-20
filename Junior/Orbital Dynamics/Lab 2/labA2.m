%ASEN 3200 Lab A-2
%
%Created: 2/12/16
%Modified: 2/12/16

clearvars

%Bicycle Wheel Precession

wheel_speed = [40 40 30 23 20 15 14.5];           %[km/hr]
precession = [7.6 7.6 6.44 5.63 4.75 3.15 3.16];  %[seconds]
R = .335;                              %[m]
l = 0.17;
g = 9.81;

omega_p_exp = (2*pi)./precession;

wheel_speed = wheel_speed*(1000/3600);            %[m/s]
wheel_speed = wheel_speed/R;           %[rad/s]

k = R/sqrt(2);
k1 = k;
k = linspace(k*.67, k*1.33, 5);

omega_s = linspace(10,35);

%omega_p = zeros(length(omega_s), length(k));

figure(1)
hold on
for i = 1:length(k)
    omega_p(:,i) = (l*g)./((k(i)^2).*omega_s);
    plot(omega_s, omega_p)
    if i == 3;
        legendInfo{i} = 'I = mR^2';
    else
        legendInfo{i} = ['I = ' num2str((k(i)/(R/sqrt(2)))^2) '*mR^2']; 
    end
    if i == length(k)
        plot(wheel_speed, omega_p_exp, '*-')
        legendInfo{i+1} = ['Experimental Data'];
    end
end
xlabel('Bicycle Wheel Speed (rad/s)')
ylabel('Precession Rate (rad/s)')
h = legend(legendInfo);
%set(h,'Interpreter','latex')

T_p = (2*pi)./omega_p(:,3);

figure(2)
hold on
plot(wheel_speed, precession, '*-')
plot(omega_s, T_p)
xlabel('Bicycle Wheel Speed (rad/s)')
ylabel('Precession Period (s)')
legend('Experimental Data','Prediction for I = mR^2', 'Location', 'best')