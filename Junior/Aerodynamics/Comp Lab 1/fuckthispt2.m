clear all
close all
clc
load Cp
c=0.5; %m
alpha=9; %degrees
V_inf=20; %m/s
rho_inf=1.225; %kg/m^3
p_inf=10.13e4; %Pa
q_inf=.5*rho_inf*V_inf^2; %Pa
n=1000; %number of steps
step=c/n; %step size

y=linspace(0,.5,n);
i=1;
for x=y(1):step:y(length(y))
    p_upper(i)=fnval(Cp_upper, x/c);
    p_lower(i)=fnval(Cp_lower, x/c);
    y_t(i)=((12*c)/100)*(0.2969*sqrt(x/c)-0.1260*(x/c)-0.3516*(x/c)^2+0.2843*(x/c)^3-0.1036*(x/c)^4);
    i=i+1;
end
trap_rule_cn=0;
trap_rule_ca=0;

dir_y_t=diff(y_t)/step;
dyu=dir_y_t;
dyl=-dir_y_t;

k=1;
for k=1:n-1
    trap_rule_cn=trap_rule_cn+(y(k+1)-y(k))*(((p_lower(k)-p_upper(k))+(p_lower(k+1)-p_upper(k+1)))/2);
    trap_rule_ca=trap_rule_ca+(y(k+1)-y(k))*(((p_upper(k)*dyu(k)-p_lower(k)*dyl(k))+(p_upper(k+1)*dyu(k+1)-p_lower(k+1)*dyl(k+1)))/2);
    k=k+1;
end
trap_rule_cn=trap_rule_cn/c;
trap_rule_ca=trap_rule_ca/c;

Cl=trap_rule_cn*cos(alpha)-trap_rule_ca*sin(alpha);
Cd=trap_rule_cn*sin(alpha)+trap_rule_ca*cos(alpha);

L_prime=Cl*p_inf*c;
D_prime=Cd*q_inf*c;




% fun = @(x) p_lower(x)-p_upper;

figure()
plot(y/c,-p_upper(1:1000))
hold on
plot(y/c,-p_lower(1:1000))
legend('upper','lower')

figure()
plot(y,y_t(1:1000))
hold on
plot(y,-y_t(1:1000))