
%%
h0 = 250;
r1 = 100;
y = 150;
r2 = r1 - 50;
L = 3; % length of the connection

angle = 45;

%%
[x,y] = First_section(r1,y);
plot(x,y)

hold on
%%
x0 = x(end);
y0 = y(end);
[x,y] = connection(x0,x0 + L, y0);

plot(x,y)

%%
x0 = x(end);
[x,y] = Loop(r2,x0,y0);

plot(x,y)

%%
x0 = x(end);
y0 = y(end);
[x,y] = ZeroG(h0,angle,x0,y0);

plot(x,y)