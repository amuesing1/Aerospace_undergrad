% Lab 3
clc
clear all
close all

data = xlsread('ASEN 2001 Lab 3 Test Data');
bending = [3 4 8 9 12 13 14 15 20 21 22 23 24];
shear = [17 20];
thickness_foam = (3/4) / 39.370; % inches to meters
thickness_balsa = (1/32) / 39.370; % inches to meters
row_balsa = 0.155;% kg/m^3
E_balsa = 4.10 * 10^(9); % Pa
G_balsa = 0.166 * 10^(9); % Pa
E_foam = 1.5 * 10 ^(9); % Pa
c = (1/32 + 3/8) / 39.370; % meters

fail_bending = [];
for i = 1:size(bending,2)
    fail_bending = [fail_bending ; data(bending(i),:)];
end

fail_shear = [];
for i = 1:size(shear,2)
    fail_shear = [fail_shear; data(shear(i), :)];
end

force_shear = fail_shear(:,2);
width_shear= fail_shear(:,4);
area_foam = thickness_foam .* width_shear;
V_fail = force_shear ./ 2;

tau_fail = 3/2 .* V_fail ./ area_foam;

w = [];
for i = 1:size(bending,2)
    w = fail_bending(i,4);
end

If = w .*((thickness_foam)^3)/12;
Ib = w .*((thickness_balsa)^3) ./ 12 + w .* (thickness_balsa) .*((thickness_foam / 2)+ (thickness_balsa/2))^2;
Ib = 2 .* Ib;

M_fail = [];
for i = 1:size(bending,2)
    M_fail = [M_fail ; fail_bending(i,2) / 2 * fail_bending(i,3)];
end

sigma_fail = M_fail .* c ./ (Ib + (E_foam / E_balsa) * If);


varsigma=std(sigma_fail);

% more common to fail in bending than in shear, thus calculate FOS for
% bending failure
sigma_allow=(mean(sigma_fail)-varsigma);
FOS=mean(sigma_fail)/sigma_allow;
tau_allow=mean(tau_fail)/FOS;

L=36/39.3701;

syms x p0
q(x)=(4/39.3701)*p0*sqrt(1-(2*x/L)^2);
R=int(q,x,-L/2,L/2)/2; % calculate reaction forces for full board width
v=R-int(q,x,-L/2,x); %shear for full board width
M=int(v,x,-L/2,x); % moment for shear board width
Mzero=subs(M,x,0);
const=double(Mzero/p0);
h=thickness_foam+(2*thickness_balsa);
w=4/39.370;
If = w .*((thickness_foam)^3)/12;
Ib = w .*((thickness_balsa)^3) ./ 12 + w .* (thickness_balsa) .*((thickness_foam / 2)+ (thickness_balsa/2))^2;
Ib = 2 .* Ib;
p0_calc=sigma_allow*(Ib+(E_foam*If/E_balsa))/(const*h/2);

% Width calculation
If = ((thickness_foam)^3)/12; % I's without the width
Ib = ((thickness_balsa)^3) ./ 12 + (thickness_balsa) .*((thickness_foam / 2)+ (thickness_balsa/2))^2;
Ib = 2 .* Ib;

M = subs(M,p0,p0_calc);
wbending = M*(h/2)/(sigma_allow*(Ib+(E_foam*If/E_balsa)));

v=subs(v,p0,p0_calc);
wshear=3*v/(2*thickness_foam*tau_allow);
dist=-L/2:.01:L/2;
wbendplot=subs(wbending,x,dist);
wshearplot=subs(wshear,x,dist);
hold on;
plot(dist,wbendplot/2,'b')
plot(dist, abs(wshearplot/2),'k');
hold off
hold on
handles.fig=figure;
vplot=subs(v,x,dist);
plot(dist,-vplot);
xlabel('x');
ylabel('Shear Force');
title('Theoretical Shear Diagram');
saveas(handles.fig,'TheoShear.pdf');
hold off
hold on
handles.fig=figure;
Mplot=subs(M,x,dist);
plot(dist,Mplot);
xlabel('x');
ylabel('Bending Moment');
title('Theoretical Moment Diagram');
%saveas(handles.fig,'TheoMoment.pdf');
hold off

% %Failure Calculation
widths=zeros(2,length(dist));
widths(1,:)=double(wbendplot);
widths(2,:)=double(wshearplot);
bestwidth=max(abs(widths));
% % vfail=norm(tau_fail)*(thickness_foam+2*thickness_balsa)*bestwidth;
% vfail=norm(V_fail);
% vfailplot=zeros(size(dist));
% vfailplot(:,:)=vfail;
% plot(dist,-vfailplot);
% mfail=norm(M_fail);
% mfailplot=zeros(size(dist));
% mfailplot=mfail;
%plot(dist,mfailplot,dist,Mplot);

% calculating expected failure
% sigmadesign=Mplot.*c./(Ib.*bestwidth+(E_foam*If.*bestwidth/E_balsa));
% taudesign=vplot./(bestwidth.*h);
% i=1;
% sigcomp=double(sigmadesign);
% taucomp=double(taudesign);
% while taucomp(i)<norm(tau_fail)&&sigcomp(i)<norm(sigma_fail)&&i<length(taucomp)
%     i=i+1;
% end
% plot(dist(1:i),vplot(1:i));


% assume failure occurs at tau_fail and sigma_fail, thus calculate shear
% and moment plots necessary to create that failure
% force=stress*area
shearmax=norm(tau_fail)*bestwidth*h;
Ibest=(Ib.*bestwidth+(E_foam*If.*bestwidth/E_balsa));
bendingforcemax=(norm(sigma_fail)*Ibest)./(dist*c);
hold on
handles.fig=figure;
plot(dist,shearmax,'b',dist,abs(bendingforcemax),'r');
axis([-L/2 L/2 0 250])
xlabel('x position [m]')
ylabel('Force [N]')
title('Forces Necessary to Cause Failure')
legend('Force for Shear Failure','Force for Bending Failure','Location','SouthEast')
saveas(handles.fig,'TheoFailForce.pdf')
hold off
comp=abs(abs(shearmax)-abs(bendingforcemax));
[matchdiff,pt]=min(comp);
matchpt=dist(pt);
matchshear=shearmax(pt);
matchbendforce=bendingforcemax(pt);