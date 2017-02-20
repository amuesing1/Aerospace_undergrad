function chicken_PLOT_pie(inclination,Omega,e,omega,a,time)
%This function plots individual orbital elements

%plot semi-major axis
figure
hold on
plot(time,a,'Linewidth',2)
title('J2 Semi Major Axis','FontSize',18)
xlabel('Time since Epoch (s)','FontSize',18)
ylabel('km','FontSize',18)
set(gca,'Fontsize',14)

%plot e
figure
hold on
plot(time,e,'Linewidth',2)
title('J2 Eccentricity','FontSize',18)
xlabel('Time since Epoch (s)','FontSize',18)
ylabel('Eccentricity','Fontsize',18)
set(gca,'Fontsize',14)

%plot i
figure
hold on
plot(time,inclination,'Linewidth',2)
title('J2 Inclination','FontSize',18)
xlabel('Time since Epoch (s)','FontSize',18)
ylabel('Degrees','FontSize',18)
set(gca,'Fontsize',14)

%plot RAAN
figure
hold on
plot(time,Omega,'Linewidth',2)
title('J2 Right Ascension of the Ascending Node','FontSize',18)
xlabel('Time since Epoch (s)','FontSize',18)
ylabel('Degrees','FontSize',18)
set(gca,'Fontsize',14)

%plot argument of perigee
figure
hold on
plot(time,omega,'Linewidth',2)
title('J2 Argument of Perigee','FontSize',18)
xlabel('Time since Epoch (s)','FontSize',18)
ylabel('Degrees','FontSize',18)
set(gca,'Fontsize',14)

end