function[std_res, mean_res, std_mean_res, obs, num_res_3] = execute(volts,globalr,globald,globall)

[omega, theta, theta_deg, v_actual, emptyfile] = loadfile(volts);

if ~emptyfile
    beta = asin((globald-(globalr.*sin(theta)))./globall);
    v_predicted = -globalr.*omega.*(sin(theta) + cos(theta).*tan(beta));
else
    disp('File is empty, and globals are awesome.')
end
res=(v_actual-v_predicted)*100;

[std_res, mean_res, std_mean_res, obs, num_res_3] = tablefun(res);

figure()
subplot(2,2,1)
plot(theta_deg,omega)
xlabel('Theta (deg)')
ylabel('Angular Speed (rad/s)')
title('Theta vs Omega')
set(gca,'XMinorTick','on')
subplot(2,2,2)
hold on;
plot(theta_deg,v_actual*100,'r')
plot(theta_deg,v_predicted*100,'k')
xlabel('Theta (deg)')
ylabel('Velocity (cm/s)')
title('Theta vs Velocity')
legend('Actual','Predicted')
set(gca,'XMinorTick','on')
hold off;
subplot(2,2,3)
plot(theta_deg,res)
xlabel('Theta (deg)')
ylabel('Residual Collar Speed (cm/s)')
title('Theta vs Residual Collar Speed')
set(gca,'XMinorTick','on')
subplot(2,2,4)
histfit(res)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','w','EdgeColor','k')
ylabel('Number of Data Points')
xlabel('Residual Collar Speeds (cm/s)')
title('Histogram of Residual Speeds')
end