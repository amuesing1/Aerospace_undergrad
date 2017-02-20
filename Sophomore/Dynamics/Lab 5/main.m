clear all
close all
clc
data=load('3pm Masses demo');

I=165; % lbm-in^2
R=4.25; % in
m=2*.275; %lbm (two of them)

%metric
% I=0.04828554281582; %km*m^2
% R=0.10795; %m
% m=2*0.1247; %kg

meanrpm=mean(data(1:200,2));
w0=(meanrpm*2*pi)/60;
w0_sim=(100*2*pi)/60;
t=data(:,1);

wdata=(data(:,2)*2*pi)/60;

C=I/(m*R^2)+2;
w=w0.*(C-w0^2.*t.^2)./(C+w0^2.*t.^2);
w_sim=w0_sim.*(C-w0^2.*t.^2)./(C+w0^2.*t.^2);
alpha=w0.*((-2*w0^2.*t).*(C+w0^2.*t.^2)-(2.*w0^2.*t).*(C-w0^2.*t.^2))./((C+w0^2.*t.^2).^2);
time1=ones([size(t),1]);
time1(1)=0;
for i=1:size(time1)-1
    time1(i+1)=.01*i;
end
%T=m*w.^2*R.*sin(w0_sim.*time1);
T=1./(2.*R).*I.*alpha;

dw = diff(wdata);
dt = diff(t);
dw_dt = dw./dt;

J = find(dw_dt < -15);
j = find(wdata==0);
k = find(w==0);

count=1;
for i=J(1):j(1)
    omega_data(count)=wdata(i);
    time(count)=t(i);
    if w(count)<=0
        w(count)=0;
    end
    if w_sim(count)<=0
        w_sim(count)=0;
    end
    omega_calc(count)=w(count);
    omega_sim(count)=w_sim(count);
    count=count+1;
end
tension(1,:)=T(1:count-1);
time=time-3.07;

%graphing
figure()
hold on
plot(time,omega_data)
plot(time,omega_calc,'r')
xlabel('time')
ylabel('angular velocity')
legend('class data', 'model')

figure()
plot(time,omega_sim)

figure()
plot(time,tension)
xlabel('time')
ylabel('Force (N)')