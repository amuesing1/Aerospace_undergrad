close all; clear all; clc
gps=GPS_parser('GPSLOG04.TXT','GPS_stationary');
[x,y,z]=lla2ecef(gps.lat,gps.long,gps.alt);
lat_actual=40.00735771;
lon_actual=-105.26194959;
height_actual=1615.0296;
[x_actual,y_actual,z_actual]=lla2ecef(lat_actual,lon_actual,height_actual);

x_mean=mean(x);
x_std=std(x);
y_mean=mean(y);
y_std=std(y);
z_mean=mean(z);
z_std=std(z);

figure
hold on
subplot(311)
plot(1:length(x),x,'r')
refline(0, x_actual)
axis([0 215 -8.25*10^4 -6.6*10^4])
legend('Data', 'Reference Value');
xlabel('Time, s');
ylabel('x_{EC}, m');
str1=sprintf('Static x values: mean=%0.4e, StdDev=%0.4e',x_mean, x_std);
title(str1);
subplot(312)
plot(1:length(y),y,'r')
refline(0, y_actual)
axis([0 215 -4.305*10^6 -4.295*10^6])
legend('Data', 'Reference Value','Location', 'SouthEast');
xlabel('Time, s');
ylabel('y_{EC}, m');
str2=sprintf('Static y values: mean=%0.4e, StdDev=%0.4e',y_mean, y_std);
title(str2);
subplot(313)
plot(1:length(z),z,'r')
refline(0, z_actual)
axis([0 215 4.69*10^6 4.705*10^6])
legend('Data', 'Reference Value','Location', 'SouthEast');
xlabel('Time, s');
ylabel('z_{EC}, m');
str3=sprintf('Static z values: mean=%0.4e, StdDev=%0.4e',z_mean, z_std);
title(str3);
