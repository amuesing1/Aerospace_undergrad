clc
clf

r = 100;
x1 = 0:.1:450;

y1 = -sqrt(r^2-(x1-r).^2)+r;
plot(x1,y1)

hold on
%%
t=450;
a = find(x1==t);
i = y1(a);

x2 = t:0.1:t+150; 
m = (0-i)/(600-450);

y2 = m*x2+400;
plot(x2,y2)

%%
x3 = 600:0.1:650;
l = length(x3);
y3 = zeros(1,l);
plot(x3,y3)

%%
R = 75;
theta = 0:0.001:2*pi;

x4 = R*cos(theta) + 650;
y4 = R*sin(theta) + R;
plot(x4,y4)

%%

x5 = 650:0.01:700;
L = length(x5);
y5 = zeros(1,L);
plot(x5,y5)

%%
h = r;
g = 9.81;

angle = 45; % degrees
V0 = sqrt(2*g*h); % by conservationn of energy

Vx0 = V0 * cos(angle);
Vy0 = V0 * sin(angle);

t = 0:0.01:2*Vy0/g;

x6 = Vx0 .* t + 700;
y6 = Vy0 .* t - 0.5 * g * t.^2;

plot(x6,y6)








hold off