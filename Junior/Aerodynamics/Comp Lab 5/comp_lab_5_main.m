close all
clear all
clc

N=40; %steps

b=40; %ft (span)
c_t=2; %ft (tip)
c_r=6; %ft (root)
aero_t=-.5; %deg (tip)
aero_r=-1.25; %deg (root)
geo_t=4; %deg (tip)
geo_r=7; %deg (root)
S=b*(c_t+c_r)/2; %span

[e,c_L,c_Di,delta]=PLLT(b,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N);

rho=2.3769*10^(-3); %slug/ft^3
v=130; %mph
v=(v*5280)/3600; %ft/s
q_inf=.5*rho*v^2;
L=c_L*q_inf*S;
Di=c_Di*q_inf*S;

% N=5000
exact_L=4954.87904029189;
exact_Di=114.746191599392;

% Problem 2
Error_L=100*abs((exact_L-L)/exact_L);
Error_Di=100*abs((exact_Di-Di)/exact_L);

% Problem 3
i=1;
for AR=[4 6 8 10]
    j=1;
    S=(b^2)/AR;
    % chosing c_t, solving for c_r based on AR
    for c_t=linspace(0.000001,4,100)
        % using ratio above
        c_r(j) = 2*S/b - c_t;
        [e,c_L,c_Di,delta]=PLLT(b,c_t,c_r(j),aero_t,aero_r,geo_t,geo_r,N);
        eff(i,j)=e;
        delta_graph(i,j)=delta;
        ratio(j)=c_t/c_r(j);
        j=j+1;
    end
    i=i+1;
end

figure
hold on
for i=1:4
    plot(ratio,eff(i,:));
end
ylabel('Span efficiency factor (e)')
xlabel('Ratio c_t/c_r')
legend('AR=4','=6','=8','=10')
title('Span Efficiency Over Taper Ratio')
hold off

figure
hold on
for i=1:4
    plot(ratio,delta_graph(i,:));
end
ylabel('Induced Drag factor (\delta)')
xlabel('Ratio c_t/c_r')
legend('AR=4','=6','=8','=10')
title('Induced Drag Factor Over Taper Ratio')
hold off