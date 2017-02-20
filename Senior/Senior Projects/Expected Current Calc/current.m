close all
clear all
clc

data1 = csvread('Spectral Data.csv');
data2 = csvread('spectralresponse.csv');

% Experiemented with the most accurate power to fit data curve for both
% graphs
p1 = polyfit(data1(:,1),data1(:,2),5);
p2 = polyfit(data2(:,1),data2(:,2),4);
x=linspace(350,1100);

% Multiply together to produce expected current at each wavelength
for i=1:length(x)
    y(i) = (p1(1)*x(i).^5+p1(2)*x(i).^4+p1(3)*x(i).^3+p1(4)*x(i).^2+p1(5)*x(i)+p1(6))...
        *(p2(1)*x(i).^4+p2(2)*x(i).^3+p2(3)*x(i).^2+p2(4)*x(i)+p2(5));
end

figure
plot(data1(:,1),data1(:,2))
hold on
plot(x,p1(1)*x.^5+p1(2)*x.^4+p1(3)*x.^3+p1(4)*x.^2+p1(5)*x+p1(6))
hold off
xlabel('wavelength(nm)')
ylabel('Flux from Sun (W/m^2)')
grid on
legend('Data','Fitted Curve')
title('Flux from Sun at each Wavelength')

figure
plot(data2(:,1),data2(:,2))
hold on
% plot(x,p2(1)*x.^5+p2(2)*x.^4+p2(3)*x.^3+p2(4)*x.^2+p2(5)*x+p2(6))
plot(x,p2(1)*x.^4+p2(2)*x.^3+p2(3)*x.^2+p2(4)*x+p2(5))
hold off
grid on
xlabel('wavelength(nm)')
ylabel('Response of Photodiode (A/W)')
legend('Data','Fitted Curve')
title('Spectral Response of Photodiode')

% Area of photodiode area
y = y*6.714E-7;
figure
plot(x,y)
grid on
ylabel('Current (A)')
xlabel('wavelength(nm)')
title('Expected Current from photodiode at each Wavelength')

% Total expected current
answer = trapz(y);