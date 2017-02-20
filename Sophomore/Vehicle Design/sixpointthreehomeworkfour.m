clc
clear all
close all
S=47;
AR=6.5;
e=0.87;
W=103047;
Cd0=0.032;
rho=1.225;
%rho=.73643;
i=1;
j=1;
for alt=0:5000:40000%:1000:80000
     i=1;
for V=10:400
    [T,a,P,rho]=atmoscoesa(alt);
    Cl(i)=W/(.5*rho*(V.^2)*S);
    Cd(i)=Cd0+(Cl(i)^2)/(pi*e*AR);
    %T(i)=W/(Cl(i)/Cd(i));
    T(i)=(rho/1.225)*80596;
    Pr(i)=sqrt((2*(W^3)*(Cd(i)^2))/(rho*S*(Cl(i)^3)));
    Velocity(i)=V;
    Pa(i)=Velocity(i)*T(i);
    Drag(i)=Cd(i)*(.5*rho*(Velocity(i)^2)*S);
    Rate(i)=((T(i)*Velocity(i))-(Drag(i)*Velocity(i)))/W;
    i=i+1;
end
MaxE(j)=max(Pa-Pr);
MaxRC(j)=MaxE(j)/W;
alti(j)=alt;
j=j+1;
end

% MaxE=max(Pa-Pr)
% MaxRC=MaxE/W

figure
plot(Velocity,Pr)
hold on
plot(Velocity,Pa)

figure
plot(MaxE,alti)