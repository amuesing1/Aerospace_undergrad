close all
clear all
clc

V_inf=50;
n=150; %panels
i=1;
%NACA digits
first=4;
second=4;
last_two=12;

% turns airfoil name into string for graphs
name=horzcat(first,second,last_two);
name=num2str(name);
name= name(find(~isspace(name)));
i=1;
for alpha=[-5,0,5,10]
a(i)=alpha;
[x_whole,y_whole,x_upper,x_lower]=airfoils(n,first,second,last_two);

Cp_source(i,:)=Source_Panel(x_whole,y_whole,V_inf,alpha,x_upper,x_lower,x_whole,name);
[Cl(i),Cp_vortex(i,:)]=Vortex_Panel(x_whole,y_whole,V_inf,alpha,x_upper,x_lower,x_whole,name);
i=i+1;
end

%Error
Ideal_Lift_Slope = 2*pi;
Lift_Slope = (max(Cl) - min(Cl))/(max(a*pi/180) - min(a*pi/180));
Error_Slope = 100*abs((Lift_Slope - Ideal_Lift_Slope)/Ideal_Lift_Slope)

figure
hold on
plot(a,Cl)
hline(0,'black-.')
vline(0,'black-.')
title(sprintf('NACA %s Coefficient of Lift',name))
xlabel('\alpha')
ylabel('C_l')