% Purpose: The purpose of the problem is to solve through multiple methods,
% the time it takes for a 1m length Copper rod to cool to a safe to touch 
% temperature through transient heat conduction from 100? to 45? 
% transferring heat to two ice baths on either end.

% Inputs: None
% Outputs: output.txt

% Assumptions: We assume that the water is boiling at exactly 100? at 
% standard temperature and pressure at sea level. We assume the rod is 
% perfectly insulated along it’s length so that no heat transfers between 
% the rod and the air. We also assume that the Copper rod is perfect 
% meaning that it has consant density and no imperfections that could 
% affect the rate of heat transfer along the rod.

% UID:840848bb094f

% Date Created: 11/24/14
% Date Modified: 


clear all
close all
clc
%initial conditions
k=401; % thermal conductivity (W/mK)
rho=8940; % kg/m^3
c=390; % specific heat (J/kgK)
kappa=k/(rho*c); % thermal diffusivity
Ti=100; % initial temperature
dt=.4; % change in time
dx=.01; % change in distance
Time=4000; % seconds

% numerical solution
Tempn=zeros(Time/dt,1/dx+1); %allocating space
indexpos=Tempn;
indextime=Tempn;
Tempn(1,:)=Ti; % setting bar to initial temperature
Tempn(:,1)=0; % seting ends to initial temperature
Tempn(:,1/dx+1)=0;
for j=1:Time/dt-1
    for i=2:1/dx % solving conservation of energy
        mid=(Tempn(j,i+1)-2*Tempn(j,i)+Tempn(j,i-1))/(dx^2);
        forward=kappa*mid;
        Tempn(j+1,i)=forward*(dt)+Tempn(j,i);
        indexpos(j,i)=dx*i; %creating position and time arrays
        indextime(j,i)=dt*j;
    end
end
val1 = 45; %value to find
tmp = abs(Tempn(:,(1/dx)/2+1)-val1);
[idx idy] = min(tmp); %index of closest value
closestx1 = indextime(idy,80); %closest value

% analytical solution
Tempa=zeros(Time,1/dx+1); 
runtimes=[40 400 2000 4000 915:917];
for x=0:dx:1
    i=x*(1/dx)+1;
    i=round(i);
    if x==0|x==1
        funxi=0;
    else
        funxi=100;
    end
    for t=runtimes
        for n=1:15
            fun = @(y)funxi*sin(pi*n*y);
            Tempa(t,i)=Tempa(t,i)+(2*integral(fun,0,1)*sin(pi*n*x)*exp(-kappa*(pi*n)^2*t));
        end
    end
end
val1 = 45; %value to find
tmp = abs(Tempa(:,(1/dx)/2)-val1);
[idx idy] = min(tmp); %index of closest value
closestx2 = idy; %closest value

% comparison
for i=1:4
    comparen(i,:)=Tempn(runtimes(i)/dt,:);
    comparea(i,:)=Tempa(runtimes(i),:);
end
compare=comparen-comparea;
percentage=compare./comparen*100;
for i=1:4
    error(i)=abs(max(percentage(i,:)));
end

% instability
for dt=.4:.01:.5 % varriying dt
size=dt*1000;
size=round(size);
Tempi=zeros((size),1/dx+1); %allocating space
indexposi=Tempi;
indextimei=Tempi;
Tempi(1,:)=Ti; % setting bar to initial temperature
Tempi(:,1)=0; % seting ends to initial temperature
Tempi(:,1/dx+1)=0;
for j=1:size-1
    for i=2:1/dx % solving conservation of energy
        mid=(Tempi(j,i+1)-2*Tempi(j,i)+Tempi(j,i-1))/(dx^2);
        forward=kappa*mid;
        Tempi(j+1,i)=forward*(dt)+Tempi(j,i);
        indexposi(j,i)=dx*i; %creating position array
    end
end
i=(dt-.4)*100+1; % for assignment
i=round(i);
    Tempunstable(i,:)=Tempi(100,:); % separate array for data at 20s
end


% graphing
x=linspace(0,1,101);

figure(1)
surf(indexpos(1:5000,:),indextime(1:5000,:),Tempn(1:5000,:),'EdgeColor','none')
title('Temperature of Bar with Respect to Position and Time')
xlabel('Position on Rod (m)')
ylabel('Time (s)')
zlabel('Temperature (C)')

figure(2)
plot(runtimes(1:4),error)
title('% Error of Numerical Method at Specified Times')
xlabel('Time (s)')
ylabel('% Error in Numerical Method')

figure(3)
plot(x,compare)
title('Difference Between Numerical and Analytical')
xlabel('Position (m)')
ylabel('numerical-analytical (C)')
legend('40s','400s','2000s','4000s')

figure(4)
plot(indexposi(1,:),Tempunstable(4,:),indexposi(1,:),Tempunstable(5,:),indexposi(1,:),Tempunstable(6,:))
title('Instability as dt Changes')
xlabel('Position (m)')
ylabel('Temperature (C)')
legend('0.42','0.43','0.44')

% output times
fileID = fopen('output.txt','w');
fprintf(fileID,'Numerical time for safe to touch = %.2f seconds\n',closestx1);
fprintf(fileID,'And\n');
fprintf(fileID,'Analytical time for safe to touch = %.2f seconds\n',closestx2);
fprintf(fileID,'Error In Times:\n');
fprintf(fileID,'At 40 seconds: %1f %%\n',error(1));
fprintf(fileID,'At 400 seconds: %1f %%\n',error(2));
fprintf(fileID,'At 2000 seconds: %1f %%\n',error(3));
fprintf(fileID,'At 4000 seconds: %1f %%\n',error(4));
fclose(fileID);
