close all
clear all
clc

n=100; %panels

%NACA digits
first=4;
second=4;
last_two=12;

%parameters of the arifoil from NACA identification
m=first/100;
p=second/10;
t=last_two/100;
c=1;
pc=p*c;

%constants for thickness
a0=.2969;
a1=-0.126;
a2=-0.3516;
a3=0.2843;
a4=-0.1015;

%finding camber line
i=1;
for x=0:c/n:pc
    yc1(i)=m*(x/p^2)*(2*p-(x/c));
    dyc1(i)=(2*m*(c*p-x))/(c*p^2);
    xc1(i)=x;
    i=i+1;
end
i=1;
for x=pc:c/n:c
    yc2(i)=m*((c-x)/(1-p)^2)*(1+(x/c)-2*p);
    dyc2(i)=(2*m*(c*p*x-(x^2/2)))/(c*(p-1)^2);
    xc2(i)=x;
    i=i+1;
end

%concatenate
yc=horzcat(yc1,yc2);
xc=horzcat(xc1,xc2);
dyc=horzcat(dyc1,dyc2);

%finding shape of airfoil
x=linspace(0,c,n);
for i=1:length(x)
    yt(i)=5*t*c*(a0*sqrt(x(i)/c)+a1*(x(i)/c)+a2*(x(i)/c)^2+a3*(x(i)/c)^3+a4*(x(i)/c)^4);
    theta(i)=atan(dyc(i));
    x_upper(i)=x(i)-yt(i)*sin(theta(i));
    x_lower(i)=x(i)+yt(i)*sin(theta(i));
    y_upper(i)=yc(i)+yt(i)*cos(theta(i));
    y_lower(i)=yc(i)-yt(i)*cos(theta(i));
end

%concatenate
x_whole=horzcat(x_upper,fliplr(x_lower));
y_whole=horzcat(y_upper,fliplr(y_lower));

%calc Cp
V_inf=50;
alpha=0;
Cp=source_panel(x_whole,y_whole,V_inf,alpha);

%plot
figure(1)
plot(xc,yc)
hold on
plot(x_whole,y_whole)
axis equal
hold off

figure(2)
plot(x_whole(1:2*n-1)/c,Cp)
axis equal