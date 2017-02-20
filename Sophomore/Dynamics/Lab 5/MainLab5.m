clear all
close all
clc
data=load('3pm Masses demo');

I=165; % lbm-in^2
R=4.25; % in
m=2*.275; %lbm (two of them)

meanrpm=mean(data(1:200,2));
w0=(meanrpm*2*pi)/60;
t=data(:,1);

wdata=(data(:,2)*2*pi)/60;

C=I/(m*R^2)+2;
w=w0.*(C-(w0^2.*t.^2))./(C+(w0^2.*t.^2));
I = find(wdata == 0);
I2 = find(w < 0);
%alpha=w0*((-2*w0^2.*t).*(C+w0^2.*t.^2)-(2*w0^2.*t)*(C-w0^2.*t.^2))./((C+w0^2.*t.^2).^2);
T=m*w.^2*R.*sin(w0.*t);

time1 = t(1):t(I(1));
w1 = wdata(1):wdata(I(1));
time2 = t(1):t(I2(1));
w2 = w(1):w(I2(1));

t(1):t(I(1))

length(time1)
length(w1)
length(time2)
length(w2)

figure()
hold on
plot(time1,w1)
plot(time2,w2,'r')

