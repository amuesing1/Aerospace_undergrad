close all
clearvars
clc

data = csvread('hum.csv');

p = polyfit(data(:,1),data(:,2),3);

x=linspace(data(1,1),data(end,1),length(data));
% y=p(1)*x+p(2);
y=p(1)*x.^3+p(2)*x.^2+p(3)*x+p(4);
error=100*mean(abs(((data(:,2)-y')./data(:,2))));
deviation=std(data(:,2)-y');

z=linspace(100,0,1000);
alpha=p(1)*z.^3+p(2)*z.^2+p(3)*z+p(4);

figure
hold on
plot(data(:,1),data(:,2))
plot(x,y)
plot(z,alpha,'--')
hold off

figure
plot(z,alpha)