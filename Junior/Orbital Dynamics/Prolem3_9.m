clc
close all
clearvars

%% Problem 9

rp = 7000; % km
ra = 10000; % km
e = (ra - rp)/(rp + ra);
a = (ra + rp)/2;
mu = 398600;
T = sqrt(4*(pi^2)*(a^3)/mu); % s
h = sqrt(rp*mu*(1+e));
t1 = 0.5; % hours
t1 = t1*60*60; % sec
t2 = 1.5; % hours
t2 = t2*60*60; % seconds

Me1 = (t1*2*pi) / T;
Me2 = (t2*2*pi) / T;

E1 = Me1 + e/2;

for i = 1:10000
    if i == 1
        E1 = Me1 + e/2;
    else
        E1 = E1_next;
    end
    E1_next = E1 - (E1 - e*sin(E1) - Me1)/(1 - e*cos(E1));
    if E1/E1_next < 10^(-6)
        break
    end
end

E1 = E1_next;

E2 = Me2 - e/2;

for i = 1:10000
    if i == 1
        E2 = Me2 + e/2;
    else
        E2 = E2_next;
    end
    E2_next = E2 - (E2 - e*sin(E2) - Me2)/(1 - e*cos(E2));
    if E2/E2_next < 10^(-6)
        break
    end
end

E2 = E2_next;

theta1 = 2*atan(sqrt((1 + e)/(1 - e))*tan(E1/2));

theta2 = 2*atan(sqrt((1 + e)/(1 - e))*tan(E2/2));

if theta1 < 0
    theta1 = theta1 + 2*pi;
end
if theta2 < 0
    theta2 = theta2 + 2*pi;
end

delta_theta = theta2 - theta1;

delta_theta = delta_theta * (180/pi);

Area = .5*h*(t2 - t1);

% Clear for next question
clearvars

%% Problem 10
mu = 398600;
T = 14 * 60 * 60;
a = ((T^2*mu)/(4*(pi^2)))^(1/3);
rp = 10000;
ra = 2*a - rp;
e = (ra - rp)/(ra + rp);
h = sqrt(rp*mu*(1+e));

t1 = 0; % hours
t1 = t1*60*60; % sec
t2 = 10; % hours
t2 = t2*60*60; % seconds

Me1 = (t1*2*pi) / T;
Me2 = (t2*2*pi) / T;

for i = 1:10000
    if i == 1
        E1 = Me1 + e/2;
    else
        E1 = E1_next;
    end
    E1_next = E1 - (E1 - e*sin(E1) - Me1)/(1 - e*cos(E1));
    if E1/E1_next < 10^(-6)
        break
    end
end

E1 = E1_next;

for i = 1:10000
    if i == 1 && Me2 <= pi
        E2 = Me2 + e/2;
    elseif i == 1 && Me2 > pi
        E2 = Me2 - e/2;
    else
        E2 = E2_next;
    end
    E2_next = E2 - (E2 - e*sin(E2) - Me2)/(1 - e*cos(E2));
    if E2/E2_next < 10^(-6)
        break
    end
end

E2 = E2_next;

theta1 = 2*atan(sqrt((1 + e)/(1 - e))*tan(E1/2));

theta2 = 2*atan(sqrt((1 + e)/(1 - e))*tan(E2/2));

if theta1 < 0
    theta1 = theta1 + 2*pi;
end
if theta2 < 0
    theta2 = theta2 + 2*pi;
end

delta_theta = theta2 - theta1;

delta_theta = delta_theta * (180/pi);

r = ((h^2)/mu)*(1/(1+e*cos(theta2)));

v = sqrt(2*mu*(1/r - 1/(2*a)));

vr = (mu/h)*e*sin(theta2);

% Clear for next question
clearvars

%% Problem 11
rp = 7500; % km
ra = 16000; % km
theta1 = deg2rad(80); % rad
t = 40; % min
t = t*60; % sec
mu = 398600;

a = (ra + rp)/2; % km
e = (ra - rp)/(ra + rp);
h = sqrt(rp*mu*(1+e));
T = sqrt(4*(pi^2)*(a^3)/mu); % sec

E0 = 2*atan(sqrt((1-e)/(1+e))*tan(theta1/2));
M0 = E0 - e*sin(E0);
t0 = (M0/(2*pi))*T;

Me1 = (t0+t)*2*pi/(T);

for i = 1:10000
    if i == 1 && Me1 <= pi
        E1 = Me1 + e/2;
    elseif i == 1 && Me1 > pi
        E1 = Me1 - e/2;
    else
        E1 = E1_next;
    end
    E1_next = E1 - (E1 - e*sin(E1) - Me1)/(1 - e*cos(E1));
    if E1/E1_next < 10^(-6)
        break
    end
end

E1 = E1_next;

theta = 2*atan(sqrt((1+e)/(1-e))*tan(E1/2));
theta = theta * (180/pi);