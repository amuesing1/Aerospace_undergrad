function [tfin,xfin,yfin]=simulate_projectile(x0,y0,vx0,vy0,m,r,CD,e,n)
% Set simulation options
options = odeset('Events',@event_checker,'RelTol', 1e-8);
tspan = [0 1e10];
y_init = [vx0; vy0; x0; y0; r];
xfin=[];
yfin=[];
tfin=[];
tend=0;
counter=0;

while counter<n
    [t,y,te,~,~] = ode45(@(t,y)RHS(t,y,CD,r,m),tspan,y_init,options);
    y_init(1)=y(end,1);
    y_init(2)=-e*y(end,2);
    y_init(3)=y(end,3);
    y_init(4)=y(end,4);
    
    xfin=[xfin;y(:,3)];
    yfin=[yfin;y(:,4)];
    tfin=[tfin;t+tend];
    tend=tfin(end)+te;
    counter=counter+1;
end
end